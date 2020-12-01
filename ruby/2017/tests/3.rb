require 'test/unit'

class Test3 < Test::Unit::TestCase
  def test_part_1_simple
    assert_equal 0, part_1(1)
  end

  def test_part_1_with_12
    assert_equal 3, part_1(12)
  end

  def test_part_1_with_23
    assert_equal 2, part_1(23)
  end

  def test_part_1_with_1024
    assert_equal 31, part_1(1024)
  end

  def test_part_2_simple
    assert_equal 2, part_2(1)
  end

  def test_part_2_with_11
    assert_equal 23, part_2(11)
  end
end
