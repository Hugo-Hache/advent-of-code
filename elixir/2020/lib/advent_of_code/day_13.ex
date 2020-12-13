defmodule AdventOfCode.Day13 do
  def part1(input) do
    [first_line, second_line] =
      input
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))

    earliest_timestamp = String.to_integer(first_line)

    bus_ids =
      second_line
      |> String.split(",")
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer/1)

    {reminder, bus_id} =
      bus_ids
      |> Enum.map(&{&1, &1 * Float.ceil(earliest_timestamp / &1) - earliest_timestamp})
      |> Enum.min_by(&elem(&1, 1))

    reminder * bus_id
  end

  def part2(input) do
    rules =
      input
      |> String.split("\n")
      |> Enum.at(1)
      |> String.split(",")
      |> Enum.with_index()
      |> Enum.filter(fn {id, _} -> id != "x" end)
      |> Enum.map(fn {id, delay} -> {String.to_integer(id), delay} end)
      |> Enum.sort(fn {first_id, _}, {second_id, _} -> first_id > second_id end)

    {id, delay} = hd(rules)

    sieve_match_rules(tl(rules), id - delay, id)
  end

  def sieve_match_rules([], candidate, _), do: candidate

  def sieve_match_rules([{id, delay} | other_rules] = rules, candidate, step) do
    if rem(candidate + delay, id) == 0 do
      sieve_match_rules(other_rules, candidate, step * id)
    else
      sieve_match_rules(rules, candidate + step, step)
    end
  end
end
