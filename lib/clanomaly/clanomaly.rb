require 'net/ssh/multi'
require 'logger'
require 'clanomaly'

include ClanomalyChecks

class Clanomaly
  def initialize(nodes)
    $log = Logger.new(STDOUT)
    @nodes = nodes
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

    $log.info("Installing dialog (workaround for G5K bug #4522) ...")
    $ssh.exec_aggregate("apt-get install dialog") { |stdout| stdout.split(/\n/).sort.join("\n") }

    tests = ClanomalyChecks.constants.select {|c| ClanomalyChecks.const_get(c).is_a? Class}
    tests.each do |e|
      $log.debug "Processing #{e}"
      test = Object.const_get(e).new
      test.setup
      test.run
    end
    $log.debug "Done."
  end
end
