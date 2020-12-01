def distances(input)
  moves = { 'N' => [0, 1], 'E' => [1, 0], 'S' => [0, -1], 'W' => [-1, 0] }

  position = [0, 0]
  crossings = []
  input.each_with_object({ position => 0 }) do |char, distances|
    case char
    when '|'
      position = crossings.last
    when '('
      crossings << position
    when ')'
      position = crossings.pop
    else
      move = moves[char]
      new_position = [position[0] + move[0], position[1] + move[1]]
      distances[new_position] ||= distances[position] + 1
      position = new_position
    end
  end
end

def part_1(input)
  distances(input.strip.split('')[1..-2]).values.max
end

def part_2(input, min_length = 1000)
  distances(input.strip.split('')[1..-2]).values.count { |d| d >= min_length }
end
