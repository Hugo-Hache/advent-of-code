require 'test/unit'

class Test15 < Test::Unit::TestCase
  def test_part_1
    assert_equal 27730, part_1('#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######')
    assert_equal 36334, part_1('#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######')
    assert_equal 39514, part_1('#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######')
  end

  def test_part_2
    assert_equal 4988, part_2('#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######')
    assert_equal 31284, part_2('#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######')
  end
end
