defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("\n")
      |> Enum.flat_map(&String.graphemes/1)
      |> Enum.reduce(MapSet.new(), &MapSet.put(&2, &1))
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn passenger_answers ->
        passenger_answers
        |> Enum.reduce(MapSet.new(), &MapSet.put(&2, &1))
      end)
      |> Enum.reduce(&MapSet.intersection(&1, &2))
      |> MapSet.size()
    end)
    |> Enum.sum()
  end
end
