defmodule AdventOfCode.Day08 do
  def part1(input) do
    input
    |> parse_program
    |> run
    |> elem(1)
  end

  def part2(input) do
    input
    |> parse_program
    |> mutate
    |> Enum.map(&run/1)
    |> Enum.find(fn {exit_code, _} -> exit_code == 0 end)
    |> elem(1)
  end

  def parse_program(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, i}, program ->
      [ins, param] = line |> String.split(" ")
      program |> Map.put(i, {ins, String.to_integer(param)})
    end)
  end

  def mutate(program) do
    program
    |> Enum.reduce([], fn {position, {ins, param}}, mutations ->
      case ins do
        "acc" -> mutations
        "jmp" -> [program |> Map.put(position, {"nop", param}) | mutations]
        "nop" -> [program |> Map.put(position, {"jmp", param}) | mutations]
      end
    end)
  end

  def run(program, {position, accumulator} = machine \\ {0, 0}, visited_positions \\ MapSet.new()) do
    if MapSet.member?(visited_positions, position) do
      {-1, accumulator}
    else
      if !Map.has_key?(program, position) do
        {0, accumulator}
      else
        run(
          program,
          program |> Map.get(position) |> execute(machine),
          visited_positions |> MapSet.put(position)
        )
      end
    end
  end

  def execute({"nop", _}, {position, accumulator}) do
    {position + 1, accumulator}
  end

  def execute({"acc", param}, {position, accumulator}) do
    {position + 1, accumulator + param}
  end

  def execute({"jmp", param}, {position, accumulator}) do
    {position + param, accumulator}
  end
end
