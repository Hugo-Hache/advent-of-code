defmodule AdventOfCode.Day10 do
  def part1(input) do
    differences =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [j1, j2] -> j2 - j1 end)
      |> Enum.frequencies()

    (Map.get(differences, 1) + 1) * (Map.get(differences, 3) + 1)
  end

  def part2(input) do
    if :ets.whereis(:memo) == :undefined do
      :ets.new(:memo, [:named_table])
    else
      :ets.delete_all_objects(:memo)
    end

    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> List.insert_at(0, 0)
    |> Enum.sort(:desc)
    |> count_distinct_arrangements()
  end

  def count_distinct_arrangements(joltages) when length(joltages) <= 2, do: 1

  def count_distinct_arrangements([joltage | previous_joltages] = joltages) do
    case :ets.lookup(:memo, joltages) do
      [] ->
        count =
          acceptable_next_joltages(joltage, previous_joltages)
          |> Enum.map(&count_distinct_arrangements/1)
          |> Enum.sum()

        :ets.insert(:memo, {joltages, count})
        count

      [{_, count}] ->
        count
    end
  end

  def acceptable_next_joltages(joltage, joltages, acceptables \\ [])
  def acceptable_next_joltages(_, [], acceptables), do: acceptables

  def acceptable_next_joltages(joltage, joltages, acceptables) do
    if joltage - hd(joltages) > 3,
      do: acceptables,
      else: acceptable_next_joltages(joltage, tl(joltages), [joltages | acceptables])
  end
end
