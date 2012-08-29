require 'fileutils'
require 'nokogiri'

module ClanomalyChecks
  class Lshw < ClanomalyCheck
    def initialize(opts)
      super
    end

    def setup
      $ssh.exec_aggregate("DEBIAN_FRONTEND=noninteractive apt-get -y install lshw")
    end

    def run
      @raw_output = $ssh.exec_getstdout("lshw -xml")
      dump_raw_output("lshw/raw")
      sanitize_and_dump_output("lshw")
    end

    private
    def sanitize(s, cluster)
      doc = Nokogiri::XML::parse(s)
      # rm number from hostname
      x = doc.xpath('//node[@class=\'system\']').first
      x['id'] = x['id'].gsub(/-[0-9]+\./, '-X.')
      # rm serial from NICs (= MAC address)
      doc.xpath('//node[@class=\'network\']/serial').each { |n| n.unlink }
      
      # rm IP address
      doc.xpath('//node[@class=\'network\']/configuration/setting[@id=\'ip\']').each do |n|
        n['value'] = ''
      end
      # rm serial from disks
      doc.xpath('//node[@class=\'disk\']/serial').each { |n| n.unlink }
      
      # rm signature from disks
      doc.xpath('//node[@class=\'disk\']/configuration/setting[@id=\'signature\']').each { |n| n.unlink }
     
      # rm serial from volumes
      doc.xpath('//node[@class=\'volume\']/serial').each { |n| n.unlink }
      
      # rm dates from from volumes
      doc.xpath('//node[@class=\'volume\']/configuration/setting').each do |n|
        n['value'] = '' if ['created', 'modified', 'mounted'].include?(n['id'])
      end
      # rm serial from system
      doc.xpath('//node[@class=\'system\']/serial').each { |n| n.unlink }
      
      # rm uuid from system
      doc.xpath('//node[@class=\'system\']/configuration/setting[@id=\'uuid\']').each do |n|
        n['value'] = ''
      end
      # rm serial from bus
      doc.xpath('//node[@class=\'bus\']/serial').each { |n| n.unlink }
      # rm serial from memory
      doc.xpath('//node[@class=\'memory\']/serial').each { |n| n.unlink }

      # remove strange slot field (causes false-positives on bordeplage)
      doc.xpath('//node[@id=\'core\']/slot').each do |n|
        n.content = ''
      end
      # renumber all SCSI ids
      doc.xpath('//node[@class=\'volume\']/businfo').each do |n|
        n.content = n.content.gsub(/scsi@[0-9]+/, 'scsi@N')
      end
      doc.xpath('//node[@class=\'storage\']/logicalname').each do |n|
        n.content = n.content.gsub(/scsi[0-9]+/, 'scsiN')
      end
      doc.xpath('//node[@class=\'disk\']/businfo').each do |n|
        n.content = n.content.gsub(/scsi@[0-9]+/, 'scsi@N')
      end
      doc.xpath('//node[@class=\'disk\']').each do |n|
        if not n['handle'].nil?
          n['handle'] = n['handle'].gsub(/SCSI:[0-9]+:/, 'SCSI:NN:')
        end
      end

      unless @opts[:no_ignore_harmless]
        if ['stremi', 'parapluie', 'parapide'].include?(cluster)
          # remove memory product and vendor name
          doc.xpath('//node[@class=\'memory\']/product').each { |n| n.unlink }
          doc.xpath('//node[@class=\'memory\']/vendor').each { |n| n.unlink }
        end

        if ['talc', 'parapluie'].include?(cluster)
          # remove disk product and version, some nodes have slightly different disks
          doc.xpath('//node[@class=\'disk\']/product').each { |n| n.unlink }
          doc.xpath('//node[@class=\'disky\']/version').each { |n| n.unlink }
        end
      end

      # clean empty lines
      doc.xpath("//text()").each { |text| text.content = text.content.gsub(/\n(\s*\n)+/,"\n") }

      doc.to_s
    end
  end
end
