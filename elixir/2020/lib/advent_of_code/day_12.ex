defmodule AdventOfCode.Day12 do
  def part1(input) do
    input
    |> parse_instructions()
    |> navigate({{0, 0}, {1, 0}})
    |> elem(0)
    |> manhattan_distance()
  end

  def parse_instructions(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn <<letter::binary-size(1)>> <> param ->
      {letter, String.to_integer(param)}
    end)
  end

  def navigate([], situation), do: situation

  def navigate([instruction | next_instructions], situation) do
    navigate(
      next_instructions,
      follow_instruction(instruction, situation)
    )
  end

  def follow_instruction({"N", param}, {{x, y}, direction}), do: {{x, y + param}, direction}
  def follow_instruction({"S", param}, {{x, y}, direction}), do: {{x, y - param}, direction}
  def follow_instruction({"E", param}, {{x, y}, direction}), do: {{x + param, y}, direction}
  def follow_instruction({"W", param}, {{x, y}, direction}), do: {{x - param, y}, direction}

  def follow_instruction({"R", param}, {position, direction}),
    do: {position, rotate(direction, -param)}

  def follow_instruction({"L", param}, {position, direction}),
    do: {position, rotate(direction, param)}

  def follow_instruction({"F", param}, {{x, y}, {dx, dy}}),
    do: {{x + param * dx, y + param * dy}, {dx, dy}}

  def rotate({dx, dy}, degrees) do
    radians = :math.pi() / 180.0 * degrees

    {
      Float.round(:math.cos(radians) * dx - :math.sin(radians) * dy),
      Float.round(:math.sin(radians) * dx + :math.cos(radians) * dy)
    }
  end

  def manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end

  def part2(input) do
    input
    |> parse_instructions()
    |> navigate_with_waypoint({{0, 0}, {10, 1}})
    |> elem(0)
    |> manhattan_distance()
  end

  def navigate_with_waypoint([], situation), do: situation

  def navigate_with_waypoint([instruction | next_instructions], situation) do
    navigate_with_waypoint(
      next_instructions,
      follow_waypoint_instruction(instruction, situation)
    )
  end

  def follow_waypoint_instruction({"N", param}, {position, {wx, wy}}),
    do: {position, {wx, wy + param}}

  def follow_waypoint_instruction({"S", param}, {position, {wx, wy}}),
    do: {position, {wx, wy - param}}

  def follow_waypoint_instruction({"E", param}, {position, {wx, wy}}),
    do: {position, {wx + param, wy}}

  def follow_waypoint_instruction({"W", param}, {position, {wx, wy}}),
    do: {position, {wx - param, wy}}

  def follow_waypoint_instruction({"R", param}, {position, waypoint}),
    do: {position, rotate(waypoint, -param)}

  def follow_waypoint_instruction({"L", param}, {position, waypoint}),
    do: {position, rotate(waypoint, param)}

  def follow_waypoint_instruction({"F", param}, {{x, y}, {wx, wy}}),
    do: {{x + param * wx, y + param * wy}, {wx, wy}}
end
