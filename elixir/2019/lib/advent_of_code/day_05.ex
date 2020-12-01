defmodule AdventOfCode.Day05 do
  def part1(input) do
    integers = input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple

    io = {1, []}
    machine = {integers, 0, io}
    {integers, _, {_, output}} = intcode(machine)

    # output |> IO.inspect(label: "Output: ")

    integers
    |> Tuple.to_list
    |> Enum.join(",")
  end

  def part2(input, machine_input \\ 5) do
    integers = input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple

    io = {machine_input, []}
    machine = {integers, 0, io}
    {integers, _, {_, output}} = intcode(machine)

    output
    #|> IO.inspect(label: "Output: ")
    |> hd
  end

  def intcode({integers, position, _} = machine) do
    opcode = elem(integers, position)
    {operation, params_modes} = decode_opcode(opcode)

    if operation == 99 do
      machine
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

  def compute({integers, position, {input, output} = io}, 3, _) do
    output_position = elem(integers, position + 1)
    {integers |> put_elem(output_position, input), position + 2, io}
  end

  def compute({integers, position, {input, output}}, 4, params_modes) do
    first_param_value = param_value(integers, position + 1, Enum.at(params_modes, 0))
    {integers, position + 2, {input, [first_param_value | output]}}
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

  def two_params({integers, position, io}, params_modes, f) do
    first_param_value = param_value(integers, position + 1, Enum.at(params_modes, 0))
    second_param_value = param_value(integers, position + 2, Enum.at(params_modes, 1))
    output_position = elem(integers, position + 3)

    new_value = f.(first_param_value, second_param_value)
    {integers |> put_elem(output_position, new_value), position + 4, io}
  end

  def jump_if({integers, position, io}, params_modes, f) do
    first_param_value = param_value(integers, position + 1, Enum.at(params_modes, 0))

    if f.(first_param_value) do
      second_param_value = param_value(integers, position + 2, Enum.at(params_modes, 1))
      {integers, second_param_value, io}
    else
      {integers, position + 3, io}
    end
  end

  def param_value(integers, param_position, mode) do
    param = elem(integers, param_position)
    if mode == 0, do: elem(integers, param), else: param
  end
end
