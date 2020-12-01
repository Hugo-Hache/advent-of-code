defmodule AdventOfCode.Day10 do
  def part1(input) do
    parse_asteroids(input)
    |> detect
    |> Enum.max_by(fn {_, detectables} -> length(detectables) end)
    |> elem(1)
    |> length
  end

  def part2(input, nth_asteroid \\ 200) do
    {x, y} = parse_asteroids(input)
    |> detect
    |> Enum.max_by(fn {_, detectables} -> length(detectables) end)
    |> clockwise_points
    |> Enum.at(nth_asteroid - 1)

    100 * x + y
  end

  def detect(asteroids) do
    asteroids |> Enum.reduce(%{}, fn asteroid, detectables ->
      asteroids |> Enum.reduce(detectables, fn neighbor, d ->
        d |> detect(asteroid, neighbor)
      end)
    end)
  end

  def detect(detectables, asteroid, neighbor) when asteroid == neighbor, do: detectables
  def detect(detectables, asteroid, neighbor) do
    {in_line_asteroids, other_asteroids} = detectables
    |> Map.get(asteroid, [])
    |> Enum.split_with(&(in_line(asteroid, neighbor, &1)))

    closest_in_line = [neighbor | in_line_asteroids]
                      |> Enum.min_by(&(square_magnitude(asteroid, &1)))
    detectables |> Map.put(asteroid, [closest_in_line | other_asteroids])
  end

  def clockwise_points({{x0, y0}, points}) do
    points |> Enum.sort_by(fn {x, y} ->
      angle = :math.atan2(x - x0, - (y - y0))
      if angle < 0, do: 2 * :math.pi + angle, else: angle
    end)
  end

  def vector({x0, y0}, {x, y}) do
    {x - x0, y - y0}
  end

  def in_line(origin, a, b), do: in_line(vector(origin, a), vector(origin, b))
  def in_line({x1, y1}, {x2, y2}) do
    x1 * y2 == x2 * y1 && (x1 * x2 + y1 * y2) > 0
  end

  def square_magnitude(origin, a), do: square_magnitude(vector(origin, a))
  def square_magnitude({x, y}) do
    x * x + y * y
  end

  def parse_asteroids(input) do
    input
    |> String.split
    |> Enum.with_index
    |> Enum.flat_map(fn {line, row} ->
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.filter(fn {char, _} -> char == "#" end)
      |> Enum.map(fn {_, column} -> {column, row} end)
    end)
  end
end
