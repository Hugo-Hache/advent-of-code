defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  import AdventOfCode.Day13

  test "part1" do
    assert parse_grid([4,5,6,3,2,1]) == %{{1, 2} => 3, {6, 5} => 4, ball: {6, 5}, paddle: {1, 2}}
  end
end
