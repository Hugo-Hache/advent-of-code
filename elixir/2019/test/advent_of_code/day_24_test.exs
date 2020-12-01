defmodule AdventOfCode.Day24Test do
  use ExUnit.Case

  import AdventOfCode.Day24

  test "part1" do
    input = """
    ....#
    #..#.
    #..##
    ..#..
    #....
    """

    assert part1(input) == 2129920
  end

  test "part2" do
    input = """
    ....#
    #..#.
    #.?##
    ..#..
    #....
    """

    assert part2(input, 10) == 99
  end
end
