defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "turn" do
    assert turn_right(">") == "v"
    assert turn_left(">") == "^"
  end
end
