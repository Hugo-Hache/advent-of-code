require 'test/unit'

class Test4 < Test::Unit::TestCase
  def test_part_1
    assert_equal 2, part_1('aa bb cc dd ee
aa bb cc dd aa
aa bb cc dd aaa')
  end

  def test_part_2
    assert_equal 3, part_2('abcde fghij
abcde xyz ecdab
a ab abc abd abf abj
iiii oiii ooii oooi oooo
oiii ioii iioi iiio')
  end

end
