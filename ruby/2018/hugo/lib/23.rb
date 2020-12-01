class Nanobot
  attr_accessor :radius, :x, :y, :z, :point
  def initialize(row)
    x, y, z, r = /pos=<(.+),(.+),(.+)>, r=(\d+)/.match(row)[1..4].map(&:to_i)
    @x = x
    @y = y
    @z = z
    @radius = r
    @point = [@x, @y, @z]
  end

  def in_range?(point)
    ((@x - point[0]).abs + (@y - point[1]).abs + (@z - point[2]).abs) <= @radius
  end
end

def part_1(input)
  strongest_nanobot = nil
  nanobots = input.split("\n").map do |row|
    Nanobot.new(row).tap do |n|
      next if strongest_nanobot && strongest_nanobot.radius >= n.radius

      strongest_nanobot = n
    end
  end

  nanobots.count { |n| strongest_nanobot.in_range?(n.point) }
end

class Box
  attr_reader :min_point, :max_point

  def initialize(min_point, max_point)
    @min_point = min_point
    @max_point = max_point
  end

  def distance
    (0..2).sum { |dimension| (@max_point[dimension] + @min_point[dimension]).abs / 2 }
  end

  def size
    (0..2).sum { |dimension| @max_point[dimension] - @min_point[dimension] }
  end

  def split(dimension)
    return [self] if @max_point[dimension] == @min_point[dimension]

    half = (@max_point[dimension] + @min_point[dimension]) / 2.0
    new_min_point = @min_point.dup
    new_min_point[dimension] = half.ceil
    new_max_point = @max_point.dup
    new_max_point[dimension] = half.floor
    [Box.new(new_min_point, @max_point), Box.new(@min_point, new_max_point)]
  end

  def intersect?(nanobot)
    (0..2).sum do |dimension|
      v = nanobot.point[dimension]
      next v - @max_point[dimension] if v > @max_point[dimension]
      next @min_point[dimension] - v if v < @min_point[dimension]

      0
    end <= nanobot.radius
  end
end

def part_2(input)
  nanobots = input.split("\n").map { |row| Nanobot.new(row) }
  min_x, max_x = nanobots.map(&:x).minmax
  min_y, max_y = nanobots.map(&:y).minmax
  min_z, max_z = nanobots.map(&:z).minmax

  box = Box.new([min_x, min_y, min_z], [max_x, max_y, max_z])

  dimension = 0
  while box.size.positive?
    box = box.split(dimension).sort_by(&:distance).max_by do |b|
      nanobots.count { |n| b.intersect?(n) }
    end
    dimension = (dimension + 1) % 3
  end

  box.min_point.map(&:abs).sum
end
