defmodule Mix.Tasks.D13.P1 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day13

  @shortdoc "Day 13 Part 1"
  def run(args) do
    input = read_puzzle_input("day_13")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
