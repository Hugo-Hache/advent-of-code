defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  test "part1" do
    assert part1("1 + 2 * 3 + 4 * 5 + 6") == 71
    assert part1("2 * 3 + (4 * 5)") == 26
    assert part1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632
  end

  test "part2" do
    assert part2("1 + 2 * 3 + 4 * 5 + 6") == 231
  end
end
