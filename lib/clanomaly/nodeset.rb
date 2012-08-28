module NodeSet
  def NodeSet.fold(arr)
    arr2 = arr.map { |s| s.match(/^([^0-9]+-)([0-9]+)(\..*)/).captures }
    grps = arr2.group_by { |e| [ e[0], e[2] ] }
    grps2 = grps.map do |e|
      k, v = e
      v = v.map { |e| e[1].to_i }.sort
      k[0] + fold_array_to_string(v) + k[1]
    end
    return grps2.join(',')
  end

  # fold_array_to_string([2,3,4,6,7,8,9,10,12]) => "[2-4,6-10,12]"
  def NodeSet.fold_array_to_string(arr)
    return arr[0].to_s if arr.length == 1
    ints = []
    cur_start = arr[0]
    for i in 1...arr.length do
#      puts  "i=#{i} cur_start=#{cur_start} arr[i]=#{arr[i]} arr[i-1]=#{arr[i-1]} ints=#{ints.inspect}"
      if arr[i] != arr[i-1] + 1
        if cur_start == arr[i-1]
          ints << cur_start.to_s
        else
          ints << "#{cur_start}-#{arr[i-1]}"
        end
        cur_start = arr[i]
      end
    end

    # deal with last interval
    if cur_start == arr[-1]
      ints << cur_start.to_s
    else
      ints << "#{cur_start}-#{arr[-1]}"
    end

    return "[" + ints.join(",") + "]"
  end
end
