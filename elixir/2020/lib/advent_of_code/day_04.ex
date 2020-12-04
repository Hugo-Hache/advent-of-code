defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> parse_passports()
    |> Enum.filter(fn passport ->
      ~w(byr iyr eyr hgt hcl ecl pid)
      |> Enum.all?(&Map.has_key?(passport, &1))
    end)
    |> length()
  end

  def part2(input) do
    input
    |> parse_passports()
    |> Enum.filter(fn passport ->
      ~w(byr iyr eyr hgt hcl ecl pid)
      |> Enum.all?(&valid_field?(passport, &1))
    end)
    |> length()
  end

  def parse_passports(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn pairs ->
      pairs
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.map(&List.to_tuple(&1))
      |> Map.new()
    end)
  end

  def valid_field?(%{"byr" => year}, "byr"),
    do: int_in_range?(year, 1920..2002)

  def valid_field?(%{"iyr" => year}, "iyr"),
    do: int_in_range?(year, 2010..2020)

  def valid_field?(%{"eyr" => year}, "eyr"),
    do: int_in_range?(year, 2020..2030)

  def valid_field?(%{"hgt" => <<height::binary-size(3)>> <> "cm"}, "hgt"),
    do: int_in_range?(height, 150..193)

  def valid_field?(%{"hgt" => <<height::binary-size(2)>> <> "in"}, "hgt"),
    do: int_in_range?(height, 59..76)

  def valid_field?(%{"hcl" => hex_color}, "hcl"),
    do: String.match?(hex_color, ~r/^#[0-9a-f]{6}$/)

  def valid_field?(%{"ecl" => eye_color}, "ecl"),
    do: eye_color in ~w(amb blu brn gry grn hzl oth)

  def valid_field?(%{"pid" => pid}, "pid"),
    do: String.match?(pid, ~r/^[0-9]{9}$/)

  def valid_field?(_, _), do: false

  def int_in_range?(string, range) do
    try do
      String.to_integer(string) in range
    rescue
      ArgumentError -> false
    end
  end
end
