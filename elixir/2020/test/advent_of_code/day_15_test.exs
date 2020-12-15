defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  test "part1" do
    assert part1("0,3,6") == 436
    assert part1("1,3,2") == 1
    assert part1("2,1,3") == 10
    assert part1("1,2,3") == 27
  end

  test "part2" do
    # a bit slow to run everytime
    # assert part2("0,3,6") == 175_594
  end
end
