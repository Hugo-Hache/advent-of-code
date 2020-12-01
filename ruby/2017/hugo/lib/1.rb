def part_1(input)
  sum = 0
  previous_char = nil
  chars = input.split('')
  chars.each do |char|
    sum += char.to_i if char == previous_char
    previous_char = char
  end
  sum += chars[0].to_i if chars[-1] == chars[0]
  sum
end

def part_2(input)
  sum = 0
  chars = input.split('')
  chars.each_with_index do |char, i|
    circular_index = (i + chars.length / 2) % chars.length
    sum += char.to_i if char == chars[circular_index]
  end
  sum
end


