require 'fileutils'
require 'nokogiri'
require 'net/scp'

module ClanomalyChecks
  class KernelSettings < ClanomalyCheck
    def initialize(opts)
      super
    end

    def setup
      File::open("/tmp/kernelsettings-script", "w") do |fd|
        fd.puts <<-EOF
#!/bin/bash
exec 2>&1

echo "## uname -srvmpio"
uname -srvmpio
echo "## lsmod | sort"
lsmod | sort
echo "## sysctl -a"
sysctl -a
        EOF
      end
      chs = []
      $ssh.sessions.each do |s|
        chs << s.scp.upload("/tmp/kernelsettings-script", "/tmp")
      end
      chs.each do |ch|
        ch.wait
      end
    end

    def run
      @raw_output = $ssh.exec_getstdout("bash /tmp/kernelsettings-script")
      dump_raw_output("kernelsettings/raw")
      sanitize_and_dump_output("kernelsettings")
    end

    private
    def sanitize(s, cluster)
      
      s = s.split(/\n/).reject { |l|
        l =~ /^kernel.random.entropy_avail =/ or
        l =~ /^kernel.random.boot_id = / or
        l =~ /^kernel.random.uuid = / or
        l =~ /^kernel.hostname = / or
        l =~ /^kernel.pty.nr = / or
        l =~ /^fs.inode-nr = / or
        l =~ /^fs.inode-state = / or
        l =~ /^fs.dentry-state = / or
        l =~ /^fs.file-nr = / or
        l =~ /^fs.file-max = /
      }.join("\n")
      s.gsub!(/error: permission denied on key 'net.ipv[46].route.flush'\n/, '')
      l = s.split(/\n/)
      before = l.index('## lsmod | sort')
      after = l.index('## sysctl -a')
      l[before+1...after].each do |l2|
        if l2.split(/\s+/).length >= 4 and l2 !~ /Used by/
          m = l2.match(/^(\w+\s+\w+\s+\w+\s+)(.*)$/)
          str = m[2].split(/,/).sort.join(',')
          l2.gsub!(/^.*$/, "#{m[1]}#{str}")
        end
      end
      s = l.join("\n")
      s
    end
  end
end
