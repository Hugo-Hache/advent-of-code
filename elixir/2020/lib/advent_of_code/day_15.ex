defmodule AdventOfCode.Day15 do
  def part1(input, stop_round \\ 2020) do
    starting_numbers = input |> String.split(",") |> Enum.map(&String.to_integer/1)

    starting_memory =
      starting_numbers
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {number, index}, memory -> memory |> Map.put(number, [index]) end)

    play(
      starting_memory,
      starting_numbers |> List.last(),
      length(starting_numbers) + 1,
      stop_round
    )
  end

  def play(_, last_number, round, stop_round) when round == stop_round + 1, do: last_number

  def play(memory, last_number, round, stop_round) do
    new_number =
      case Map.get(memory, last_number) do
        [_] -> 0
        occurences -> hd(occurences) - hd(tl(occurences))
      end

    play(
      memory |> Map.update(new_number, [round], &[round | &1]),
      new_number,
      round + 1,
      stop_round
    )
  end

  def part2(input) do
    part1(input, 30_000_000)
  end
end
