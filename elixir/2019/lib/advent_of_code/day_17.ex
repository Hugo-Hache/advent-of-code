defmodule AdventOfCode.Day17 do
  def part1(input) do
    {{_, _, {_, output}}, _} = intcode({input |> parse_memory, {0, 0}, {[], []}})

    output
    |> Enum.reverse
    |> parse_grid
    |> intersections
    |> Enum.map(fn {i, j} -> i * j end)
    |> Enum.sum
  end

  def part2(input) do
    {{_, _, {_, output}}, _} = intcode({input |> parse_memory, {0, 0}, {[], []}})

    {_, _, _moves} = output
    |> Enum.reverse
    |> parse_grid
    |> explore

    #moves
    #|> Enum.reverse
    #|> IO.inspect
    #
    # ["R", 12, "L", 10, "R", 12, "L", 8, "R", 10, "R", 6, "R", 12, "L", 10, "R", 12,
    # "R", 12, "L", 10, "R", 10, "L", 8, "L", 8, "R", 10, "R", 6, "R", 12, "L", 10,
    # "R", 10, "L", 8, "L", 8, "R", 10, "R", 6, "R", 12, "L", 10, "R", 10, "L", 8,
    # "R", 12, "L", 10, "R", 12, "R", 12, "L", 10, "R", 10, "L", 8]
    #
    # Handmade A = "R", 12, "L", 10, "R", 12
    # B = "L", 8, "R", 10, "R", 6
    # C = "R", 12, "L", 10, "R", 10, "L", 8
    # [A, B, A, C, B, C, B, C, A, C]

    instructions = [
      ["A", "B", "A", "C", "B", "C", "B", "C", "A", "C"],
      ["R", "12", "L", "10", "R", "12"],
      ["L", "8", "R", "10", "R", "6"],
      ["R", "12", "L", "10", "R", "10", "L", "8"]
    ] |> Enum.map(fn line ->
      codes = line
      |> Enum.intersperse(",")
      |> Enum.map(fn s -> s |> String.to_charlist end)
      |> List.flatten

      codes ++ ("\n" |> String.to_charlist)
    end)
    instructions = (instructions ++ ["n\n" |> String.to_charlist]) |> List.flatten

    memory = input |> String.replace_prefix("1", "2") |> parse_memory
    {{_, _, {_, output}}, _} = intcode({memory, {0, 0}, {instructions, []}})
    output |> hd
  end

  def explore(grid) do
    position = grid |> Enum.find(fn {_, char} -> char == "^" end)
    move(grid, position, [])
  end

  def move(grid, position, moves) do
    move_straight(grid, position, moves) ||
      move_right(grid, position, moves) ||
        move_left(grid, position, moves) ||
          {grid, position, moves}
  end

  def move_straight(_, _, []), do: nil
  def move_straight(grid, {loc, dir}, [units | rest]) do
    next_loc = {loc, dir} |> next_location
    if grid[next_loc] in ["#", "y"] do
      grid |> Map.put(loc, "y") |> move({next_loc, dir}, [units + 1 | rest])
    end
  end

  def move_right(grid, {loc, dir}, moves) do
    new_dir = turn_right(dir)
    next_loc = {loc, new_dir} |> next_location
    if grid[next_loc] in ["#", "y"] do
      grid |> Map.put(loc, "y") |> move({next_loc, new_dir}, [1 | ["R" | moves]])
    end
  end

  def move_left(grid, {loc, dir}, moves) do
    new_dir = turn_left(dir)
    next_loc = {loc, new_dir} |> next_location
    if grid[next_loc] in ["#", "y"] do
      grid |> Map.put(loc, "y") |> move({next_loc, new_dir}, [1 | ["L" | moves]])
    end
  end

  def next_location({{i, j}, "^"}), do: {i, j - 1}
  def next_location({{i, j}, ">"}), do: {i + 1, j}
  def next_location({{i, j}, "<"}), do: {i - 1, j}
  def next_location({{i, j}, "v"}), do: {i, j + 1}

  def turn_right(direction), do: turn(direction, 1)
  def turn_left(direction), do: turn(direction, -1)
  def turn(direction, offset) do
    directions = ["^", ">", "v", "<"]
    index = directions |> Enum.find_index(&(&1 == direction))
    new_index = case index + offset do
      -1 -> 3
      4 -> 0
      i -> i
    end
    directions |> Enum.at(new_index)
  end

  def parse_grid(output) do
    output
    |> Enum.drop_while(&(&1 == 10))
    |> Enum.reduce({%{}, 0, 0}, fn code, {grid, i, j} ->
      case code do
        10 -> {grid, 0, j + 1}
        code -> {grid |> Map.put({i, j}, List.to_string([code])), i + 1, j}
      end
    end)
    |> elem(0)
    |> draw
  end

  def intersections(grid) do
    grid |> Enum.reduce([], fn
      {position, "#"}, intersections ->
        if grid |> intersection?(position), do: [position | intersections], else: intersections
      {_, _}, intersections -> intersections
    end)
  end

  def intersection?(grid, position) do
    (position |> neighbors |> Enum.count(&(grid[&1] == "#"))) > 2
  end

  def neighbors({i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
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
    IO.puts "Interpreted"

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
