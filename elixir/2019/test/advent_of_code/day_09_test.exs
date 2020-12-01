defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  test "part1" do
    assert part1("1102,34915192,34915192,7,4,7,99,0") == 1219070632396864
    assert part1("104,1125899906842624,99") == 1125899906842624
    assert part1("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99") == 99
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
