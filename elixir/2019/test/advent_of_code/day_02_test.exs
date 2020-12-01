defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    assert part1("2,4,4,5,99,0", 4, 4) == 2
    assert part1("1,1,1,4,99,5,6,0,99", 1, 1) == 30
  end

  test "part2" do
    assert part2("1,1,1,4,99,5,6,0,99", 30) == 0
  end
end
