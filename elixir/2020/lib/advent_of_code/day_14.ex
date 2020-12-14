defmodule AdventOfCode.Day14 do
  use Bitwise

  def part1(input) do
    input
    |> parse_program()
    |> run()
    |> Map.delete("mask")
    |> Map.values()
    |> Enum.sum()
  end

  def run(instructions, memory \\ %{})
  def run([], memory), do: memory

  def run([instruction | next_instructions], memory) do
    run(
      next_instructions,
      execute(instruction, memory)
    )
  end

  def parse_program(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn
      "mask = " <> mask ->
        {or_mask, _} = mask |> String.replace("X", "0") |> Integer.parse(2)
        {and_mask, _} = mask |> String.replace("X", "1") |> Integer.parse(2)
        {"mask", {or_mask, and_mask}}

      line ->
        %{"address" => address, "value" => value} =
          Regex.named_captures(~r/mem\[(?<address>\d*)\] = (?<value>\d*)/, line)

        {"mem", String.to_integer(address), String.to_integer(value)}
    end)
  end

  def execute({"mask", mask}, memory) do
    memory |> Map.put("mask", mask)
  end

  def execute({"mem", address, value}, memory) do
    {or_mask, and_mask} = memory |> Map.get("mask")
    memory |> Map.put(address, (value ||| or_mask) &&& and_mask)
  end

  def execute({"mask_v2", mask}, memory) do
    memory |> Map.put("mask", mask)
  end

  def execute({"mem_v2", address, value}, memory) do
    {or_mask, x_indexes} = memory |> Map.get("mask")

    address = address ||| or_mask

    x_indexes
    |> possible_addresses([address])
    |> Enum.reduce(memory, fn address, memory ->
      memory |> Map.put(address, value)
    end)
  end

  def part2(input) do
    input
    |> parse_program_v2()
    |> run()
    |> Map.delete("mask")
    |> Map.values()
    |> Enum.sum()
  end

  def parse_program_v2(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn
      "mask = " <> mask ->
        {or_mask, _} = mask |> String.replace("X", "0") |> Integer.parse(2)

        x_indexes =
          mask
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.map(fn
            {"X", i} -> 35 - i
            {_, _} -> nil
          end)
          |> Enum.filter(& &1)

        {"mask_v2", {or_mask, x_indexes}}

      line ->
        %{"address" => address, "value" => value} =
          Regex.named_captures(~r/mem\[(?<address>\d*)\] = (?<value>\d*)/, line)

        {"mem_v2", String.to_integer(address), String.to_integer(value)}
    end)
  end

  def possible_addresses([], addresses), do: addresses

  def possible_addresses([x_index | next_x_indexes], addresses) do
    possible_addresses(
      next_x_indexes,
      addresses
      |> Enum.flat_map(fn address ->
        reversed_bits =
          address
          |> Integer.to_string(2)
          |> String.pad_leading(36, "0")
          |> String.graphemes()
          |> Enum.reverse()

        ~w(0 1)
        |> Enum.map(fn bit ->
          reversed_bits
          |> List.replace_at(x_index, bit)
          |> Enum.reverse()
          |> Enum.join()
          |> Integer.parse(2)
          |> elem(0)
        end)
      end)
    )
  end
end
