require 'fileutils'
require 'nokogiri'
require 'net/scp'

module ClanomalyChecks
  class Partitions < ClanomalyCheck
    def initialize
    end

    def setup
      File::open("/tmp/partitions-script", "w") do |fd|
        fd.puts <<-EOF
#!/bin/bash
exec 2>&1

echo "## fdisk -l"
fdisk -l
for fs in $(cat /proc/mounts | grep ext | cut -d ' ' -f 1); do
   echo "## dumpe2fs -h $fs"
   dumpe2fs -h $fs
done
        EOF
      end
      chs = []
      $ssh.sessions.each do |s|
        chs << s.scp.upload("/tmp/partitions-script", "/tmp")
      end
      chs.each do |ch|
        ch.wait
      end
      $ssh.exec_aggregate("apt-get -y install e2fsprogs")
    end

    def run
      @raw_output = $ssh.exec_getstdout("bash /tmp/partitions-script")
      dump_raw_output("o/partitions/raw")
      sanitize_and_dump_output("o/partitions")
    end

    private
    def sanitize(s)
      s.split(/\n/).reject { |l|
        l =~ /^Filesystem UUID:/ or
        l =~ /^Free blocks:/ or
        l =~ /^Filesystem created:/ or
        l =~ /^Last mount time:/ or
        l =~ /^Last write time:/ or
        l =~ /^Maximum mount count:/ or
        l =~ /^Last checked:/ or
        l =~ /^Next check after:/ or
        l =~ /^Directory Hash Seed:/ or
        l =~ /^Mount count:/ or
        l =~ /^Disk identifier:/ or
        l =~ /^Journal sequence:/ }.join("\n")
    end
  end
end
