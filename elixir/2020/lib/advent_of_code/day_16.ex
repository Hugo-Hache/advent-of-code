defmodule AdventOfCode.Day16 do
  def part1(input) do
    {rules, _, nearby_tickets} = input |> parse_input()

    all_ranges = rules |> Map.values() |> List.flatten()

    nearby_tickets
    |> Enum.reduce([], fn ticket, invalid_fields ->
      ticket
      |> Enum.reduce(invalid_fields, fn field, invalid_fields ->
        if all_ranges |> Enum.any?(&(field in &1)) do
          invalid_fields
        else
          [field | invalid_fields]
        end
      end)
    end)
    |> Enum.sum()
  end

  def parse_input(input) do
    [rules_lines, my_ticket_lines, nearby_tickets_lines] =
      input
      |> String.split("\n\n")
      |> Enum.map(fn lines ->
        lines |> String.split("\n") |> Enum.filter(&(String.length(&1) > 0))
      end)

    {
      parse_rules(rules_lines),
      my_ticket_lines |> parse_tickets() |> hd(),
      nearby_tickets_lines |> parse_tickets()
    }
  end

  def parse_rules(rules) do
    rules
    |> Enum.reduce(%{}, fn line, rules ->
      [name, ranges] = line |> String.split(": ")

      ranges =
        ranges
        |> String.split(" or ")
        |> Enum.map(fn interval ->
          [low, high] = interval |> String.split("-") |> Enum.map(&String.to_integer/1)
          low..high
        end)

      rules |> Map.put(name, ranges)
    end)
  end

  def parse_tickets([_ | tickets_lines]) do
    tickets_lines
    |> Enum.map(fn line ->
      line |> String.split(",") |> Enum.map(&String.to_integer/1)
    end)
  end

  def part2(input, field_name \\ "departure") do
    {rules, my_ticket, nearby_tickets} = input |> parse_input()
    valid_tickets = nearby_tickets |> valid_tickets(rules)

    rules
    |> possible_fields_by_index(valid_tickets)
    |> Enum.sort_by(fn {_, v} -> length(v) end)
    |> Enum.reduce(%{}, fn {index, possible_rules}, rules_index ->
      available_rule = possible_rules |> Enum.filter(&(!Map.has_key?(rules_index, &1))) |> hd

      Map.put(rules_index, available_rule, index)
    end)
    |> Enum.filter(fn {rule, _} -> rule |> String.starts_with?(field_name) end)
    |> Enum.map(fn {_, index} -> my_ticket |> Enum.at(index) end)
    |> Enum.reduce(&(&1 * &2))
  end

  def valid_tickets(tickets, rules) do
    all_ranges = rules |> Map.values() |> List.flatten()

    tickets
    |> Enum.filter(fn ticket ->
      ticket |> Enum.all?(fn field -> all_ranges |> Enum.any?(&(field in &1)) end)
    end)
  end

  def possible_fields_by_index(rules, nearby_tickets) do
    nearby_tickets
    |> Enum.reduce(%{}, fn ticket, possible_fields_by_index ->
      ticket
      |> Enum.with_index()
      |> Enum.reduce(possible_fields_by_index, fn {field, index}, possible_fields_by_index ->
        possible_fields =
          rules
          |> Enum.filter(fn {_, ranges} -> ranges |> Enum.any?(&(field in &1)) end)
          |> Enum.map(&elem(&1, 0))

        possible_fields_by_index
        |> Map.update(index, possible_fields, fn
          [] -> possible_fields
          existing_fields -> existing_fields |> Enum.filter(&(&1 in possible_fields))
        end)
      end)
    end)
  end
end
