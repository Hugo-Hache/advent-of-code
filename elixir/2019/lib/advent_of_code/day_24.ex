defmodule AdventOfCode.Day24 do
  def part1(input) do
    repeat_detector(%{}, input |> parse_grid)
  end

  def repeat_detector(former_grids, grid) do
    new_grid = grid |> tick
    new_biodiversity = new_grid |> biodiversity
    if former_grids[new_biodiversity] do
      new_biodiversity
    else
      repeat_detector(
        former_grids |> Map.put(new_biodiversity, new_grid),
        new_grid
      )
    end
  end

  def biodiversity(grid) do
    width = grid |> Map.keys |> Enum.map(&(elem(&1, 0))) |> Enum.max

    Enum.reduce(grid, 0, fn {{i, j}, char}, sum ->
      case char do
        "." -> sum
        "#" -> sum + :math.pow(2, i + j * (width + 1))
      end
    end)
  end

  def tick(grid) do
    grid
    |> Enum.map(fn {coords, char} ->
      adjacent_bugs = neighbors(coords) |> Enum.count(&(grid[&1] == "#"))

      {
        coords,
        case char do
          "#" -> if adjacent_bugs == 1, do: "#", else: "."
          "." -> if Enum.member?(1..2, adjacent_bugs), do: "#", else: "."
        end
      }
    end)
    |> Map.new
  end

  def neighbors({i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
  end

  def parse_grid(input) do
    input
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, j}, grid ->
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(grid, fn {char, i}, grid ->
          grid |> Map.put({i, j}, char)
      end)
    end)
  end

  def draw(grid) do
    {min_x, max_x} = grid |> Map.keys |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = grid |> Map.keys |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    Enum.each((min_y - 1)..(max_y + 1), fn j ->
      Enum.each((min_x - 1)..(max_x + 1), fn i ->
        IO.write(grid[{i, j}])
      end)
      IO.write("\n")
    end)

    grid
  end

  def part2(input, minutes \\ 200) do
    (1..minutes)
    |> Enum.reduce(input |> parse_sparse_grid, fn _, sparse_grid ->
      sparse_tick(sparse_grid)
    end)
    |> map_size
  end

  def parse_sparse_grid(input) do
    input
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, j}, grid ->
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.filter(fn {char, _} -> char == "#" end)
      |> Enum.reduce(grid, fn {char, i}, grid ->
        grid |> Map.put({i, j, 0}, char)
      end)
    end)
  end

  def sparse_tick(sparse_grid) do
    sparse_grid
    |> Map.keys
    |> Enum.flat_map(&([&1 | recursive_neighbors(&1)]))
    |> Enum.uniq
    |> Enum.reduce(%{}, fn coords, new_sparse_grid ->
      adjacent_bugs = recursive_neighbors(coords) |> Enum.count(&(sparse_grid[&1]))

      if sparse_grid[coords] do
        if adjacent_bugs == 1, do: Map.put(new_sparse_grid, coords, "#"), else: new_sparse_grid
      else
        if Enum.member?(1..2, adjacent_bugs), do: Map.put(new_sparse_grid, coords, "#"), else: new_sparse_grid
      end
    end)
  end

  def recursive_neighbors({i, j, k}) do
    [{i + 1, j, k}, {i - 1, j, k}, {i, j + 1, k}, {i, j - 1, k}]
    |> Enum.map(fn
      {-1, _, z} -> {1, 2, z - 1}
      {5, _, z} -> {3, 2, z - 1}
      {_, -1, z} -> {2, 1, z - 1}
      {_, 5, z} -> {2, 3, z - 1}
      {2, 2, z} -> case {i, j} do
        {1, 2} -> (0..4) |> Enum.map(&({0, &1, z + 1}))
        {3, 2} -> (0..4) |> Enum.map(&({4, &1, z + 1}))
        {2, 1} -> (0..4) |> Enum.map(&({&1, 0, z + 1}))
        {2, 3} -> (0..4) |> Enum.map(&({&1, 4, z + 1}))
      end
      neighbors_coords -> neighbors_coords
    end)
    |> List.flatten
  end

  def recursive_draw(sparse_grid) do
    Enum.each(-5..5, fn k ->
      IO.puts("Depth #{k}")
      Enum.each(0..4, fn j ->
        Enum.each(0..4, fn i ->
          IO.write(sparse_grid[{i, j, k}] || ".")
        end)
        IO.write("\n")
      end)
      IO.write("\n")
    end)

    sparse_grid
  end
end
