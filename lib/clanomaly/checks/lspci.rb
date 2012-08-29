require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class Lspci < ClanomalyCheck
    def initialize(opts)
      super
    end

    def setup
      $ssh.exec_aggregate("DEBIAN_FRONTEND=noninteractive apt-get -y install pciutils")
    end

    def run
      @raw_output = $ssh.exec_getstdout("lspci")
      dump_raw_output("lspci/raw")
      sanitize_and_dump_output("lspci")
    end

    private
    def sanitize(s, cluster)
      s.gsub(/Serial Number.*/,'Serial Number')
    end
  end
end
