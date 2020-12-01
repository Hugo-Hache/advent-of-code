require 'test/unit'

class Test2 < Test::Unit::TestCase
  def test_simple_basic
    assert_equal 18, part_1('5 1 9 5
7 5 3
2 4 6 8')
  end

  def test_hard
    assert_equal 9, part_2('5 9 2 8
9 4 7 3
3 8 6 5')
  end

end
