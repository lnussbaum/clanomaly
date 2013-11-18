require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class DiskPerf < ClanomalyCheck
    def initialize(opts)
      super
      @groupable = false
    end

    def setup
      $ssh.exec_aggregate("DEBIAN_FRONTEND=noninteractive apt-get -y install fio")
    end

    def run
      @raw_output = $ssh.exec_getstdout("fio --ioengine=libaio --direct=1 --bs=4m --size=512m --directory=/tmp --iodepth=32 --name=file1 --readwrite=write ; fio --ioengine=libaio --direct=1 --bs=4m --size=512m --directory=/tmp --iodepth=32 --name=file1 --readwrite=read")
      dump_raw_output("fio/raw")
      sanitize_and_dump_output("fio")
    end

    private
    def sanitize(s, cluster)
      reads =  s.split(/\n/).grep(/^   READ:/)[0].split(/\s+/)[3].split('=')[1].split('K')[0].to_i
      writes = s.split(/\n/).grep(/^  WRITE:/)[0].split(/\s+/)[3].split('=')[1].split('K')[0].to_i
      "read: #{reads}\nwrite: #{writes}"
    end
  end
end
