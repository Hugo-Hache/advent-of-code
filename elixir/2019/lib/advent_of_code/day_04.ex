defmodule AdventOfCode.Day04 do
  def part1(input) do
    [from | [to]] = input |> String.split("-") |> Enum.map(&String.to_integer/1)
    (from..to) |> Enum.count(&valid_password/1)
  end

  def valid_password(password) do
    digits = password |> Integer.digits
    {
      increasing,
      consecutive,
      _
    } = digits
        |> tl
        |> Enum.reduce(
          {true, false, hd(digits)},
          fn (digit, {valid, consecutive, last_digit}) ->
            {
              valid && last_digit <= digit,
              consecutive || last_digit == digit,
              digit
            }
          end
        )

    increasing && consecutive
  end

  def part2(input) do
    [from | [to]] = input |> String.split("-") |> Enum.map(&String.to_integer/1)
    (from..to)
    |> Enum.filter(&valid_password/1)
    |> Enum.filter(&contains_double/1)
    |> length
  end

  def contains_double(password) do
    password
    |> Integer.digits
    |> Enum.chunk_by(&(&1))
    |> Enum.any?(fn serie -> length(serie) == 2 end)
  end
end
