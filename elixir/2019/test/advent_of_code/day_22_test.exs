defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  test "part1" do
    input = """
    deal with increment 7
    deal into new stack
    deal into new stack
    """
    assert part1(input, 9) == [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]

    input = """
    cut 6
    deal with increment 7
    deal into new stack
    """
    assert part1(input, 9) == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
