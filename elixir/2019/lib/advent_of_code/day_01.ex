defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
      |> String.split
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&theoric_fuel/1)
      |> Enum.sum
  end

  def part2(input) do
    input
      |> String.split
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&actual_fuel/1)
      |> Enum.sum
  end

  def theoric_fuel(weight) do
    Float.floor(weight / 3) - 2
  end

  def actual_fuel(weight) when weight < 9, do: 0
  def actual_fuel(weight) do
    t = theoric_fuel(weight)
    t + actual_fuel(t)
  end
end
