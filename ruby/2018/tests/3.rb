require 'test/unit'

class Test3 < Test::Unit::TestCase
  def test_part_1
    assert_equal 4, part_1(%(#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2))
  end

  def test_part_2
    assert_equal '#3', part_2(%(#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2))
  end
end
