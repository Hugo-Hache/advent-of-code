defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "part1" do
    input = """
    .#.
    ..#
    ###
    """

    assert part1(input) == 112
  end

  test "part2" do
    input = """
    .#.
    ..#
    ###
    """

    assert part2(input) == 848
  end
end
