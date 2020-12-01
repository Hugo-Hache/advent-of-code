defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "decode_opcode" do
    assert decode_opcode(4) == {4, [0, 0, 0]}
    assert decode_opcode(1002) == {2, [0, 1, 0]}
  end

  test "part1" do
    assert part1("3,0,4,0,99") == "1,0,4,0,99"
    assert part1("1002,4,3,4,33") == "1002,4,3,4,99"
    assert part1("1101,100,-1,4,0") == "1101,100,-1,4,99"
  end

  test "part2" do
    assert part2("3,9,8,9,10,9,4,9,99,-1,8", 8) == 1
    assert part2("3,9,8,9,10,9,4,9,99,-1,8", 42) == 0

    assert part2("3,9,7,9,10,9,4,9,99,-1,8", 7) == 1
    assert part2("3,9,7,9,10,9,4,9,99,-1,8", 8) == 0
    assert part2("3,9,7,9,10,9,4,9,99,-1,8", 9) == 0

    assert part2("3,3,1108,-1,8,3,4,3,99", 8) == 1
    assert part2("3,3,1108,-1,8,3,4,3,99", 42) == 0

    assert part2("3,3,1107,-1,8,3,4,3,99", 7) == 1
    assert part2("3,3,1107,-1,8,3,4,3,99", 8) == 0
    assert part2("3,3,1107,-1,8,3,4,3,99", 9) == 0

    assert part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", 0) == 0
    assert part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", 42) == 1

    assert part2("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", 0) == 0
    assert part2("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", 42) == 1
  end
end
