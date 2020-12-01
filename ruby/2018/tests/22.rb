require 'test/unit'

class Test22 < Test::Unit::TestCase
  def test_part_1
    assert_equal 114, part_1('depth: 510
target: 10,10')
  end

  def test_part_2
    assert_equal 45, part_2('depth: 510
target: 10,10')
  end
end
