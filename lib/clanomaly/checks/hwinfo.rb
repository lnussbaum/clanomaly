require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class Hwinfo < ClanomalyCheck
    def initialize(opts)
      super
    end

    def setup
      $ssh.exec_aggregate("DEBIAN_FRONTEND=noninteractive apt-get -y install hwinfo")
    end

    def run
      @raw_output = $ssh.exec_getstdout("hwinfo")
      dump_raw_output("o/hwinfo")
    end

    private
    def sanitize(s, cluster)
      s
    end
  end
end
