def evolve(pots, rules, index)
  pattern = ((index - 2)..(index + 2)).map { |i| pots[i] || '.' }.join
  rules[pattern] || '.'
end

def score(pots)
  pots.sum { |i, pot| pot == '#' ? i : 0 }
end

def part_1(input)
  rows = input.split("\n")
  pots = rows[0].split.last.split('').map.with_index { |pot, i| [i, pot] }.to_h
  rules = rows[2..-1].map do |row|
    pattern, _, result = row.split
    [pattern, result]
  end.to_h

  (1..20).each do |iteration|
    min, max = pots.keys.minmax
    pots = ((min - 2)..(max + 2)).map do |i|
      [i, evolve(pots, rules, i)]
    end.to_h
  end

  score(pots)
end

def part_2(input)
  rows = input.split("\n")
  pots = rows[0].split.last.split('').map.with_index { |pot, i| [i, pot] }.to_h
  rules = rows[2..-1].map do |row|
    pattern, _, result = row.split
    [pattern, result]
  end.to_h

  score = score(pots)
  increase = 0
  iteration = 0
  loop do
    min, max = pots.keys.minmax
    new_pots = ((min - 2)..(max + 2)).map do |i|
      [i, evolve(pots, rules, i)]
    end.to_h

    new_score = score(new_pots)
    new_increase = new_score - score
    return (5e10.to_i - iteration - 1) * increase + new_score if new_increase == increase

    score = new_score
    increase = new_increase
    pots = new_pots
    iteration += 1
  end
end
