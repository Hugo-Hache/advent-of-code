defmodule AdventOfCode.Day15 do
  require IEx

  def part1(input) do
    initial_position = {0,0}
    initial_grid = %{initial_position => 1}
    initial_distances = %{initial_position => 0}
    initial_next_moves = %{}
    initial_machine = {input |> parse_memory, {0, 0}, nil}

    {_, _, distances, oxygen_position} = initial_machine |> move(initial_grid, initial_distances, initial_position, initial_next_moves)
    distances[oxygen_position]
  end

  def part2(input) do
    initial_position = {0,0}
    initial_grid = %{initial_position => 1}
    initial_distances = %{initial_position => 0}
    initial_next_moves = %{}
    initial_machine = {input |> parse_memory, {0, 0}, nil}

    {machine, _, _, oxygen_position} = initial_machine |> move(initial_grid, initial_distances, initial_position, initial_next_moves)
    {_, _, distances, furthest_position} = machine |> move(%{oxygen_position => 2}, %{oxygen_position => 0}, oxygen_position, %{})
    distances[furthest_position]
  end

  def move(machine, grid, distances, position, next_moves) do
    new_next_moves = next_moves |> add_next_moves(machine, grid, distances, position)
    if new_next_moves == %{} do
      {machine, grid, distances, position}
    else
      {visiting, {distance, machine}} = new_next_moves |> Enum.min_by(fn {_, {dist, _}} -> dist end)
      new_next_moves = new_next_moves |> Map.delete(visiting)

      {new_machine, _} = machine |> intcode
      {_, _, {_, [status]}} = new_machine
      new_grid = grid |> Map.put(visiting, status)
      new_distances = distances |> Map.put(visiting, distance)

      case status do
        0 -> machine |> move(new_grid, distances, position, new_next_moves)
        1 -> new_machine |> move(new_grid, new_distances, visiting, new_next_moves)
        2 -> {new_machine, new_grid, new_distances, visiting}
      end
    end
  end

  def add_next_moves(next_moves, {memory, registers, _}, grid, distances, position) do
    next_distance = distances[position] + 1

    position
    |> neighbors
    |> Enum.reject(&(grid[&1] == 0 || grid[&1] == 2))
    |> Enum.reject(&(grid[&1] == 1 && next_distance > distances[&1]))
    |> Enum.reduce(next_moves, fn neighbor, next_moves ->
      machine = {memory, registers, {[command(position, neighbor)], []}}
      next_moves |> Map.update(
        neighbor,
        {next_distance, machine},
        fn {d, m} ->
          if next_distance < d, do: {next_distance, machine}, else: {d, m}
        end
      )
    end)
  end

  def neighbors({i, j}) do
    [{i + 1, j}, {i - 1, j}, {i, j + 1}, {i, j - 1}]
  end

  def command({_, y0}, {_, y1}) when y1 == y0 + 1, do: 1
  def command({_, y0}, {_, y1}) when y1 == y0 - 1, do: 2
  def command({x0, _}, {x1, _}) when x1 == x0 - 1, do: 3
  def command({x0, _}, {x1, _}) when x1 == x0 + 1, do: 4

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

  def draw(grid, distances, position) do
    position |> IO.inspect(label: "Current position")

    {min_x, max_x} = grid |> Map.keys |> Enum.map(&(elem(&1, 0))) |> Enum.min_max
    {min_y, max_y} = grid |> Map.keys |> Enum.map(&(elem(&1, 1))) |> Enum.min_max

    Enum.each((max_y + 1)..(min_y - 1), fn j ->
      Enum.each((min_x - 1)..(max_x + 1), fn i ->
        if {i, j} == position do
          IO.write("D")
        else
          case grid[{i, j}] do
            0 -> IO.write("###")
            1 -> IO.write(pad(distances[{i, j}]))
            2 -> IO.write(" O ")
            nil -> IO.write("   ")
          end
        end
      end)
      IO.write("\n")
    end)
  end

  def pad(i) when i < 10, do: ".#{i}."
  def pad(i) when i < 100, do: ".#{i}"
  def pad(i), do: "#{i}"
end

