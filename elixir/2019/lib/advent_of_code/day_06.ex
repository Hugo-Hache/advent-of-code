defmodule AdventOfCode.Day06 do
  def part1(input) do
    direct_orbits = input
    |> String.split
    |> Enum.map(&(&1 |> String.split(")")))
    |> Enum.reduce(%{}, fn ([orbited, orbiter | _], direct_orbits) ->
      orbiters = direct_orbits |> Map.get(orbited, [])
      direct_orbits |> Map.put(orbited, [orbiter | orbiters])
    end)

    [center | _] = (direct_orbits |> Map.keys) -- (direct_orbits |> Map.values |> List.flatten)
    all_orbits_count(center, direct_orbits, 0)
  end

  def all_orbits_count(planet, direct_orbits, count) do
    case direct_orbits[planet] do
      nil -> count
      orbiters -> count + (orbiters |> Enum.map(&(all_orbits_count(&1, direct_orbits, count + 1))) |> Enum.sum)
    end
  end

  def part2(input) do
    rev_direct_orbits = input
    |> String.split
    |> Enum.map(&(&1 |> String.split(")")))
    |> Enum.reduce(%{}, fn ([orbited, orbiter | _], direct_orbits) ->
      direct_orbits |> Map.put(orbiter, orbited)
    end)

    san_ancestors = ancestors("SAN", rev_direct_orbits, [])
    you_ancestors = ancestors("YOU", rev_direct_orbits, [])

    remove_common([san_ancestors, you_ancestors]) |> List.flatten |> Enum.count
  end

  def ancestors(planet, rev_direct_orbits, ancestors) do
    case rev_direct_orbits[planet] do
      nil -> ancestors
      orbited -> ancestors(orbited, rev_direct_orbits, [orbited | ancestors])
    end
  end

  def remove_common(lists) do
    if lists |> Enum.map(&hd/1) |> Enum.dedup |> Enum.count == 1 do
      remove_common(lists |> Enum.map(&tl/1))
    else
      lists
    end
  end
end
