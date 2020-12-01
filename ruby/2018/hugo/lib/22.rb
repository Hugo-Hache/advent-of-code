require 'byebug'

class Region
  TOOLS_FOR_RISK_LEVEL = { 0 => [:torch, :climbing], 1 => [:climbing, :neither], 2 => [:torch, :neither] }
  CHARS_FOR_RISK_LEVEL = { 0 => '.', 1 => '=', 2 => '|' }

  attr_accessor :coords, :geological_index, :erosion_level, :risk_level, :tools, :minutes_for_tools
  def initialize(coords, geological_index, depth)
    @coords = coords
    @geological_index = geological_index
    @erosion_level = (geological_index + depth) % 20183
    @risk_level = erosion_level % 3
    @tools = TOOLS_FOR_RISK_LEVEL[@risk_level]
    @minutes_for_tools = {}
  end

  def to_s
    CHARS_FOR_RISK_LEVEL[@risk_level]
  end

  def update_minutes(adjacent_region)
    adjacent_region.tools.map do |tool|
      new_minutes_options = [@minutes_for_tools.values.min + 8]
      new_minutes_options << (@minutes_for_tools[tool] + 1) if @minutes_for_tools[tool]
      new_minutes = new_minutes_options.min
      current_minutes = adjacent_region.minutes_for_tools[tool]
      next if current_minutes && current_minutes <= new_minutes

      adjacent_region.minutes_for_tools[tool] = new_minutes
    end.any?
  end
end

class Cave
  attr_accessor :regions

  def initialize(depth, target, delta = 0)
    @depth = depth
    @target = target

    @regions = { [0, 0] => Region.new([0, 0], 0, @depth) }
    (0..(target[1] + delta)).each do |j|
      (0..(target[0] + delta)).each do |i|
        if j.zero?
          geological_index = i * 16807
        elsif i.zero?
          geological_index = j * 48271
        elsif [i, j] == @target
          geological_index = 0
        else
          geological_index = @regions[[i - 1, j]].erosion_level * @regions[[i, j - 1]].erosion_level
        end
        @regions[[i, j]] = Region.new([i, j], geological_index, @depth)
      end
    end
  end

  def neighbors(coords)
    [
      [coords[0] - 1, coords[1]],
      [coords[0] + 1, coords[1]],
      [coords[0], coords[1] - 1],
      [coords[0], coords[1] + 1]
    ].select { |i, j| i >= 0 && j >= 0 }
  end

  def rescue_from(coords)
    @regions[coords].minutes_for_tools = { torch: 0, climbing: 7 }
    explore([coords])
  end

  def explore(coords)
    updated_neighbors = coords.flat_map do |c|
      from_region = @regions[c]
      next unless from_region

      neighbors(c).select do |neighbor|
        to_region = @regions[neighbor]
        neighbor if to_region && from_region.update_minutes(to_region)
      end
    end.compact.uniq
    explore(updated_neighbors) if updated_neighbors.any?
  end

  def risk_level
    @regions.values.sum(&:risk_level)
  end
end

def part_1(input)
  depth = input.split[1].to_i
  target = input.split[-1].split(',').map(&:to_i)

  Cave.new(depth, target).risk_level
end

def part_2(input)
  depth = input.split[1].to_i
  target = input.split[-1].split(',').map(&:to_i)

  cave = Cave.new(depth, target, 15)
  cave.rescue_from([0, 0])
  [cave.regions[target].minutes_for_tools[:torch], cave.regions[target].minutes_for_tools[:climbing] + 7].min
end
