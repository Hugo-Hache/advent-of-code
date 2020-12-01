def part_1(input)
  required_recipes = input.to_i

  recipes = Array.new(required_recipes + 10)
  recipes[0] = 3
  recipes[1] = 7
  next_recipe_index = 2
  current_positions = [0, 1]
  while next_recipe_index <= required_recipes + 10
    #puts((0..next_recipe_index).map do |i|
    #  r = recipes[i]
    #  next "(#{r})" if i == current_positions[0]
    #  next "[#{r}]" if i == current_positions[1]
    #  r.to_s
    #end.join(' '))

    current_positions.sum { |i| recipes[i] }.to_s.split('').map(&:to_i).each do |new_recipe|
      recipes[next_recipe_index] = new_recipe
      next_recipe_index += 1
    end
    current_positions = current_positions.map { |i| (i + recipes[i] + 1) % next_recipe_index }
  end
  recipes[required_recipes..(required_recipes + 9)].join('')
end

def part_2(input)
  sequence = input.strip.split('').map(&:to_i)

  recipes = Array.new(30000000)
  recipes[0] = 3
  recipes[1] = 7
  next_recipe_index = 2
  current_positions = [0, 1]

  start = nil
  sequence_index = 0

  loop do
    score = recipes[current_positions[0]] + recipes[current_positions[1]]
    digits = score < 10 ? [score] : [score / 10, score % 10]
    digits.each do |new_recipe|
      if start && new_recipe != sequence[sequence_index]
        start = nil
        sequence_index = 0
      end

      if new_recipe == sequence[sequence_index]
        start ||= next_recipe_index
        sequence_index += 1
        return start if sequence_index == sequence.length
      end

      recipes[next_recipe_index] = new_recipe
      next_recipe_index += 1
    end
    current_positions = current_positions.map { |i| (i + recipes[i] + 1) % next_recipe_index }
  end
end
