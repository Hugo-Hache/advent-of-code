require 'test/unit'

class Test6 < Test::Unit::TestCase
  def test_part_1
    assert_equal 5, part_1('0 2 7 0')
  end

  def test_part_2
    assert_equal 4, part_2('0 2 7 0')
  end
end
