def part_1(input, discarded_unit = nil)
  polymer = input.split('')
  new_polymer = nil

  while new_polymer&.length != polymer.length
    polymer = new_polymer if new_polymer
    new_polymer = []
    previous_letter = nil

    polymer.each do |letter|
      next if letter.downcase == discarded_unit
      next previous_letter = letter unless previous_letter

      should_react = letter.downcase == previous_letter.downcase && letter != previous_letter
      next previous_letter = nil if should_react

      new_polymer << previous_letter
      previous_letter = letter
    end

    new_polymer << previous_letter if previous_letter
  end

  polymer.length
end

def part_2(input)
  ('a'..'z').map do |discarded_unit|
    part_1(input, discarded_unit)
  end.min
end
