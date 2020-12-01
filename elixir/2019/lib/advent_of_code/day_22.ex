defmodule AdventOfCode.Day22 do
  def part1(input, size \\ 10006) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.reduce((0..size) |> Enum.to_list, &apply_technique/2)
    # |> Enum.find_index(&(&1 == 2019))
  end

  def apply_technique("deal into new stack", cards) do
    cards |> Enum.reverse
  end

  def apply_technique("deal with increment " <> n, cards) do
    n = n |> String.to_integer

    cards
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {card, index}, map ->
      new_index = rem(index * n, length(cards))
      map |> Map.put(new_index, card)
    end)
    |> Enum.sort_by(&(elem(&1, 0)))
    |> Keyword.values
  end

  def apply_technique("cut " <> n, cards) do
    cards
    |> Enum.split(n |> String.to_integer)
    |> Tuple.to_list
    |> Enum.reverse
    |> List.flatten
  end

  def part2(input) do
    size = 119315717514047
    repeat = 101741582076661

    techniques = input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))

    {inv_a, inv_b} = inv(techniques, size)
    {repeated_inv_a, repeated_inv_b} = repeat({inv_a, inv_b}, repeat, size)
    rem(repeated_inv_a * 2020 + repeated_inv_b, size)
  end

  def compose({a, b}, {c, d}, size) do
    {rem(c * a, size), rem(c * b + d, size)}
  end

  def inv(techniques, size) when is_list(techniques) do
    techniques
    |> Enum.reverse
    |> Enum.reduce({1, 0}, fn technique, {a, b} ->
      compose({a, b}, inv(coefs(technique, size), size), size)
    end)
  end

  def inv({a, b}, deck_size) do
    {normalized_div(1, a, deck_size), normalized_div(-b, a, deck_size)}
  end

  def coefs("deal into new stack", size) do
    {-1, size - 1}
  end

  def coefs("deal with increment " <> n, _) do
    {String.to_integer(n), 0}
  end

  def coefs("cut " <> n, _) do
    {1, - String.to_integer(n)}
  end

  # Thanks https://github.com/sasa1977/aoc/blob/master/lib/2019/201922.ex#L166
  def normalized_div(a, b, deck_size) do
    a
    |> Stream.iterate(&(&1 + deck_size))
    |> Enum.find(&(rem(&1, b) == 0))
    |> div(b)
    |> normalize(deck_size)
  end

  def normalize(pos, deck_size) when pos < 0, do: deck_size - normalize(-pos, deck_size)
  def normalize(pos, deck_size), do: rem(pos, deck_size)

  require Integer
  def repeat(_, 0, _), do: {1, 0}
  def repeat(coefs, 1, _), do: coefs
  def repeat(coefs, repeat, size) when Integer.is_odd(repeat), do: compose(coefs, repeat(coefs, repeat - 1, size), size)
  def repeat(coefs, repeat, size) do
    half = div(repeat, 2)
    repeated = repeat(coefs, half, size)
    compose(repeated, repeated, size)
  end
end
