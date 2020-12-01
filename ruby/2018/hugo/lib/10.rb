class Point
  attr_reader :px, :py

  def initialize(px, py, vx, vy)
    @px = px
    @py = py
    @vx = vx
    @vy = vy
  end

  def after(seconds)
    [@px + seconds * @vx, @py + seconds * @vy]
  end
end

def area(coords)
  min_x, max_x = coords.map { |x, _| x }.minmax
  min_y, max_y = coords.map { |_, y| y }.minmax
  (1 + max_x - min_x) * (1 + max_y - min_y)
end

def draw(coords)
  min_x, max_x = coords.map { |x, _| x }.minmax
  min_y, max_y = coords.map { |_, y| y }.minmax
  (min_y..max_y).each do |y|
    (min_x..max_x).map do |x|
      print(coords.include?([x, y]) ? '#' : '.')
    end
    print "\n"
  end
end

def part_1(input, seconds_plz = false)
  points = input.split("\n").map do |row|
    data = /position=<(.+), (.+)> velocity=<(.+), (.+)>/.match(row)
    Point.new(*data[1..4].map(&:to_i))
  end

  seconds = 0
  previous_area = area(points.map { |p| [p.px, p.py] })
  loop do
    seconds += 1
    coords = points.map { |p| p.after(seconds) }
    area = area(coords)
    if previous_area < area
      draw(points.map { |p| p.after(seconds - 1) }) unless seconds_plz
      return seconds_plz ? (seconds - 1) : previous_area
    end
    previous_area = area
  end
end

def part_2(input)
  part_1(input, true)
end
