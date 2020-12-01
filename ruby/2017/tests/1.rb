require 'test/unit'

class Test1 < Test::Unit::TestCase
  def test_simple_basic
    assert_equal 3, part_1('1122')
  end

  def test_simple_repeat
    assert_equal 4, part_1('1111')
  end

  def test_simple_none
    assert_equal 0, part_1('1234')
  end

  def test_simple_cycle
    assert_equal 9, part_1('91212129')
  end

  def test_hard_basic
    assert_equal 6, part_2('1212')
  end

  def test_hard_none
    assert_equal 0, part_2('1221')
  end

  def test_hard_single
    assert_equal 4, part_2('123425')
  end

  def test_hard_repeat
    assert_equal 12, part_2('123123')
  end

  def test_hard_complex
    assert_equal 4, part_2('12131415')
  end
end
