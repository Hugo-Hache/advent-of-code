defmodule Mix.Tasks.D09.P1 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day09

  @shortdoc "Day 09 Part 1"
  def run(args) do
    input = read_puzzle_input("day_09")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
