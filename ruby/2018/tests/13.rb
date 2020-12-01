require 'test/unit'

class Test13 < Test::Unit::TestCase
  def test_part_1
    assert_equal '7,3', part_1('/->-\        
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/   ')
  end

  def test_part_2
    assert_equal '6,4', part_2('/>-<\  
|   |  
| /<+-\
| | | v
\>+</ |
  |   ^
  \<->/')
  end
end
