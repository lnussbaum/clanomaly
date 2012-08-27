require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class Hwinfo < ClanomalyCheck
    def initialize
    end

    def setup
      $ssh.exec_aggregate("apt-get -y install hwinfo")
    end

    def run
      @raw_output = $ssh.exec_getstdout("hwinfo")
      dump_raw_output("o/hwinfo")
    end

    private
    def sanitize(s)
      s
    end
  end
end
