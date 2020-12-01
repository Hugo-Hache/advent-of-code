defmodule Mix.Tasks.D22.P1 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day22

  @shortdoc "Day 22 Part 1"
  def run(args) do
    input = read_puzzle_input("day_22")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
