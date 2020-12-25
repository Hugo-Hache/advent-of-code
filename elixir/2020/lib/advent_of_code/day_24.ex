defmodule AdventOfCode.Day24 do
  def part1(input) do
    input
    |> parse_black_tiles()
    |> MapSet.size()
  end

  def parse_black_tiles(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.reduce(MapSet.new(), fn line, black_tiles ->
      coords =
        Regex.scan(~r/e|se|sw|w|nw|ne/, line)
        |> List.flatten()
        |> Enum.reduce({0, 0}, fn
          "e", {x, y} -> {x + 2, y}
          "se", {x, y} -> {x + 1, y - 1}
          "sw", {x, y} -> {x - 1, y - 1}
          "w", {x, y} -> {x - 2, y}
          "nw", {x, y} -> {x - 1, y + 1}
          "ne", {x, y} -> {x + 1, y + 1}
        end)

      if black_tiles |> MapSet.member?(coords) do
        black_tiles |> MapSet.delete(coords)
      else
        black_tiles |> MapSet.put(coords)
      end
    end)
  end

  def part2(input) do
    black_tiles = input |> parse_black_tiles()

    1..100
    |> Enum.reduce(black_tiles, fn _, black_tiles -> flip(black_tiles) end)
    |> MapSet.size()
  end

  def flip(black_tiles) do
    black_and_adjacent_tiles =
      black_tiles
      |> Enum.reduce(black_tiles, fn black_tile, black_tiles ->
        black_tile
        |> adjacent_positions
        |> Enum.reduce(black_tiles, &MapSet.put(&2, &1))
      end)

    black_and_adjacent_tiles
    |> Enum.reduce(MapSet.new(), fn tile, flipped_black_tiles ->
      adjacent_black_tiles =
        tile
        |> adjacent_positions()
        |> Enum.count(&MapSet.member?(black_tiles, &1))

      if black_tiles |> MapSet.member?(tile) do
        if adjacent_black_tiles in 1..2,
          do: MapSet.put(flipped_black_tiles, tile),
          else: flipped_black_tiles
      else
        if adjacent_black_tiles == 2,
          do: MapSet.put(flipped_black_tiles, tile),
          else: flipped_black_tiles
      end
    end)
  end

  def adjacent_positions({x, y}) do
    [
      {x + 2, y},
      {x + 1, y - 1},
      {x - 1, y - 1},
      {x - 2, y},
      {x - 1, y + 1},
      {x + 1, y + 1}
    ]
  end
end
