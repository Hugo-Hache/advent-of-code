defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  test "next_milestones" do
    input = """
    #########
    #b.A.@.a#
    #########
    """
    grid = input |> parse_grid
    assert grid |> next_milestones({5, 1}) == [{"a", 2, {7, 1}}, {"A", 2, {3, 1}}]
  end

  test "collectable?" do
    assert "a" |> collectable?([])
    assert "A" |> collectable?(["b"])
    refute "A" |> collectable?(["b", "a"])
  end

  test "part1" do
    input = """
    #########
    #b.A.@.a#
    #########
    """
    assert part1(input) == 8

    input = """
    ########################
    #f.D.E.e.C.b.A.@.a.B.c.#
    ######################.#
    #d.....................#
    ########################
    """
    assert part1(input) == 86

    input = """
    ########################
    #...............b.C.D.f#
    #.######################
    #.....@.a.B.c.d.A.e.F.g#
    ########################
    """
    assert part1(input) == 132

    _input = """
    #################
    #i.G..c...e..H.p#
    ########.########
    #j.A..b...f..D.o#
    ########@########
    #k.E..a...g..B.n#
    ########.########
    #l.F..d...h..C.m#
    #################
    """
    #assert part1(input) == 136

    _input = """
    ########################
    #@..............ac.GI.b#
    ###d#e#f################
    ###A#B#C################
    ###g#h#i################
    ########################
    """
    #assert part1(input) == 81
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
