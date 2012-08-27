module NodeSet
  def NodeSet.fold(arr)
    arr2 = arr.map { |s| s.match(/^([^0-9]+-)([0-9]+)(\..*)/).captures }
    grps = arr2.group_by { |e| [ e[0], e[2] ] }
    grps2 = grps.map do |e|
      k, v = e
      v = v.map { |e| e[1] }.sort.join(',')
      k[0] + v + k[1]
    end
    return grps2.join(',')
  end
end
            
