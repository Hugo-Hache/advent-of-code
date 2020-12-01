def distance(p1, p2)
  (p1[0] - p2[0]).abs +
    (p1[1] - p2[1]).abs +
    (p1[2] - p2[2]).abs +
    (p1[3] - p2[3]).abs
end

def part_1(input)
  constellations = []
  input.split("\n").each do |row|
    point = row.split(',').map(&:to_i)
    constellations_connected = constellations.select do |constellation|
      constellation.any? { |p| distance(point, p) <= 3 }
    end

    case constellations_connected.length
    when 0
      constellations << [point]
    when 1
      constellations_connected.first << point
    else
      constellations -= constellations_connected
      constellations << (constellations_connected.reduce(:+) << point)
    end
  end

  constellations.length
end

def part_2(_input)
  'Happy christmas 🌲'
end
