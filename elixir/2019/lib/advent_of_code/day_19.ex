defmodule AdventOfCode.Day19 do
  def part1(input) do
    memory = input |> parse_memory

    grid = (0..49) |> Enum.reduce(%{}, fn j, grid ->
      (0..49) |> Enum.reduce(grid, fn i, grid ->
        {{_, _, {_, output}}, _} = intcode({memory, {0, 0}, {[i, j], []}})
        grid |> Map.put({i, j}, output |> hd)
      end)
    end)

    grid |> Enum.count(fn {_, affected} -> affected == 1 end)
  end

  def part2(input) do
    {i, j} = input |> parse_memory |> landing_north_east_corner({15, 16})
    (i - 99) * 10000 + j
  end

  def landing_north_east_corner(memory, {i, j}) do
    unless memory |> attracted?({i, j}), do: raise("Oops #{i},#{j}")
    lower_row_east_corner = memory |> east_corner({i, j + 1})
    if memory |> landing?(lower_row_east_corner) do
      lower_row_east_corner
    else
      memory |> landing_north_east_corner(lower_row_east_corner)
    end
  end

  def landing?(memory, {i, j}) do
    memory |> attracted?({i - 99, j + 99})
  end

  def east_corner(memory, {i, j}) do
    if memory |> attracted?({i + 1, j}) do
      east_corner(memory, {i + 1, j})
    else
      {i, j}
    end
  end

  def attracted?(memory, {i, j}) do
    {{_, _, {_, output}}, _} = intcode({memory, {0, 0}, {[i, j], []}})
    output |> hd == 1
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
    {min_x, max_x} = grid |> Map.keys |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = grid |> Map.keys |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    Enum.each((min_y - 1)..(max_y + 1), fn j ->
      IO.write(pad(j))
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

  def pad(i) when i < 10, do: ".#{i}"
  def pad(i), do: "#{i}"
end

