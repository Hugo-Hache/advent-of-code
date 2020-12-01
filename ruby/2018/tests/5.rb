require 'test/unit'

class Test5 < Test::Unit::TestCase
  def test_part_1
    assert_equal 10, part_1('dabAcCaCBAcCcaDA')
  end

  def test_part_1_same_case
    assert_equal 6, part_1('aabAAB')
  end

  def test_part_2
    assert_equal 4, part_2('dabAcCaCBAcCcaDA')
  end
end
