defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  test "valid_password" do
    assert valid_password(111111) == true
    assert valid_password(223450) == false
    assert valid_password(123789) == false
  end

  test "part1" do
    assert part1("111-122") == 10
  end

  test "contains_double" do
    assert contains_double(112233) == true
    assert contains_double(123444) == false
    assert contains_double(111122) == true
  end
end
