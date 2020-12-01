defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = """
    1969
    100756
    """
    result = part1(input)

    assert result == 654 + 33583
  end

  test "part2" do
    input = """
    1969
    100756
    """
    result = part2(input)

    assert result == 966 + 50346
  end
end
