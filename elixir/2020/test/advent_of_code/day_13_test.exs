defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  test "part1" do
    input = """
    939
    7,13,x,x,59,x,31,19
    """

    assert part1(input) == 295
  end

  test "part2" do
    input = """
    939
    7,13,x,x,59,x,31,19
    """

    assert part2(input) == 1_068_781

    input = """
    939
    17,x,13,19
    """

    assert part2(input) == 3417

    input = """
    939
    67,7,59,61
    """

    assert part2(input) == 754_018

    input = """
    939
    67,x,7,59,61
    """

    assert part2(input) == 779_210

    input = """
    939
    67,7,x,59,61
    """

    assert part2(input) == 1_261_476

    input = """
    939
    1789,37,47,1889
    """

    assert part2(input) == 1_202_161_486
  end
end
