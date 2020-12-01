require 'test/unit'

class Test17 < Test::Unit::TestCase
  def test_part_1
    assert_equal 57, part_1('x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504')

    assert_equal 73, part_1('x=495, y=3..10
x=505, y=2..10
x=496..504, y=10
x=499..501, y=5
x=499..501, y=7
x=499, y=6
x=501, y=6')

    assert_equal 26, part_1('x=500, y=3..7
x=502, y=3..7
x=496..504, y=7
x=496, y=5..7
x=496, y=6..7')

    assert_equal 81, part_1('x=495, y=2..10
x=505, y=2..10
x=496..504, y=10
x=498, y=4..6
x=502, y=4..6
x=499..501, y=6')

    assert_equal 17, part_1('x=500, y=3..5
x=505, y=2..5
x=501..504, y=5')
  end

  def test_part_2
    assert_equal 29, part_2('x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504')
  end
end
