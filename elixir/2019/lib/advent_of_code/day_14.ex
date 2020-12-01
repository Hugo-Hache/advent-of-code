defmodule AdventOfCode.Day14 do
  def part1(input) do
    reactions = input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.reduce(%{}, fn recipe, reactions ->
      [ingredients, product] = recipe |> String.split(" => ")
      {elem_product, quantity_product} = product |> parse_ingredient
      reaction = {quantity_product, ingredients |> String.split(", ") |> Enum.map(&parse_ingredient/1)}
      reactions |> Map.put(elem_product, reaction)
    end)

    oreplexities = reactions |> oreplexity(%{"ORE" => 0}, ["ORE"], 1)
    substitute({%{"FUEL" => 1}, %{}}, reactions, oreplexities)
  end

  def part2(input) do
    reactions = input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.reduce(%{}, fn recipe, reactions ->
      [ingredients, product] = recipe |> String.split(" => ")
      {elem_product, quantity_product} = product |> parse_ingredient
      reaction = {quantity_product, ingredients |> String.split(", ") |> Enum.map(&parse_ingredient/1)}
      reactions |> Map.put(elem_product, reaction)
    end)

    oreplexities = reactions |> oreplexity(%{"ORE" => 0}, ["ORE"], 1)
    ore_for_one_fuel = substitute({%{"FUEL" => 1}, %{}}, reactions, oreplexities)
    min_fuel = div(1000000000000, ore_for_one_fuel)
    slow_start(min_fuel, 0, fn fuel ->
      substitute({%{"FUEL" => fuel}, %{}}, reactions, oreplexities) < 1000000000000
    end)
  end

  def slow_start(base, power, f) do
    val = base + :math.pow(2, power)
    if f.(val) do
      slow_start(base, power + 1, f)
    else
      if power == 0 do
        base
      else
        slow_start(base + :math.pow(2, power - 1), 0, f)
      end
    end
  end

  def oreplexity([], oreplexities, _, _), do: oreplexities
  def oreplexity(reactions, oreplexities, available_elems, degree) do
    {fulfilled_reactions, other_reactions} = reactions
    |> Enum.split_with(fn {_, {_, ingredients}} ->
      ingredients_elems = ingredients |> Enum.map(fn {e, _} -> e end)
      length(ingredients_elems -- available_elems) == 0
    end)

    fulfilled_elems = fulfilled_reactions |> Keyword.keys
    oreplexities = oreplexities |> Map.merge(fulfilled_elems |> Enum.map(&({&1, degree})) |> Map.new)
    oreplexity(other_reactions, oreplexities, available_elems ++ fulfilled_elems, degree + 1)
  end

  def substitute({required, produced}, reactions, oreplexities) do
    if required |> Map.keys == ["ORE"] do
      required["ORE"]
    else
      {elem, quantity} = required |> Enum.max_by(fn {e, _} -> oreplexities[e] end)
      {produced, to_produce_quantity} = consume(produced, quantity, elem)

      {produced_quantity, ingredients} = reactions[elem]
      multiple = trunc(Float.ceil(to_produce_quantity / produced_quantity))
      leftovers = (produced_quantity * multiple) - to_produce_quantity
      produced = produced |> Map.update(elem, leftovers, &(&1 + leftovers))

      required_ingredients = ingredients
                             |> Enum.map(fn {e, q} -> {e, multiple * q} end)
                             |> Map.new

      required = required
                 |> Map.delete(elem)
                 |> Map.merge(required_ingredients, fn _, q1, q2 -> q1 + q2 end)

      substitute({required, produced}, reactions, oreplexities)
    end
  end

  def consume(produced, quantity, elem) do
    available = produced |> Map.get(elem, 0)
    if available > 0 do
      consumed = min(available, quantity)
      {produced |> Map.put(elem, available - consumed), quantity - consumed}
    else
      {produced, quantity}
    end
  end

  def parse_ingredient(ingredient) do
    [quantity, elem] = ingredient |> String.split
    {elem, quantity |> String.to_integer}
  end
end
