defmodule Mix.Tasks.D13.P2 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day13

  @shortdoc "Day 13 Part 2"
  def run(args) do
    input = read_puzzle_input("day_13")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
