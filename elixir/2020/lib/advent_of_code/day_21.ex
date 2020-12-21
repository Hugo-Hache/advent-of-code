defmodule AdventOfCode.Day21 do
  def part1(input) do
    foods =
      input
      |> parse_foods()

    culprits =
      foods
      |> gather_suspects()
      |> convict_culprits()

    foods
    |> Enum.reduce(0, fn {ingredients, _}, count ->
      count + Enum.count(ingredients, &(!Map.has_key?(culprits, &1)))
    end)
  end

  def parse_foods(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.reduce([], fn line, foods ->
      %{"ingredients" => ingredients, "allergens" => allergens} =
        Regex.named_captures(~r/(?<ingredients>.*) \(contains (?<allergens>.*)\)/, line)

      ingredients = ingredients |> String.split(" ")
      allergens = allergens |> String.split(", ")

      [{ingredients, allergens} | foods]
    end)
    |> Enum.reverse()
  end

  def gather_suspects(foods) do
    foods
    |> Enum.reduce(%{}, fn {ingredients, allergens}, suspects ->
      allergens
      |> Enum.reduce(suspects, fn allergen, suspects ->
        suspects
        |> Map.update(allergen, ingredients, fn existing_suspects ->
          existing_suspects |> Enum.filter(&(&1 in ingredients))
        end)
      end)
    end)
  end

  def convict_culprits(suspects, culprits \\ %{}) do
    new_culprits =
      suspects
      |> Enum.reduce(%{}, fn
        {ingredient, [culprit]}, new_culprits ->
          new_culprits |> Map.put(culprit, ingredient)

        _, new_culprits ->
          new_culprits
      end)

    if map_size(new_culprits) > 0 do
      filtered_suspects =
        suspects
        |> Enum.reduce(%{}, fn {ingredient, suspects}, filtered_suspects ->
          filtered_suspects
          |> Map.put(ingredient, suspects |> Enum.filter(&(!Map.has_key?(new_culprits, &1))))
        end)

      convict_culprits(
        filtered_suspects,
        culprits |> Map.merge(new_culprits)
      )
    else
      culprits
    end
  end

  def part2(input) do
    input
    |> parse_foods()
    |> gather_suspects()
    |> convict_culprits()
    |> Enum.sort_by(fn {_, allergen} -> allergen end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join(",")
  end
end
