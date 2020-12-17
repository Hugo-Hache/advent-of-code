defmodule AdventOfCode.Day17 do
  def part1(input) do
    input
    |> parse_map
    |> play_round
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  def play_round(map, round \\ 0, stop_at_round \\ 6)
  def play_round(map, round, stop_at_round) when round == stop_at_round, do: map

  def play_round(map, round, stop_at_round) do
    new_map =
      map
      |> Map.keys()
      |> Enum.flat_map(&adjacent_positions/1)
      |> Enum.uniq()
      |> Enum.reduce(%{}, fn position, new_map ->
        occupied_adjacent_count =
          position
          |> adjacent_positions()
          |> Enum.count(&(Map.get(map, &1) == "#"))

        new_map
        |> Map.put(
          position,
          case map |> Map.get(position) do
            "#" -> if occupied_adjacent_count in [2, 3], do: "#", else: "."
            _ -> if occupied_adjacent_count == 3, do: "#", else: "."
          end
        )
      end)

    play_round(new_map, round + 1, stop_at_round)
  end

  def adjacent_positions({i, j, z}) do
    -1..1
    |> Enum.reduce([], fn di, adjacent_positions ->
      -1..1
      |> Enum.reduce(adjacent_positions, fn dj, adjacent_positions ->
        -1..1
        |> Enum.reduce(adjacent_positions, fn dz, adjacent_positions ->
          if di == 0 && dj == 0 && dz == 0,
            do: adjacent_positions,
            else: [{i + di, j + dj, z + dz} | adjacent_positions]
        end)
      end)
    end)
  end

  def adjacent_positions({i, j, z, w}) do
    -1..1
    |> Enum.reduce([], fn di, adjacent_positions ->
      -1..1
      |> Enum.reduce(adjacent_positions, fn dj, adjacent_positions ->
        -1..1
        |> Enum.reduce(adjacent_positions, fn dz, adjacent_positions ->
          -1..1
          |> Enum.reduce(adjacent_positions, fn dw, adjacent_positions ->
            if di == 0 && dj == 0 && dz == 0 && dw == 0,
              do: adjacent_positions,
              else: [{i + di, j + dj, z + dz, w + dw} | adjacent_positions]
          end)
        end)
      end)
    end)
  end

  def parse_map(input, dim \\ 3) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {row, i}, map ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn
        {"#", j}, map ->
          map
          |> Map.put(
            if(dim == 4, do: {i, j, 0, 0}, else: {i, j, 0}),
            "#"
          )

        {_, _}, map ->
          map
      end)
    end)
  end

  def part2(input) do
    input
    |> parse_map(4)
    |> play_round
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end
end
