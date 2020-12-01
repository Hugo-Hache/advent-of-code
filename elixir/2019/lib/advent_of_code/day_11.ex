defmodule AdventOfCode.Day11 do
  def part1(input, inp \\ 0) do
    memory = input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {int, index}, mem ->
      mem |> Map.put(index, int)
    end)

    initial_brain = {memory, {0, 0}, {[inp], []}}
    initial_robot = {%{}, {0, 0}, {0, 1}}
    {_, robot} = paint(initial_brain, initial_robot)

    robot
    |> draw
    |> elem(0)
    |> Map.keys
    |> length
  end

  def part2(input) do
    part1(input, 1)
  end

  def paint(brain, {grid, location, direction} = robot) do
    {brain, operation} = intcode(brain)

    if operation == 99 do
      {brain, robot}
    else
      {memory, registers, {_, output}} = brain

      [rotation, color] = output
      grid = grid |> Map.put(location, color)
      direction = direction |> rotate(rotation)
      location = {elem(location, 0) + elem(direction, 0), elem(location, 1) + elem(direction, 1)}

      brain = {memory, registers, {[grid |> Map.get(location, 0)], []}}
      paint(brain, {grid, location, direction})
    end
  end

  def rotate({x, y}, rotation) do
    angle = :math.atan2(y, x)
    rotated_angle = angle + (if rotation == 0, do: 1, else: -1) * :math.pi / 2
    {round(:math.cos(rotated_angle)), round(:math.sin(rotated_angle))}
  end

  def intcode({memory, {position, _}, {input, _}} = machine) do
    opcode = memory[position]
    {operation, params_modes} = decode_opcode(opcode)

    if operation == 99 || (operation == 3 && input == []) do
      {machine, operation}
    else
      machine |> compute(operation, params_modes) |> intcode
    end
  end

  def decode_opcode(opcode) do
    digits = opcode |> Integer.digits
    digits = List.duplicate(0, 5 - length(digits)) ++ digits

    [decimal, unit | params_modes] = digits |> Enum.reverse
    operation = [unit, decimal] |> Integer.undigits
    {operation, params_modes}
  end

  def compute(machine, 1, params_modes) do
    machine |> two_params(params_modes, &(&1 + &2))
  end

  def compute(machine, 2, params_modes) do
    machine |> two_params(params_modes, &(&1 * &2))
  end

  def compute({memory, {position, relative_base}, {[input|rest], output}}, 3, params_modes) do
    output_position = memory |> Map.get(position + 1, 0)
    output_position = if Enum.at(params_modes, 0) == 2, do: output_position + relative_base, else: output_position
    {memory |> Map.put(output_position, input), {position + 2, relative_base}, {rest, output}}
  end

  def compute({memory, {position, relative_base} = registers, {input, output}}, 4, params_modes) do
    first_param_value = memory |> param_value(registers, params_modes, 0)
    {memory, {position + 2, relative_base}, {input, [first_param_value | output]}}
  end

  def compute(machine, 5, params_modes) do
    machine |> jump_if(params_modes, &(&1 != 0))
  end

  def compute(machine, 6, params_modes) do
    machine |> jump_if(params_modes, &(&1 == 0))
  end

  def compute(machine, 7, params_modes) do
    machine |> two_params(params_modes, &(if &1 < &2, do: 1, else: 0))
  end

  def compute(machine, 8, params_modes) do
    machine |> two_params(params_modes, &(if &1 == &2, do: 1, else: 0))
  end

  def compute({memory, {position, relative_base} = registers, io}, 9, params_modes) do
    offset = memory |> param_value(registers, params_modes, 0)
    {memory, {position + 2, relative_base + offset}, io}
  end

  def two_params({memory, {position, relative_base} = registers, io}, params_modes, f) do
    first_param_value = memory |> param_value(registers, params_modes, 0)
    second_param_value = memory |> param_value(registers, params_modes, 1)

    output_position = memory[position + 3]
    output_position = if Enum.at(params_modes, 2) == 2, do: relative_base + output_position, else: output_position

    new_value = f.(first_param_value, second_param_value)
    {memory |> Map.put(output_position, new_value), {position + 4, relative_base}, io}
  end

  def jump_if({memory, {position, relative_base} = registers, io}, params_modes, f) do
    first_param_value = memory |> param_value(registers, params_modes, 0)

    if f.(first_param_value) do
      second_param_value = memory |> param_value(registers, params_modes, 1)
      {memory, {second_param_value, relative_base}, io}
    else
      {memory, {position + 3, relative_base}, io}
    end
  end

  def param_value(memory, {position, relative_base}, modes, index) do
    mode = Enum.at(modes, index)
    param = memory[position + 1 + index]
    case mode do
      0 -> memory |> Map.get(param, 0)
      1 -> param
      2 -> memory |> Map.get(relative_base + param, 0)
    end
  end

  def draw({grid, {x, y} = pos, direction} = robot) do
    {min_x, max_x} = [pos | grid |> Map.keys] |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = [pos | grid |> Map.keys] |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    IO.puts("Grid")
    Enum.each((max_y + 1)..(min_y - 1), fn j ->
      Enum.each((min_x - 1)..(max_x + 1), fn i ->
        if i == x && j == y do
          case direction do
            {1, 0} -> IO.write(">")
            {-1, 0} -> IO.write("<")
            {0, 1} -> IO.write("^")
            {0, -1} -> IO.write("v")
          end
        else
          case grid[{i, j}] do
            0 -> IO.write(" ")
            1 -> IO.write("#")
            nil -> IO.write(" ")
          end
        end
      end)
      IO.write("\n")
    end)

    robot
  end
end
