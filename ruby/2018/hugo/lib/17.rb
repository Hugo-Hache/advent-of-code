class Underworld
  def initialize(input)
    @tiles = {}
    input.split("\n").each do |row|
      min_x, max_x = /x=(\d+)(?:\.\.(\d+))?/.match(row)[1..2].compact.map(&:to_i)
      min_y, max_y = /y=(\d+)(?:\.\.(\d+))?/.match(row)[1..2].compact.map(&:to_i)
      max_x ||= min_x
      max_y ||= min_y

      @clay_min_y = min_y if @clay_min_y.nil? || min_y < @clay_min_y
      @clay_max_y = max_y if @clay_max_y.nil? || max_y > @clay_max_y
      (min_x..max_x).each { |x| (min_y..max_y).each { |y| @tiles[[x, y]] = '#' } }
    end
  end

  def let_if_flow(x, y)
    @tiles[[x, y]] = '+'
    drill_spring(x, y + 1)
  end

  def drill_spring(x_source, y_source)
    y = y_source
    while @tiles[[x_source, y]].nil?
      return if y > @clay_max_y

      @tiles[[x_source, y]] = '|'
      y += 1
    end

    flood(x_source, y - 1) if @tiles[[x_source, y]] != '|'
  end

  def flood(x_spring, y)
    return if @tiles[[x_spring, y]] != '|'

    new_springs = []
    flooded_tiles = [[x_spring, y]]
    existing_spring = false

    x = x_spring - 1
    while (@tiles[[x, y]].nil? || @tiles[[x, y]] == '|') && ['#', '~'].include?(@tiles[[x, y + 1]])
      flooded_tiles << [x, y]
      x -= 1
    end
    new_springs << [x, y] unless @tiles[[x, y]]
    existing_spring ||= @tiles[[x, y + 1]] == '|'

    x = x_spring + 1
    while (@tiles[[x, y]].nil? || @tiles[[x, y]] == '|') && ['#', '~'].include?(@tiles[[x, y + 1]])
      flooded_tiles << [x, y]
      x += 1
    end
    new_springs << [x, y] unless @tiles[[x, y]]
    existing_spring ||= @tiles[[x, y + 1]] == '|'

    water_flows = new_springs.any? || existing_spring
    flooded_tiles.each { |tile| @tiles[tile] = water_flows ? '|' : '~' }

    if water_flows
      new_springs.each { |i, j| drill_spring(i, j) }
      flood(x_spring, y - 1) if @tiles[[x_spring, y]] == '~'
    else
      flood(x_spring, y - 1)
    end
  end

  def draw
    min_x, max_x = @tiles.keys.map { |x, _| x }.minmax
    min_y, max_y = @tiles.keys.map { |_, y| y }.minmax
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        print(@tiles[[x, y]] || '.')
      end
      print " #{y}\n"
    end
  end

  def watered_tiles_count
    watered = ['~', '|']
    @tiles.count { |(_, y), tile| y >= @clay_min_y && watered.include?(tile) }
  end

  def steady_water_tiles_count
    @tiles.count { |(_, y), tile| y >= @clay_min_y && tile == '~' }
  end
end

def part_1(input)
  underworld = Underworld.new(input)
  underworld.let_if_flow(500, 0)
  underworld.watered_tiles_count
end

def part_2(input)
  underworld = Underworld.new(input)
  underworld.let_if_flow(500, 0)
  underworld.steady_water_tiles_count
end
