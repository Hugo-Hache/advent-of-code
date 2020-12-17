defmodule AdventOfCode.Day17 do
  def part1(input) do
    input
    |> parse_map
    |> play_round
    |> MapSet.size()
  end

  def play_round(set, round \\ 0, stop_at_round \\ 6)
  def play_round(set, round, stop_at_round) when round == stop_at_round, do: set

  def play_round(set, round, stop_at_round) do
    new_set =
      set
      |> Enum.flat_map(&adjacent_positions/1)
      |> Enum.uniq()
      |> Enum.reduce(MapSet.new(), fn position, new_set ->
        occupied_adjacent_count =
          position
          |> adjacent_positions()
          |> Enum.count(&MapSet.member?(set, &1))

        case {MapSet.member?(set, position), occupied_adjacent_count} do
          {true, count} when count in [2, 3] -> new_set |> MapSet.put(position)
          {false, 3} -> new_set |> MapSet.put(position)
          _ -> new_set
        end
      end)

    play_round(new_set, round + 1, stop_at_round)
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
    |> Enum.reduce(MapSet.new(), fn {row, i}, set ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(set, fn
        {"#", j}, set ->
          set |> MapSet.put(if(dim == 4, do: {i, j, 0, 0}, else: {i, j, 0}))

        {_, _}, set ->
          set
      end)
    end)
  end

  def part2(input) do
    input
    |> parse_map(4)
    |> play_round
    |> MapSet.size()
  end
end
