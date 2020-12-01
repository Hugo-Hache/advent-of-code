def part_1(input)
  player_count = input.split[0].to_i
  highest_marble = input.split[6].to_i

  marbles = [0]
  current_index = 0
  player_index = 0
  player_scores = Array.new(player_count, 0)
  (1..highest_marble).each do |marble|
    if (marble % 23).zero?
      player_scores[player_index] += marble
      current_index = (current_index - 7) % marbles.length
      player_scores[player_index] += marbles.delete_at(current_index)
    else
      current_index = ((current_index + 1) % marbles.length) + 1
      marbles.insert(current_index, marble)
    end
    player_index = (player_index + 1) % player_count
  end
  player_scores.max
end

class Marble
  attr_accessor :next, :prev
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def insert_after(marble)
    self.next = marble.next
    self.prev = marble

    marble.next.prev = self
    marble.next = self
  end

  def remove
    tap do
      prev.next = self.next
      self.next.prev = prev
    end
  end

  def prev_at(jumps)
    marble = self
    jumps.times do
      marble = marble.prev
    end
    marble
  end
end

def part_2(input)
  player_count = input.split[0].to_i
  highest_marble = input.split[6].to_i * 100

  marble = Marble.new(0)
  marble.next = marble.prev = marble
  player_scores = Array.new(player_count, 0)
  (1..highest_marble).each do |value|
    next marble = Marble.new(value).insert_after(marble.next) unless (value % 23).zero?

    marble_removed = marble.prev_at(7).remove
    player_scores[value % player_count] += value + marble_removed.value
    marble = marble_removed.next
  end
  player_scores.max
end
