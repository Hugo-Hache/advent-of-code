defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1" do
    input = """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """

    assert part1(input) == 7 * 5

    input = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """

    assert part1(input) == 22 * 10
  end

  test "part2" do
    input = """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """

    assert part2(input) == 8

    input = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """

    assert part2(input) == 19208
  end
end
