defmodule AdventOfCode.Day07 do
  require IEx

  def part1(input) do
    integers = input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple

    max_seq = (0..4)
              |> Enum.to_list
              |> permutations
              |> Enum.max_by(&(amplify(integers, &1)))
    amplify(integers, max_seq)
  end

  def part2(input) do
    integers = input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple

    max_seq = (5..9)
              |> Enum.to_list
              |> permutations
              |> Enum.max_by(&(looped_amplify(integers, &1)))
    looped_amplify(integers, max_seq)
  end

  def permutations([]), do: [[]]
  def permutations(list) do
    for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]
  end

  def amplify(integers, sequence) do
    sequence |> Enum.reduce(0, fn phase, input ->
      integers |> amplify(phase, input)
    end)
  end

  def amplify(integers, phase, input) do
    io = {[phase, input], []}
    machine = {integers, 0, io}
    {{_, _, {_, output}}, _} = intcode(machine)
    hd(output)
  end

  def looped_amplify(integers, sequence) do
    sequence |> Enum.map(&({{integers, 0, {[&1], []}}, 42})) |> loop(0)
  end

  def loop(thrusters, input) do
    fake_init_thruster = {[], 0, {[], [input]}}

    looped_thrusters = thrusters
    |> Enum.reduce([{fake_init_thruster, 42}], fn thruster, looped_thrusters ->
      [previous_looped_thruster | _] = looped_thrusters
      {{_, _, {_, [previous_output | _]}}, _}  = previous_looped_thruster

      {{integers, position, {input, output}}, _} = thruster
      looped_thruster = intcode({integers, position, {input ++ [previous_output], output}})
      [looped_thruster | looped_thrusters]
    end)

    {{_,_,{_, [last_output | _]}}, stop_operation} = hd(looped_thrusters)
    if stop_operation == 99 do
      last_output
    else
      loop(looped_thrusters |> Enum.reverse |> tl, last_output)
    end
  end

  def intcode({integers, position, {input, _}} = machine) do
    opcode = elem(integers, position)
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

  def compute({integers, position, {[input|rest], output}}, 3, _) do
    output_position = elem(integers, position + 1)
    {integers |> put_elem(output_position, input), position + 2, {rest, output}}
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

