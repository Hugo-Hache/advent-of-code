defmodule AdventOfCode.Day09 do
  def part1(input, buffer_size \\ 25) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.split(buffer_size)
    |> find_intruder()
  end

  def find_pairs(numbers, target) do
    numbers
    |> Enum.reduce({MapSet.new(), []}, fn number, {candidates, pairs} ->
      complementary = target - number

      if candidates |> MapSet.member?(complementary) do
        {
          candidates |> MapSet.delete(complementary),
          [[complementary, number] | pairs]
        }
      else
        {candidates |> MapSet.put(number), pairs}
      end
    end)
    |> elem(1)
  end

  def find_intruder({buffer, numbers}) do
    numbers
    |> Enum.reduce_while(buffer, fn number, buffer ->
      if length(find_pairs(buffer, number)) > 0 do
        {:cont, tl(buffer) ++ [number]}
      else
        {:halt, number}
      end
    end)
  end

  def part2(input, buffer_size \\ 25) do
    numbers =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    intruder =
      numbers
      |> Enum.split(buffer_size)
      |> find_intruder()

    {min, max} =
      find_slice(numbers, intruder)
      |> Enum.min_max()

    min + max
  end

  def find_slice(numbers, target) do
    {slice, other_numbers} = numbers |> Enum.split(2)

    other_numbers
    |> Enum.reduce_while({slice, Enum.sum(slice)}, fn number, {slice, sum} ->
      if sum < target do
        {:cont, {slice ++ [number], sum + number}}
      else
        {slice, sum} = thin_slice({slice, sum}, target)
        if sum == target, do: {:halt, slice}, else: {:cont, {slice ++ [number], sum + number}}
      end
    end)
  end

  def thin_slice({slice, sum}, target) do
    if sum > target, do: thin_slice({tl(slice), sum - hd(slice)}, target), else: {slice, sum}
  end
end
