defmodule AdventOfCode.Day03 do
  def part1(input) do
    map = parse_map(input)
    {_, _, height} = map

    0..(height - 1)
    |> Enum.reduce(0, fn i, count ->
      if tree?(map, i, i * 3), do: count + 1, else: count
    end)
  end

  def part2(input) do
    map = parse_map(input)
    {_, _, height} = map

    [{1, 1}, {1, 3}, {1, 5}, {1, 7}, {2, 1}]
    |> Enum.map(fn {i_mul, j_mul} ->
      iterations = trunc((height - 1) / i_mul)

      0..iterations
      |> Enum.reduce(0, fn i, count ->
        if tree?(map, i * i_mul, i * j_mul), do: count + 1, else: count
      end)
    end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def parse_map(input) do
    lines =
      input
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))

    height = length(lines)
    width = length(lines |> List.first() |> String.graphemes())

    trees =
      lines
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {row, i}, trees ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(trees, fn
          {"#", j}, trees -> trees |> MapSet.put({i, j})
          {_, _}, trees -> trees
        end)
      end)

    {trees, width, height}
  end

  def tree?({trees, width, height}, i, j) do
    trees |> MapSet.member?({rem(i, height), rem(j, width)})
  end
end
