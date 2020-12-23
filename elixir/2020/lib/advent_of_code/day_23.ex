defmodule AdventOfCode.Day23 do
  def part1(input) do
    input
    |> parse_cups()
    |> play()
    |> score()
  end

  def parse_cups(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def play(cups, round \\ 0)
  def play(list, 100), do: list

  def play([current_cup | other_cups], round) do
    {picked_cups, non_picked_cups} = other_cups |> Enum.split(3)
    destination = non_picked_cups |> destination(current_cup - 1)

    play(
      (non_picked_cups |> concat_list_after(destination, picked_cups)) ++ [current_cup],
      round + 1
    )
  end

  def score(cups) do
    {before_cups, after_cups} = Enum.split(cups, Enum.find_index(cups, &(&1 == 1)))
    (tl(after_cups) ++ before_cups) |> Enum.join()
  end

  def concat_list_after(list, target, value) do
    index = Enum.find_index(list, &(&1 == target))

    list
    |> List.insert_at(index + 1, value)
    |> List.flatten()
  end

  def destination(non_picked_cups, 0) do
    non_picked_cups |> Enum.max()
  end

  def destination(non_picked_cups, target) do
    if non_picked_cups |> Enum.member?(target) do
      target
    else
      destination(non_picked_cups, target - 1)
    end
  end

  def part2(_input) do
  end
end
