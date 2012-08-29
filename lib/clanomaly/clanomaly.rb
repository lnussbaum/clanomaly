require 'net/ssh/multi'
require 'logger'
require 'clanomaly'

include ClanomalyChecks

class Clanomaly
  def initialize(nodes, inc_tests, exc_tests, no_ign_harmless, cmdline)
    $log = Logger.new(STDOUT)
    @nodes = nodes
    @inc_tests = inc_tests
    @exc_tests = exc_tests
    @no_ignore_harmless = no_ign_harmless
    if @nodes.empty?
      if ENV['OAR_NODEFILE']
        $log.info("Using OAR_NODEFILE")
        @nodes += IO::readlines(ENV['OAR_NODEFILE']).map { |l| l.chomp }
      else
        raise "No nodes specified!"
      end
    end
    @nodes.uniq!
    @nodes.sort!
    $log.info "Command-line parameters: #{cmdline.join(' ')}"
    $log.info "Nodes (#{@nodes.length}): #{NodeSet.fold(@nodes)}"
    @alltests = ClanomalyChecks.constants.select {|c| ClanomalyChecks.const_get(c).is_a? Class}
    $log.info "Available tests: #{@alltests.join(' ')}"
  end

  def run
    $ssh = Net::SSH::Multi::Session::new
    $ssh.use(*@nodes.map { |n| "root@#{n}" } )
    $ssh.connect!

    $log.debug("Running apt-get update on all nodes...")
    $ssh.exec_aggregate("apt-get update") { |stdout| stdout.split(/\n/).sort.join("\n") }

    @nodes = {}
    @alltests.each do |e|
      if (not @inc_tests.empty? and not @inc_tests.include?(e.to_s)) or @exc_tests.include?(e.to_s)
        next
      end
      $log.debug "Processing #{e}"
      test = Object.const_get(e).new({ :no_ignore_harmless => @no_ignore_harmless })
      test.setup
      test.run
      if test.groupable
        n = 0
        test.groups.each do |group|
          group.each do |node|
            @nodes[node] ||= {}
            @nodes[node][e] = n
          end
          n += 1
        end
      end
    end
    $log.info "Groups:"
    groups = @nodes.to_a.group_by { |e| e[1] }
    n = 1
    groups2 = groups.to_a.map { |e| [e[1].map { |f| f[0] }, e[0]] }
    ref = nil
    groups2.sort { |a,b| a[0].length <=> b[0].length }.reverse.each do |grp|
      if n == 1
        $log.info("#{n} (#{grp[0].length}): #{NodeSet::fold(grp[0])} (reference)")
        ref = grp[1]
      else
        diff = grp[1].keys.select { |k| grp[1][k] != ref[k] }.join(" ")
        $log.info("#{n} (#{grp[0].length}): #{NodeSet::fold(grp[0])} (diff: #{diff})")
      end
      n += 1
    end
    $log.debug "Done."
  end
end
