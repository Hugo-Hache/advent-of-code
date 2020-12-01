require 'test/unit'

class Test20 < Test::Unit::TestCase
  def test_part_1
    assert_equal 3, part_1('^WNE$')
    assert_equal 10, part_1('^ENWWW(NEEE|SSE(EE|N))$')
    assert_equal 18, part_1('^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$')
    assert_equal 23, part_1('^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$')
    assert_equal 31, part_1('^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$')
  end

  def test_part_2
    assert_equal 2, part_2('^WNE$', 2)
    assert_equal 4, part_2('^ENWWW(NEEE|SSE(EE|N))$', 9)
    assert_equal 1, part_2('^ENWWW(NEEE|SSE(EE|N))$', 10)
    assert_equal 6, part_2('^ENNWSWW(NEWS|)SSSEEN$', 9)
  end
end
