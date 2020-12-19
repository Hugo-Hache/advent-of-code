defmodule AdventOfCode.Day19 do
  def part1(input, f \\ &as_regex/3) do
    [rules_lines, messages_lines] = input |> String.split("\n\n")

    rules = parse_rules(rules_lines)
    messages = messages_lines |> String.split("\n") |> Enum.filter(&(String.length(&1) > 0))

    {:ok, regex} = "^#{f.("0", rules, f)}$" |> Regex.compile()
    messages |> Enum.count(&String.match?(&1, regex))
  end

  def parse_rules(lines) do
    lines
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, rules ->
      %{"index" => index, "rule" => rule} =
        Regex.named_captures(~r/(?<index>\d+): (?<rule>.*)/, line)

      if rule |> String.starts_with?("\"") do
        [_, letters, _] = rule |> String.split("\"")
        rules |> Map.put(index, letters)
      else
        rules
        |> Map.put(
          index,
          rule |> String.split(" | ") |> Enum.map(&String.split(&1, " "))
        )
      end
    end)
  end

  def as_regex(rule_id, rules, f) do
    rule = rules |> Map.get(rule_id)

    if is_binary(rule) do
      rule
    else
      regex =
        rule
        |> Enum.map(fn rule_ids ->
          rule_ids
          |> Enum.map(&f.(&1, rules, f))
          |> Enum.join()
        end)
        |> Enum.join("|")

      "(" <> regex <> ")"
    end
  end

  def part2(input) do
    part1(input, &as_handmade_regex/3)
  end

  def as_handmade_regex("8", rules, f),
    do: "(#{as_regex("42", rules, f)}+)"

  def as_handmade_regex("11", rules, f) do
    left_group = as_regex("42", rules, f)
    right_group = as_regex("31", rules, f)

    regex =
      1..4
      |> Enum.map(fn repeat ->
        "#{left_group}{#{repeat}}#{right_group}{#{repeat}}"
      end)
      |> Enum.join("|")

    "(" <> regex <> ")"
  end

  def as_handmade_regex(rule_id, rules, f), do: as_regex(rule_id, rules, f)
end
