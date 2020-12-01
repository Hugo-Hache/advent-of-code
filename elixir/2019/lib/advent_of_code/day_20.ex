defmodule AdventOfCode.Day20 do
  def part1(input) do
    grid = input |> parse_grid

    from = grid |> Enum.find(fn {_, val} -> is_tuple(val) && elem(val, 0) == "AA" end) |> elem(1) |> elem(1)
    to = grid |> Enum.find(fn {_, val} -> is_tuple(val) && elem(val, 0) == "ZZ" end) |> elem(1) |> elem(1)
    grid |> shortest_distance(from, to, %{from => 0}, %{})
  end

  def part2(input) do
    grid = input |> parse_grid

    from = grid |> Enum.find(fn {_, val} -> is_tuple(val) && elem(val, 0) == "AA" end) |> elem(1) |> elem(1)
    to = grid |> Enum.find(fn {_, val} -> is_tuple(val) && elem(val, 0) == "ZZ" end) |> elem(1) |> elem(1)
    grid |> shortest_distance({from, 0}, {to, 0}, %{{from, 0} => 0}, %{})
  end

  def shortest_distance(_, position, to, distances, _) when position == to, do: distances |> Map.get(position)
  def shortest_distance(grid, position, to, distances, next_moves) do
    new_next_moves = next_moves |> add_next_moves(grid, distances, position)
    {visiting, distance} = new_next_moves |> Enum.min_by(fn {_, dist} -> dist end)
    new_next_moves = new_next_moves |> Map.delete(visiting)
    new_distances = distances |> Map.put(visiting, distance)
    grid |> shortest_distance(visiting, to, new_distances, new_next_moves)
  end

  def add_next_moves(next_moves, grid, distances, {{_, _} = coords, level} = position) do
    next_distance = distances[position] + 1

    coords
    |> neighbors
    |> Enum.reject(&(grid[&1] == "#"))
    |> Enum.map(fn neighbor ->
      case grid[neighbor] do
        "." -> {neighbor, level}
        {portal_name, portal_exit, outer} ->
          if portal_name not in ["AA", "ZZ"] do
            {portal_exit, (if outer, do: level - 1, else: level + 1)}
          end
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.reject(&(elem(&1, 1) < 0))
    |> Enum.reject(&(distances[&1] && next_distance > distances[&1]))
    |> Enum.reduce(next_moves, fn next_position, next_moves ->
      next_moves |> Map.update(
        next_position,
        next_distance,
        &(if next_distance < &1, do: next_distance, else: &1)
      )
    end)
  end

  def add_next_moves(next_moves, grid, distances, position) do
    next_distance = distances[position] + 1

    position
    |> neighbors
    |> Enum.reject(&(grid[&1] == "#"))
    |> Enum.map(fn neighbor ->
      case grid[neighbor] do
        "." -> neighbor
        {_, portal_exit, _} -> portal_exit
      end
    end)
    |> Enum.reject(&(distances[&1] && next_distance > distances[&1]))
    |> Enum.reduce(next_moves, fn next_coords, next_moves ->
      next_moves |> Map.update(
        next_coords,
        next_distance,
        &(if next_distance < &1, do: next_distance, else: &1)
      )
    end)
  end

  def parse_grid(input) do
    grid_without_portals = input
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, j}, grid ->
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(grid, fn {char, i}, grid ->
        case char do
          " " -> grid
          char -> grid |> Map.put({i, j}, char)
        end
      end)
    end)

    grid_with_unlinked_portals = grid_without_portals
    |> Enum.map(fn {coords, char} ->
      case char do
        c when c in ["#", "."] -> {coords, char}
        c -> parse_portal(grid_without_portals, coords, c)
      end
    end)
    |> Enum.reject(&is_nil/1)

    portal_exits = grid_with_unlinked_portals
    |> Enum.reduce(%{}, fn {_, val}, portal_exits ->
      case val do
        {portal_name, portal_exit} -> portal_exits |> Map.update(portal_name, [portal_exit], &([portal_exit | &1]))
        _ -> portal_exits
      end
    end)

    walls_coords = grid_without_portals |> Enum.filter(fn {_, char} -> char == "#" end) |> Keyword.keys
    {min_i, max_i} = walls_coords |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_j, max_j} = walls_coords |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    grid_with_unlinked_portals
    |> Enum.map(fn {{i, j} = coords, val} ->
      case val do
        {portal_name, portal_exit} -> {
            coords,
            {
              portal_name,
              (portal_exits[portal_name] |> Enum.find(&(&1 not in (coords |> neighbors)))) || portal_exit,
              i < min_i || i > max_i || j < min_j || j > max_j
            }
        }
        _ -> {coords, val}
      end
    end)
    |> Map.new
  end

  def parse_portal(grid, coords, char) do
    neighbor_passage_coords = coords |> neighbors |> Enum.find(&(grid[&1] == "."))
    if neighbor_passage_coords do
      other_letter_coords = {
        2 * elem(coords, 0) - elem(neighbor_passage_coords, 0),
        2 * elem(coords, 1) - elem(neighbor_passage_coords, 1)
      }
      other_letter = grid[other_letter_coords]
      portal_name = "#{char}#{other_letter}"
      portal_name = if coords > other_letter_coords, do: portal_name |> String.reverse, else: portal_name
      {coords, {portal_name, neighbor_passage_coords}}
    end
  end

  def neighbors({i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
  end

  def draw(grid) do
    {min_x, max_x} = grid |> Map.keys |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = grid |> Map.keys |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    Enum.each((min_y - 1)..(max_y + 1), fn j ->
      IO.write(pad(j))
      Enum.each((min_x - 1)..(max_x + 1), fn i ->
        case grid[{i, j}] do
          nil -> IO.write(" ")
          {passage_name, _, _} -> IO.write(passage_name)
          char -> IO.write(char)
        end
      end)
      IO.write("\n")
    end)

    grid
  end

  def pad(i) when i < 10, do: ".#{i}"
  def pad(i), do: "#{i}"
end
