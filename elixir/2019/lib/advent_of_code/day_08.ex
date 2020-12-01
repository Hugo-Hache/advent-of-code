defmodule AdventOfCode.Day08 do
  def part1(input, width \\ 25, height \\ 6) do
    min_histo = input
    |> String.graphemes
    |> Enum.chunk_every(width * height)
    |> Enum.map(fn layer ->
      layer |> Enum.reduce(%{}, fn char, histo ->
        histo |> Map.put(char, 1 + Map.get(histo, char, 0))
      end)
    end)
    |> Enum.min_by(&(Map.get(&1, "0", 0)))

    Map.get(min_histo, "1", 0) * Map.get(min_histo, "2", 0)
  end

  def part2(input, width \\ 25, height \\ 6) do
    input
    |> String.graphemes
    |> Enum.chunk_every(width * height)
    |> Enum.zip
    |> Enum.map(fn pixels ->
      pixels
      |> Tuple.to_list
      |> Enum.reduce("2", &(if &2 == "2", do: &1, else: &2))
    end)
    # |> display(width)
  end

  def display(image, width) do
    image
    |> Enum.chunk_every(width)
    |> Enum.each(fn line ->
      IO.puts(line |> Enum.map(&(if &1 == "1", do: "H", else: " ")))
    end)
  end
end
