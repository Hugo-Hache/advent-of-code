defmodule AdventOfCode.Day01 do
  @target 2020

  def part1(input) do
    input
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> find_pairs(@target)
    |> List.first
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part2(input) do
    input
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> find_triplets(@target)
    |> List.first
    |> Enum.reduce(1, &(&1 * &2))
  end

  def find_pairs(amounts, target) do
    amounts
    |> Enum.reduce({MapSet.new, []}, fn amount, {candidate, pairs} ->
      complementary = target - amount

      if candidate |> MapSet.member?(complementary) do
        {
          candidate |> MapSet.delete(complementary),
          [[complementary, amount] | pairs]
        }
      else
        {candidate |> MapSet.put(amount), pairs}
      end
    end)
    |> elem(1)
  end

  def find_triplets(amounts, target, triplets \\ [])
  def find_triplets([amount | amounts], target, triplets) do
    new_triplets = find_pairs(amounts, target - amount)
                   |> Enum.map(&([amount | &1]))

    find_triplets(
      amounts,
      target,
      new_triplets ++ triplets
    )
  end
  def find_triplets([], _, triplets), do: triplets
end
