require 'net/ssh/multi'
require 'logger'
require 'clanomaly'

include ClanomalyChecks

class Clanomaly
  def initialize(nodes, inc_tests, exc_tests, no_ign_harmless)
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
    $log.info "Nodes: #{@nodes.join(' ')}"
  end

  def run
    $ssh = Net::SSH::Multi::Session::new
    $ssh.use(*@nodes.map { |n| "root@#{n}" } )
    $ssh.connect!

    $log.info("Running apt-get update on all nodes...")
    $ssh.exec_aggregate("apt-get update") { |stdout| stdout.split(/\n/).sort.join("\n") }

    tests = ClanomalyChecks.constants.select {|c| ClanomalyChecks.const_get(c).is_a? Class}
    tests.each do |e|
      if (not @inc_tests.empty? and not @inc_tests.include?(e.to_s)) or @exc_tests.include?(e.to_s)
        next
      end
      $log.debug "Processing #{e}"
      test = Object.const_get(e).new({ :no_ignore_harmless => @no_ignore_harmless })
      test.setup
      test.run
    end
    $log.debug "Done."
  end
end
