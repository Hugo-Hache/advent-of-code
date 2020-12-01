require 'test/unit'

class Test6 < Test::Unit::TestCase
  def test_part_1
    assert_equal 17, part_1('1, 1
1, 6
8, 3
3, 4
5, 5
8, 9')
  end

  # Aacc
  # acCc
  # --D-
  # eE-B
  def test_part_1_non_border_infinite
    assert_equal 1, part_1('0, 0
3, 3
2, 1
2, 2
1, 3')
  end

  def test_part_2
    assert_equal 16, part_2('1, 1
1, 6
8, 3
3, 4
5, 5
8, 9', 32)
  end
end
