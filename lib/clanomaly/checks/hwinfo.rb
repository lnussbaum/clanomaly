require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class Hwinfo < ClanomalyCheck
    def initialize(opts)
      super
      @groupable = false
    end

    def setup
      $ssh.exec_aggregate("DEBIAN_FRONTEND=noninteractive apt-get -y install hwinfo")
    end

    def run
      @raw_output = $ssh.exec_getstdout("hwinfo 2>/dev/null")
      dump_raw_output("hwinfo")
    end

    private
    def sanitize(s, cluster)
      s
    end
  end
end
