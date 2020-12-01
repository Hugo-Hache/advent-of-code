require 'test/unit'

class Test2 < Test::Unit::TestCase
  def test_part_1
    assert_equal 12, part_1(%(abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab))
  end

  def test_part_2
    assert_equal 'fgij', part_2(%(abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz))
  end
end
