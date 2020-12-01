require 'test/unit'

class Test14 < Test::Unit::TestCase
  def test_part_1
    assert_equal '5158916779', part_1('9')
    assert_equal '0124515891', part_1('5')
    assert_equal '9251071085', part_1('18')
    assert_equal '5941429882', part_1('2018')
  end

  def test_part_2
    assert_equal 9, part_2('51589')
    assert_equal 5, part_2('01245')
    assert_equal 18, part_2('92510')
    assert_equal 2018, part_2('59414')
  end
end
