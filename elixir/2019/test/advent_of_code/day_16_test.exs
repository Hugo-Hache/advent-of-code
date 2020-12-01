defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  test "part1" do
    assert part1("12345678", 4), "01029498"
    assert part1("80871224585914546619083218645595") == "24176176"
  end

  test "part2" do
    assert part2("03036732577212944063491565474664") == "84462026"
  end
end
