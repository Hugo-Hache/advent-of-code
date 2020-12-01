defmodule AdventOfCode.Day02 do
  def part1(input, noun \\ 12, verb \\ 2) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
    |> put_elem(1, noun)
    |> put_elem(2, verb)
    |> intcode(0)
    |> elem(0)
  end

  def part2(input, target \\ 19690720) do
    brute_force(input, target, 0, 0)
  end

  def brute_force(input, target, noun, verb) do
    output = part1(input, noun, verb)
    if output == target do
      100 * noun + verb
    else
      if verb < 99 do
        brute_force(input, target, noun, verb + 1)
      else
        brute_force(input, target, noun + 1, 0)
      end
    end
  end

  def intcode(integers, position) when elem(integers, position) == 99, do: integers
  def intcode(integers, position) do
    opcode = elem(integers, position)
    first_position = elem(integers, position + 1)
    second_position = elem(integers, position + 2)
    output_position = elem(integers, position + 3)

    new_int = compute(opcode, elem(integers, first_position), elem(integers, second_position))
    intcode(integers |> put_elem(output_position, new_int), position + 4)
  end

  def compute(1, i, j), do: i + j
  def compute(2, i, j), do: i * j
end
