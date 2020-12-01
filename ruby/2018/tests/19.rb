require 'test/unit'

class Test19 < Test::Unit::TestCase
  def test_part_1
    assert_equal 7, part_1('#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5')
  end

  def test_part_2
  end
end
