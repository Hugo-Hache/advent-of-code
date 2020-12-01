defmodule AdventOfCode.Day03 do
  def part1(input) do
    visited_locs = input
    |> String.split
    |> Enum.map(fn (paths) -> paths |> String.split(",") end)
    |> explore

    closest_intersection(visited_locs)
  end

  def part2(input) do
    visited_locs = input
    |> String.split
    |> Enum.map(fn (paths) -> paths |> String.split(",") end)
    |> explore

    closest_steps_intersection(visited_locs)
  end

  def explore(paths) do
    paths
    |> Enum.with_index
    |> Enum.reduce(%{}, fn ({path, index}, visited_locs) ->
      path |> follow(visited_locs, "Wire #{index}")
    end)
  end

  def follow(path, visited_locs, wire) do
    initial_loc = visited_locs |> Map.get({0, 0}, %{}) |> Map.put(wire, 0)
    visited_locs = visited_locs |> Map.put({0, 0}, initial_loc)

    path
    |> Enum.reduce({{0, 0}, visited_locs}, fn (section, grid) -> walk(section, grid, wire) end)
    |> elem(1)
  end

  def walk(section, grid, wire) do
    [direction | rest] = String.graphemes(section)
    extent = String.to_integer(Enum.join(rest))
    vectors = %{
      "U" => {0, 1},
      "D" => {0, -1},
      "L" => {-1, 0},
      "R" => {1, 0}
    }
    vector = vectors[direction]

    Enum.reduce(1..extent, grid, fn(_, {loc, visited_locs}) ->
      steps = visited_locs[loc][wire] + 1
      new_loc = loc |> move(vector)
      {
        new_loc,
        visited_locs |> Map.put(
          new_loc,
          Map.get(visited_locs, new_loc, %{}) |> Map.put(wire, steps)
        )
      }
    end)
  end

  def move(loc, vector) do
    {
      elem(loc, 0) + elem(vector, 0),
      elem(loc, 1) + elem(vector, 1)
    }
  end

  def closest_intersection(visited_locs) do
    visited_locs
    |> Enum.filter(fn {loc, wires} -> loc != {0, 0} && Map.size(wires) > 1 end)
    |> Keyword.keys
    |> Enum.map(&distance/1)
    |> Enum.min
  end

  def closest_steps_intersection(visited_locs) do
    visited_locs
    |> Enum.filter(fn {loc, wires} -> loc != {0, 0} && Map.size(wires) > 1 end)
    |> Enum.map(fn {_, wires} -> Enum.sum(wires |> Map.values) end)
    |> Enum.min
  end

  def distance(loc) do
    abs(elem(loc, 0)) + abs(elem(loc, 1))
  end

  def print(visited_locs) do
    {min_x, max_x} = visited_locs |> Map.keys |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = visited_locs |> Map.keys |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    Enum.each(max_y..min_y, fn j ->
      Enum.each(min_x..max_x, fn i ->
        if i == 0 && j == 0 do
          IO.write("o")
        else
          case visited_locs[{i, j}] do
            1 -> IO.write(".")
            2 -> IO.write("X")
            nil -> IO.write(" ")
          end
        end
      end)
      IO.write("\n")
    end)
  end
end
