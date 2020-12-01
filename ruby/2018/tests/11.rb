require 'test/unit'

class Test11 < Test::Unit::TestCase
  def test_part_1
    assert_equal 4, power_level(3, 5, 8)
    assert_equal -5, power_level(122, 79, 57)
    assert_equal 0, power_level(217, 196, 39)
    assert_equal 4, power_level(101, 153, 71)

    assert_equal [33, 45], part_1(18)
  end

  def test_part_2
    assert_equal [[1, 3, 6], [5, 12, 21], [12, 27, 45]], summed_area([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    assert_equal [90, 269, 16], part_2(18)
    assert_equal [232, 251, 12], part_2(42)
  end
end
