defmodule AdventOfCode.Day12 do
  def part1(input, steps \\ 1000) do
    parse_moons(input)
    |> animate(steps)
    |> total_energy
  end

  def part2(input) do
    moons = parse_moons(input)
    moons |> animate |> animate_until_cycle(moons |> states, {nil, nil, nil}, 1)
  end

  def animate_until_cycle(moons, first_states, cycles, steps) do
    new_cycles = moons |> compute_cycles(first_states, cycles, steps)
    {cycle_x, cycle_y, cycle_z} = new_cycles

    if cycle_x && cycle_y && cycle_z do
      lcm(trunc(cycle_x), trunc(cycle_y), trunc(cycle_z))
    else
      animate_until_cycle(moons |> animate, first_states, new_cycles, steps + 1)
    end
  end

  def compute_cycles(moons, {first_state_x, first_state_y, first_state_z}, {cycle_x, cycle_y, cycle_z}, steps) do
    {state_x, state_y, state_z} = moons |> states
    new_cycle_x = state_x |> compute_cycle(first_state_x, cycle_x, steps)
    new_cycle_y = state_y |> compute_cycle(first_state_y, cycle_y, steps)
    new_cycle_z = state_z |> compute_cycle(first_state_z, cycle_z, steps)

    {new_cycle_x, new_cycle_y, new_cycle_z}
  end

  def states(moons) do
    moons
    |> Enum.map(fn {coords, velocities}  ->
      coords |> Enum.zip(velocities)
    end)
    |> Enum.zip
    |> List.to_tuple
  end

  def compute_cycle(state, histo, nil, steps) do
    if state == histo, do: steps, else: nil
  end
  def compute_cycle(_, _, cycle, _), do: cycle

  def animate(moons, 0), do: moons
  def animate(moons, steps) do
    animate(moons |> animate, steps - 1)
  end

  def animate(moons) do
    moons |> Enum.map(fn {coords, velocities} ->
      new_velocities = velocities |> accelerate(coords, moons)
      {add(coords, new_velocities), new_velocities}
    end)
  end

  def accelerate(velocities, coords, moons) do
    moons |> Enum.reduce(velocities, fn {m_coords, _}, velocities ->
      add(velocities, compare(m_coords, coords))
    end)
  end

  def total_energy(moons) do
    moons
    |> Enum.map(fn {coords, velocities} ->
      energy(coords) * energy(velocities)
    end)
    |> Enum.sum
  end

  def energy(values) do
    values |> Enum.reduce(0, &(&2 + abs(&1)))
  end

  def compare(coords_1, coords_2) when is_list(coords_1) do
    coords_1 |> Enum.zip(coords_2) |> Enum.map(fn {c1, c2} -> compare(c1, c2) end)
  end
  def compare(i1, i2) when i1 == i2, do: 0
  def compare(i1, i2) when i1 < i2, do: -1
  def compare(i1, i2) when i1 > i2, do: 1

  def add(coords_1, coords_2) do
    coords_1 |> Enum.zip(coords_2) |> Enum.map(fn {c1, c2} -> c1 + c2 end)
  end

  def lcm(a,b,c), do: div(lcm(a,b)*c, gcd(lcm(a,b),c))
  def lcm(a,b), do: div(abs(a*b), gcd(a,b))

  def gcd(a,0), do: abs(a)
  def gcd(a,b), do: gcd(b, rem(a,b))

  def parse_moons(input) do
    input
    |> String.split("\n")
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(fn coords ->
      coords = Regex.run(~r/x=(-?\d+), y=(-?\d+), z=(-?\d+)/, coords)
      |> tl
      |> Enum.map(&String.to_integer/1)

      {coords, [0, 0, 0]}
    end)
  end
end
