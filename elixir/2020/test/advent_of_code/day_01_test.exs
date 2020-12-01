defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "part1" do
    input = """
    1721
    979
    366
    299
    675
    1456
    """
    result = part1(input)

    assert result == 514579
  end

  test "part2" do
    input = """
    1721
    979
    366
    299
    675
    1456
    """
    result = part2(input)

    assert result == 241861950
  end
end
