defmodule Mix.Tasks.D07.P1 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day07

  @shortdoc "Day 07 Part 1"
  def run(args) do
    input = read_puzzle_input("day_07")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
