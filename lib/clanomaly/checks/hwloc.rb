require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class Hwloc < ClanomalyCheck
    def setup
      $ssh.exec_aggregate("DEBIAN_FRONTEND=noninteractive apt-get -y install hwloc")
    end

    def run
      @raw_output = $ssh.exec_getstdout("hwloc-ls -.xml")
      
      dump_raw_output("hwloc/raw")
      sanitize_and_dump_output("hwloc")
    end

    private
    def sanitize(s, cluster)
      s
    end
  end
end
