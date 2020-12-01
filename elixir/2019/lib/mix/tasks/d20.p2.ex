defmodule Mix.Tasks.D20.P2 do
  use Mix.Task

  import AdventOfCode
  import AdventOfCode.Day20

  @shortdoc "Day 20 Part 2"
  def run(args) do
    input = read_puzzle_input("day_20", disable_trim: true)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
