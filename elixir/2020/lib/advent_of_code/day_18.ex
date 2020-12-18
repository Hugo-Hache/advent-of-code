defmodule AdventOfCode.Day18 do
  require IEx

  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&eval/1)
    |> Enum.sum()
  end

  def eval(input) do
    if String.match?(input, ~r/^\d+$/) do
      String.to_integer(input)
    else
      {first_arg, rest} = next_token(input)
      {op, rest} = next_token(rest)
      {second_arg, rest} = next_token(rest)

      result =
        case op do
          "+" -> eval(first_arg) + eval(second_arg)
          "*" -> eval(first_arg) * eval(second_arg)
        end

      if String.length(rest) > 0 do
        eval([result, rest] |> Enum.join(" "))
      else
        result
      end
    end
  end

  def next_token("(" <> string) do
    token =
      string
      |> String.graphemes()
      |> Enum.reduce_while({[], 0}, fn char, {chars, level} ->
        case {char, level} do
          {")", 0} -> {:halt, chars |> Enum.reverse() |> Enum.join()}
          {")", level} -> {:cont, {[char | chars], level - 1}}
          {"(", level} -> {:cont, {[char | chars], level + 1}}
          {char, level} -> {:cont, {[char | chars], level}}
        end
      end)

    {_, rest} = string |> String.split_at(String.length(token) + 2)

    {token, rest}
  end

  def next_token(string) do
    case string |> String.split(" ", parts: 2) do
      [token, rest] -> {token, rest}
      [token] -> {token, ""}
    end
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&advanced_eval/1)
    |> Enum.sum()
  end

  def advanced_eval(input) do
    if String.match?(input, ~r/^\d+$/) do
      String.to_integer(input)
    else
      input
      |> tokens()
      |> Enum.reduce([[]], fn
        "*", parts -> [[] | parts]
        "+", parts -> parts
        token, parts -> [[advanced_eval(token) | hd(parts)] | tl(parts)]
      end)
      |> Enum.map(&Enum.sum/1)
      |> Enum.reduce(&(&1 * &2))
    end
  end

  def tokens(string, tokens \\ [])
  def tokens("", tokens), do: tokens

  def tokens(string, tokens) do
    {token, rest} = next_token(string)
    tokens(rest, [token | tokens])
  end
end
