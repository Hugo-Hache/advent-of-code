def part_1(input)
  coords = input.split.map(&:to_i).each_slice(2).to_a

  min_x, max_x = coords.map { |x, _| x }.minmax
  min_y, max_y = coords.map { |_, y| y }.minmax
  area = Hash.new { 0 }
  infinite = []
  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      distances = coords.map { |c| [c, (c[0] - x).abs + (c[1] - y).abs] }.to_h

      min_coord, min_distance = distances.min_by { |_, v| v }
      distances.delete(min_coord)
      _, second_min_distance = distances.min_by { |_, v| v }
      area[min_coord] += 1 if min_distance < second_min_distance

      is_border = x == min_x || x == max_x || y == min_y || y == max_y
      infinite << min_coord if is_border
    end
  end

  infinite.uniq.each { |coord| area.delete(coord) }

  area.values.max
end

def part_2(input, max_distance = 10000)
  coords = input.split.map(&:to_i).each_slice(2).to_a

  score = 0
  min_x, max_x = coords.map { |x, _| x }.minmax
  min_y, max_y = coords.map { |_, y| y }.minmax
  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      score += 1 if coords.sum { |c| (c[0] - x).abs + (c[1] - y).abs } < max_distance
    end
  end

  score
end
