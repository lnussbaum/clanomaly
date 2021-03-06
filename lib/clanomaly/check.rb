class ClanomalyCheck
  attr_reader :groupable

  def initialize(opts)
    @opts = opts
    @groupable = true
  end

  def setup
  end

  def run
  end

  def groups
    @san_output.keys
  end 

  protected
  def group_hash(h)
    return h.group_by { |e| e[1] }.to_a.map { |e| [e[0], e[1].map {|e2| e2[0] } ] }
  end

  def dump_raw_output(dir)
    FileUtils::mkdir_p(dir)
    @raw_output.each_pair do |k, v|
      File::open("#{dir}/#{k}", "w") do |fd|
        fd.puts v
      end
    end
  end

  def sanitize_output
    so = {}
    @raw_output.each_pair do |k, v|
      if k =~ /grid5000.fr$/
        cluster = k.split('-',2)[0]
      else
        cluster = nil
      end
      so[k] = sanitize(v, cluster)
    end
    so2 = group_hash(so)
    @san_output = {}
    so2.each do |e|
      @san_output[e[1]] = e[0]
    end
  end

  def dump_san_output(dir)
    @san_output.each_pair do |k,v|
      File::open(dir+"/"+NodeSet::fold(k), "w") do |fd|
        fd.puts v
      end
    end
  end

  def sanitize_and_dump_output(dir)
    sanitize_output
    dump_san_output(dir)
  end
end
