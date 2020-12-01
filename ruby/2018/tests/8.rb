require 'test/unit'

class Test8 < Test::Unit::TestCase
  def test_part_1
    assert_equal 138, part_1('2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2')
  end

  def test_part_2
    assert_equal 66, part_2('2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2')
  end
end
