defmodule AdventOfCode.Day25 do
  def part1(input) do
    [card_public_key, door_public_key] =
      input
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&String.to_integer/1)

    card_loop_size = guess_loop_size(card_public_key, 7)

    1..card_loop_size
    |> Enum.reduce(1, fn _, number -> transform(number, door_public_key) end)
  end

  def guess_loop_size(target, subject, number \\ 1, loop \\ 0)
  def guess_loop_size(target, _, number, loop) when target == number, do: loop

  def guess_loop_size(target, subject, number, loop) do
    guess_loop_size(target, subject, transform(number, subject), loop + 1)
  end

  def transform(number, subject) do
    rem(number * subject, 20_201_227)
  end
end
