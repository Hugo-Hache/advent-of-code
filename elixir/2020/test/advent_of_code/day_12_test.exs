defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    assert part1(input) == 25
  end

  test "part2" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """

    assert part2(input) == 286
  end
end
