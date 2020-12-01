require 'byebug'

class Forest
  attr_reader :minutes

  def initialize(input)
    @minutes = 0
    @cells = {}
    @size = input.split("\n").length
    input.split("\n").each.with_index do |row, y|
      row.split('').each.with_index { |char, x| @cells[[x, y]] = char }
    end
  end

  def score
    @cells.values.count { |state| state == '#' } * @cells.values.count { |state| state == '|' }
  end

  def tick
    @cells = @cells.map do |coords, state|
      [coords, new_state(coords, state)]
    end.to_h
    @minutes += 1
  end

  def new_state(coords, state)
    adjacents = adjacents(coords)
    case state
    when '.'
      adjacents.count { |a| a == '|' } >= 3 ? '|' : '.'
    when '|'
      adjacents.count { |a| a == '#' } >= 3 ? '#' : '|'
    when '#'
      adjacents.include?('#') && adjacents.include?('|') ? '#' : '.'
    end
  end

  def adjacents(coords)
    (-1..1).flat_map do |delta_x|
      (-1..1).map do |delta_y|
        next if delta_x.zero? && delta_y.zero?

        @cells[[coords[0] + delta_x, coords[1] + delta_y]]
      end.compact
    end
  end

  def draw
    puts "After #{@minutes} minutes:"
    (0..(@size - 1)).each do |y|
      (0..(@size - 1)).each do |x|
        print(@cells[[x, y]])
      end
      print "\n"
    end
  end
end

def part_1(input)
  forest = Forest.new(input)
  10.times do
    forest.tick
  end
  forest.score
end

def part_2(input)
  forest = Forest.new(input)
  minutes_for_score = { forest.score => 0 }
  score_sequence = []
  loop do
    forest.tick
    score = forest.score
    if minutes_for_score[score]
      if score_sequence.length > 2 && score_sequence.first == score
        sequence_index = (1000000000 - forest.minutes) % score_sequence.length
        return score_sequence[sequence_index]
      end

      score_sequence << score
    elsif score_sequence.any?
      score_sequence = []
    end
    minutes_for_score[score] = forest.minutes
  end
end
