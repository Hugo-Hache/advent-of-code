defmodule AdventOfCode.Day23Test do
  use ExUnit.Case

  import AdventOfCode.Day23

  test "part1" do
    input = "389125467"

    assert part1(input) == "67384529"
  end

  test "part2" do
    # A bit long
    # assert part2("389125467") == "149245887792"
  end
end
