defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Day08

  test "part1" do
    assert part1("121256789012", 3, 2) == 4
  end

  test "part2" do
    assert part2("0222112222120000", 2, 2) == ["0","1","1","0"]
  end
end
