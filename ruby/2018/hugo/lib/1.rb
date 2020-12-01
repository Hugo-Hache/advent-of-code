def part_1(input)
  operations = input.split
  operations.reduce(0) do |sum, operation|
    operator = operation[0]
    value = operation[1..-1].to_i
    sum.send(operator, value)
  end
end

def part_2(input)
  operations = input.split
  sum = 0
  sums = { 0 => true }

  loop do
    operations.each do |operation|
      operator = operation[0]
      value = operation[1..-1].to_i
      sum = sum.send(operator, value)

      return sum if sums.key? sum
      sums[sum] = true
    end
  end
end
