defmodule AdventOfCode.Day22 do
  def part1(input) do
    input
    |> parse_decks()
    |> play()
    |> score()
  end

  def parse_decks(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn lines ->
      lines
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> tl()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def play([[], second_deck]), do: [[], second_deck]
  def play([first_deck, []]), do: [first_deck, []]

  def play([[first_card | first_rest], [second_card | second_rest]]) do
    if first_card > second_card do
      play([first_rest ++ [first_card, second_card], second_rest])
    else
      play([first_rest, second_rest ++ [second_card, first_card]])
    end
  end

  def score(deck) do
    deck
    |> List.flatten()
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {card, i}, sum -> sum + card * i end)
  end

  def part2(input) do
    input
    |> parse_decks()
    |> recursive_play()
    |> score()
  end

  def recursive_play(decks, previous_decks \\ MapSet.new())
  def recursive_play([first_deck, []], _), do: [first_deck, []]
  def recursive_play([[], second_deck], _), do: [[], second_deck]

  def recursive_play(
        [[first_card | first_rest], [second_card | second_rest]] = decks,
        previous_decks
      ) do
    if previous_decks |> MapSet.member?(decks) do
      [[first_card | first_rest], []]
    else
      is_first_winner =
        if length(first_rest) >= first_card && length(second_rest) >= second_card do
          recursive_first_deck = first_rest |> Enum.take(first_card)
          recursive_second_deck = second_rest |> Enum.take(second_card)

          case recursive_play([recursive_first_deck, recursive_second_deck]) do
            [_, []] -> true
            [[], _] -> false
          end
        else
          first_card > second_card
        end

      if is_first_winner do
        recursive_play(
          [first_rest ++ [first_card, second_card], second_rest],
          previous_decks |> MapSet.put(decks)
        )
      else
        recursive_play(
          [first_rest, second_rest ++ [second_card, first_card]],
          previous_decks |> MapSet.put(decks)
        )
      end
    end
  end
end
