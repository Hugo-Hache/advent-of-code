defmodule AdventOfCode.Day11 do
  def part1(input) do
    input
    |> parse_map
    |> loop_until_fixed_point(&play_round/1)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  def loop_until_fixed_point(input, f) do
    output = f.(input)
    if input == output, do: input, else: loop_until_fixed_point(output, f)
  end

  def play_round(map) do
    map
    |> Enum.reduce(%{}, fn {position, char}, new_map ->
      occupied_adjacent_count =
        position
        |> adjacent_positions()
        |> Enum.count(&(Map.get(map, &1) == "#"))

      new_map
      |> Map.put(
        position,
        case char do
          "L" -> if occupied_adjacent_count == 0, do: "#", else: "L"
          "#" -> if occupied_adjacent_count >= 4, do: "L", else: "#"
          "." -> "."
        end
      )
    end)
  end

  @directions [
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1}
  ]

  def adjacent_positions({i, j}) do
    @directions |> Enum.map(fn {di, dj} -> {i + di, j + dj} end)
  end

  def parse_map(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {row, i}, map ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn
        {char, j}, map -> map |> Map.put({i, j}, char)
      end)
    end)
  end

  def draw(map) do
    {min_i, max_i} = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_j, max_j} = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    IO.puts("Map")

    Enum.each(min_i..max_i, fn i ->
      Enum.each(min_j..max_j, fn j ->
        IO.write(map |> Map.get({i, j}))
      end)

      IO.write("\n")
    end)

    IO.write("\n")

    map
  end

  def part2(input) do
    input
    |> parse_map
    |> loop_until_fixed_point(&play_on_sight_round/1)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  def play_on_sight_round(map) do
    map
    |> Enum.reduce(%{}, fn {position, char}, new_map ->
      occupied_visible_count = map |> visible_occupied_seats(position)

      new_map
      |> Map.put(
        position,
        case char do
          "L" -> if occupied_visible_count == 0, do: "#", else: "L"
          "#" -> if occupied_visible_count >= 5, do: "L", else: "#"
          "." -> "."
        end
      )
    end)
  end

  def visible_occupied_seats(map, position) do
    @directions |> Enum.count(&(visible_char_in_direction(map, position, &1) == "#"))
  end

  def visible_char_in_direction(map, {i, j}, {di, dj}) do
    position = {i + di, j + dj}

    case map |> Map.get(position) do
      "." -> visible_char_in_direction(map, position, {di, dj})
      char -> char
    end
  end
end
