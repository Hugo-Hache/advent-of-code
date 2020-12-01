require 'test/unit'

class Test7 < Test::Unit::TestCase
  def test_part_1
    assert_equal 'CABDFE', part_1('Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.')
  end

  def test_part_2
    assert_equal 15, part_2('Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.', 2, 0)
  end
end
