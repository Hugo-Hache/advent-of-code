require 'test/unit'

class Test1 < Test::Unit::TestCase
  def test_part_1_basic
    assert_equal 3, part_1(%(+1
+1
+1))
  end

  def test_part_1_basic_again
    assert_equal 0, part_1(%(+1
+1
-2))
  end

  def test_part_2_two
    assert_equal 2, part_2(%(+1
-2
+3
+1))
  end

  def test_part_2_zero
    assert_equal 0, part_1(%(+1
-1))
  end
end
