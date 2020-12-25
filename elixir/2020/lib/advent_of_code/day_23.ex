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

  def part2(input) do
    cups = input |> parse_cups()
    million_cups = cups ++ ((Enum.max(cups) + 1)..1_000_000 |> Enum.to_list())

    played_linked_cups =
      million_cups
      |> linked_cups()
      |> linked_play()

    after_one = played_linked_cups[1]
    after_after_one = played_linked_cups[after_one]

    after_one * after_after_one
  end

  def linked_play(linked_cups, round \\ 0)
  def linked_play(linked_cups, 10_000_000), do: linked_cups

  def linked_play(%{current: current_cup} = linked_cups, round) do
    if rem(round, 10000) == 0, do: IO.puts(round)

    picked_cups = linked_cups |> picked_cups(current_cup)
    destination_cup = picked_cups |> linked_destination(current_cup - 1)
    next_current = linked_cups[List.last(picked_cups)]

    new_linked_cups =
      linked_cups
      |> Map.put(destination_cup, hd(picked_cups))
      |> Map.put(List.last(picked_cups), linked_cups[destination_cup])
      |> Map.put(current_cup, next_current)
      |> Map.put(:current, next_current)

    linked_play(new_linked_cups, round + 1)
  end

  def picked_cups(linked_cups, current_cup) do
    picked = linked_cups[current_cup]
    picked_second = linked_cups[picked]
    picked_third = linked_cups[picked_second]

    [picked, picked_second, picked_third]
  end

  def linked_destination(_, 0), do: 1_000_000

  def linked_destination(picked_cups, target) do
    if target in picked_cups do
      linked_destination(picked_cups, target - 1)
    else
      target
    end
  end

  def linked_cups([cup | other_cups]) do
    {linked_cups, previous_cup} =
      other_cups
      |> Enum.reduce({%{current: cup}, cup}, fn cup, {linked_cups, previous_cup} ->
        {linked_cups |> Map.put(previous_cup, cup), cup}
      end)

    linked_cups |> Map.put(previous_cup, cup)
  end
end
