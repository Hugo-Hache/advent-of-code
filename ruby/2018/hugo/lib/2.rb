def part_1(input)
  ids = input.split
  duo_count = 0
  trio_count = 0
  ids.each do |id|
    histogram = Hash.new(0)
    id.split('').each do |char|
      histogram[char] += 1
    end
    duo_count += 1 if histogram.value? 2
    trio_count += 1 if histogram.value? 3
  end
  duo_count * trio_count
end

def unique_diff_index(id, candidate_id)
  diff_index = nil
  (0..id.length).each do |i|
    if id[i] != candidate_id[i]
      return nil if diff_index
      diff_index = i
    end
  end
  diff_index
end

def part_2(input)
  ids = input.split
  ids.each_with_index do |id, index|
    ids[(index + 1)..-1].each do |candidate_id|
      i = unique_diff_index(id, candidate_id)
      next unless i

      letters = id.split('')
      letters.delete_at(i)
      return letters.join
    end
  end
end
