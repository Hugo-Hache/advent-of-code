defmodule AdventOfCode.Day05 do
  def part1(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&seat_id/1)
    |> Enum.max()
  end

  def part2(input) do
    seat_ids =
      input
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&seat_id/1)

    {min_id, max_id} = Enum.min_max(seat_ids)
    min_id..max_id |> Enum.filter(&(!(&1 in seat_ids)))
  end

  def seat_id(boarding_pass) do
    [row, column] =
      boarding_pass
      |> String.replace(["B", "R"], "1")
      |> String.replace(["F", "L"], "0")
      |> String.split_at(7)
      |> Tuple.to_list()
      |> Enum.map(&String.to_integer(&1, 2))

    row * 8 + column
  end

  def range_seat_id(boarding_pass) do
    {{min_row, _}, {min_column, _}} =
      boarding_pass
      |> String.graphemes()
      |> Enum.reduce({{0, 127}, {0, 7}}, fn letter,
                                            {{min_row, max_row}, {min_column, max_column}} ->
        case letter do
          "F" ->
            {{min_row, max_row - div(Enum.count(min_row..max_row), 2)}, {min_column, max_column}}

          "B" ->
            {{min_row + div(Enum.count(min_row..max_row), 2), max_row}, {min_column, max_column}}

          "L" ->
            {{min_row, max_row},
             {min_column, max_column - div(Enum.count(min_column..max_column), 2)}}

          "R" ->
            {{min_row, max_row},
             {min_column + div(Enum.count(min_column..max_column), 2), max_column}}
        end
      end)

    min_row * 8 + min_column
  end
end
