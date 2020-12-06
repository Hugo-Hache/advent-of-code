defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    assert part1(input) == 11
  end

  test "part2" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    assert part2(input) == 6
  end
end
