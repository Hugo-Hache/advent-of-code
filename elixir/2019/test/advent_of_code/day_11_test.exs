defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "rotate" do
    assert rotate({0,1}, 0) == {-1, 0}
    assert rotate({-1,0}, 0) == {0, -1}

    assert rotate({0,1}, 1) == {1, 0}
    assert rotate({1,0}, 1) == {0, -1}
  end
end
