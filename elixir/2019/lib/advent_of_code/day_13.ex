defmodule AdventOfCode.Day13 do
  require IEx

  def part1(input) do
    {{_, _, {_, output}}, _} = {input |> parse_memory, {0, 0}, {[], []}} |> intcode

    output
    |> parse_grid
    |> Enum.count(fn {_, v} -> v == 2 end)
  end

  def part2(input) do
    {input |> parse_memory |> Map.put(0, 2), {0, 0}, {[], []}} |> play(%{})
  end

  def play(machine, grid) do
    {{memory, registers, {_, output}}, operation} = machine |> intcode
    new_grid = grid |> Map.merge(output |> parse_grid)

    if operation == 3 do
      {memory, registers, {[next_tilt(grid, new_grid)], []}} |> play(new_grid)
    else
      new_grid[:score]
    end
  end

  def next_tilt(previous_grid, grid) when previous_grid == %{}, do: compare(grid[:ball], grid[:paddle])
  def next_tilt(%{ball: {x_previous_ball, y_previous_ball}}, %{paddle: {x_paddle, y_paddle}, ball: {x_ball, y_ball}}) do
    if y_ball < y_previous_ball do
      compare(x_ball, x_paddle)
    else
      y_impact = y_paddle - 1
      x_impact = x_ball + (x_ball - x_previous_ball) * (y_impact - y_ball)
      compare(x_impact, x_paddle)
    end
  end

  def parse_memory(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {int, index}, mem ->
      mem |> Map.put(index, int)
    end)
  end

  def parse_grid(output) do
    output
    |> Enum.reverse
    |> Enum.chunk_every(3)
    |> Enum.reduce(%{}, fn [x, y, tile_id], grid ->
      if x == -1 && y == 0 do
        grid |> Map.put(:score, tile_id)
      else
        grid = if tile_id == 3, do: grid |> Map.put(:paddle, {x, y}), else: grid
        grid = if tile_id == 4, do: grid |> Map.put(:ball, {x, y}), else: grid
        grid |> Map.put({x, y}, tile_id)
      end
    end)
  end

  def compare(i1, i2) when i1 == i2, do: 0
  def compare(i1, i2) when i1 < i2, do: -1
  def compare(i1, i2) when i1 > i2, do: 1

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

  def draw(grid) do
    {min_x, max_x} = grid |> Map.keys |> Enum.filter(&is_tuple/1) |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = grid |> Map.keys |> Enum.filter(&is_tuple/1) |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    IO.puts("Current score #{grid[:score]}")
    Enum.each((max_y + 1)..(min_y - 1), fn j ->
      Enum.each((min_x - 1)..(max_x + 1), fn i ->
        case grid[{i, j}] do
          0 -> IO.write(" ")
          1 -> IO.write("#")
          2 -> IO.write("B")
          3 -> IO.write("_")
          4 -> IO.write("o")
          nil -> IO.write(" ")
        end
      end)
      IO.write("\n")
    end)
  end
end
