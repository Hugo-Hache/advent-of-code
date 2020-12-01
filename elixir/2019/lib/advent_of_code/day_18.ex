defmodule AdventOfCode.Day18 do
  def part1(input) do
    grid = input |> parse_grid

    position = grid |> Enum.find(fn {_, char} -> char == "@" end) |> elem(0)
    milestones_to_collect = grid |> Enum.filter(fn {_, char} -> char not in ["#", ".", "@"] end) |> Enum.map(&(elem(&1, 1)))
    grid |> explore(%{}, position, milestones_to_collect) |> elem(0)
  end

  def parse_grid(input) do
    input
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, row}, grid ->
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(grid, fn
        {char, column}, grid -> grid |> Map.put({column,row}, char)
      end)
    end)
  end

  def explore(_, solutions, _, []), do: {0, solutions}
  def explore(grid, solutions, position, milestones_to_collect) do
    if solutions[grid] do
      {solutions[grid], solutions}
    else
      {shortest_steps, enriched_solutions} = next_milestones(grid, position)
      |> Enum.filter(fn {milestone, _, _} -> collectable?(milestone, milestones_to_collect) end)
      |> Enum.reduce({nil, solutions}, fn {milestone, additional_steps, milestone_position}, {shortest_steps, enriched_solutions} ->
        {steps, solutions} = grid
        |> Map.put(position, ".")
        |> Map.put(milestone_position, "@")
        |> explore(
          enriched_solutions,
          milestone_position,
          milestones_to_collect |> List.delete(milestone)
        )
        new_steps = additional_steps + steps

        {min(shortest_steps || new_steps, new_steps), solutions}
      end)

      {shortest_steps, enriched_solutions |> Map.put(grid, shortest_steps)}
    end
  end

  def collectable?(milestone, milestones_to_collect) do
    String.downcase(milestone) == milestone ||
      String.downcase(milestone) not in milestones_to_collect
  end

  def next_milestones(grid, position, previous_positions \\ [], steps \\ 0) do
    case grid[position] do
      "#" -> []
      c when c in [".", "@"] -> position |> neighbors |> Enum.reject(&(&1 in previous_positions)) |> Enum.flat_map(&(next_milestones(grid, &1, [position | previous_positions], steps + 1)))
      door_or_key -> [{door_or_key, steps, position}]
    end
  end

  def neighbors({i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
  end

  def part2(_) do
  end

  def draw(grid) do
    {min_x, max_x} = grid |> Map.keys |> Enum.reject(&(is_atom(&1))) |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = grid |> Map.keys |> Enum.reject(&(is_atom(&1)))  |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    Enum.each((min_y - 1)..(max_y + 1), fn j ->
      Enum.each((min_x - 1)..(max_x + 1), fn i ->
        case grid[{i, j}] do
          nil -> IO.write(" ")
          char -> IO.write(char)
        end
      end)
      IO.write("\n")
    end)

    grid
  end
end
