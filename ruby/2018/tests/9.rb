require 'test/unit'

class Test9 < Test::Unit::TestCase
  def test_part_1
    {
      '9 players; last marble is worth 25 points' => 32,
      '10 players; last marble is worth 1618 points' => 8317,
      '13 players; last marble is worth 7999 points' => 146373,
      '17 players; last marble is worth 1104 points' => 2764,
      '21 players; last marble is worth 6111 points' => 54718,
      '30 players; last marble is worth 5807 points' => 37305
    }.each do |input, score|
      assert_equal score, part_1(input)
    end
  end

  def test_part_2
    assert_equal 22563, part_2('9 players; last marble is worth 25 points')
  end
end
