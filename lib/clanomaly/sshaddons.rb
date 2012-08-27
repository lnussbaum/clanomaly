require 'pp'

module Net::SSH::Multi::SessionActions

  def exec!(cmd)
    self.exec(cmd)
    self.loop
  end

  def exec_getstdout(command)
    stdout = {}
    channel = exec(command) do |ch, stream, data|
      if stream == :stdout
        stdout[ch[:host]] ||= ""
        stdout[ch[:host]] += data
      else
        puts "[#{ch[:host]} : #{stream}] #{data}"
      end
    end
    channel.wait

    channel.each do |c|
      if c[:exit_status] != 0
        raise "execution failed on #{c[:host]}"
      end
    end

    return stdout
  end

  def exec_aggregate(command, &block)
    stdout = exec_getstdout(command)
    stdout = stdout.to_a
    stdout.map! { |e| [e[0], block.call(e[1])] } if block
    return stdout.group_by { |e| e[1] }.to_a.map { |e| [e[0], e[1].map {|e2| e2[0] } ] }
  end
end
