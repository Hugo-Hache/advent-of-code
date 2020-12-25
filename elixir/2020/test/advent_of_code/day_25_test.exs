defmodule AdventOfCode.Day25Test do
  use ExUnit.Case

  import AdventOfCode.Day25

  test "part1" do
    input = """
    5764801
    17807724
    """

    assert part1(input) == 14_897_079
  end
end
