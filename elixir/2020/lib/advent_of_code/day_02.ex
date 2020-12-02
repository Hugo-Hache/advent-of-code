defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [occurence_range, <<letter::binary-size(1), ":">>, password] ->
      [min_occurence, max_occurence] =
        occurence_range |> String.split("-") |> Enum.map(&String.to_integer/1)

      {min_occurence, max_occurence, letter, password}
    end)
    |> Enum.filter(fn {min_occurence, max_occurence, letter, password} ->
      occurence =
        password
        |> String.graphemes()
        |> Enum.reduce(0, &if(&1 == letter, do: &2 + 1, else: &2))

      occurence >= min_occurence && occurence <= max_occurence
    end)
    |> length()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [occurence_range, <<letter::binary-size(1), ":">>, password] ->
      [min_occurence, max_occurence] =
        occurence_range |> String.split("-") |> Enum.map(&String.to_integer/1)

      {min_occurence, max_occurence, letter, password}
    end)
    |> Enum.filter(fn {lower_index, higher_index, letter, password} ->
      count =
        password
        |> String.graphemes()
        |> Enum.with_index(1)
        |> Enum.reduce(0, fn {l, i}, count ->
          if l == letter && (i == lower_index || i == higher_index) do
            count + 1
          else
            count
          end
        end)

      count == 1
    end)
    |> length()
  end
end
