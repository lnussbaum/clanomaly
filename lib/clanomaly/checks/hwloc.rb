require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class Hwloc < ClanomalyCheck
    def setup
      $ssh.exec_aggregate("apt-get -y install hwloc")
    end

    def run
      @raw_output = $ssh.exec_getstdout("hwloc-ls -.xml")
      
      dump_raw_output("o/hwloc/raw")
      sanitize_and_dump_output("o/hwloc")
    end

    private
    def sanitize(s)
      s
    end
  end
end
