require 'test/unit'

class Test5 < Test::Unit::TestCase
  def test_part_1
    assert_equal 5, part_1('0
3
0
1
-3')
  end

  def test_part_2
    assert_equal 10, part_2('0
3
0
1
-3')
  end

end
