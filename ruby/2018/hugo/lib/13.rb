class Cart
  attr_accessor :position, :direction

  def initialize(position, direction)
    @position = position
    @direction = direction
    @next_decisions = [:left, :straight, :right]
    @changes = { 'v' => [0, 1], '<' => [-1, 0], '^' => [0, -1], '>' => [1, 0] }
  end

  def next_decision
    next_decision = @next_decisions[0]
    @next_decisions = @next_decisions.rotate
    next_decision
  end

  def move
    change = @changes[@direction]
    @position = [@position[0] + change[0], @position[1] + change[1]]
  end

  def update_direction(track)
    @direction = new_direction(track)
  end

  def new_direction(track)
    case track
    when '+'
      case next_decision
      when :left
        @changes.keys[(@changes.keys.index(@direction) - 1) % 4]
      when :straight
        @direction
      when :right
        @changes.keys[(@changes.keys.index(@direction) + 1) % 4]
      end
    when '/'
      case @direction
      when '^'
        '>'
      when '>'
        '^'
      when 'v'
        '<'
      when '<'
        'v'
      end
    when '\\'
      case @direction
      when '^'
        '<'
      when '>'
        'v'
      when 'v'
        '>'
      when '<'
        '^'
      end
    else
      @direction
    end
  end
end

class World
  attr_accessor :carts

  def initialize(input)
    @tracks = {}
    @carts = []
    input.split("\n").each.with_index do |row, j|
      row.split('').each.with_index do |char, i|
        next if char == ' '

        if %w[v < > ^].include? char
          @carts << Cart.new([i, j], char)
          @tracks[[i, j]] = %w[< >].include?(char) ? '-' : '|'
        else
          @tracks[[i, j]] = char
        end
      end
    end
    @width = @tracks.keys.map { |i, _| i }.max
    @height = @tracks.keys.map { |_, j| j }.max
  end

  def animate
    collisioning_carts = []
    @carts.sort_by { |c| [c.position[1], c.position[0]] }.each do |cart|
      next if collisioning_carts.include? cart

      cart.move
      collisioning_cart = @carts.find { |c| c != cart && c.position == cart.position }
      if collisioning_cart
        collisioning_carts << cart
        collisioning_carts << collisioning_cart
      else
        cart.update_direction(@tracks[cart.position])
      end
    end
    @carts -= collisioning_carts

    collisioning_carts.first&.position
  end

  def draw(iteration)
    (0..@height).each do |j|
      (0..@width).each do |i|
        cart = @carts.find { |c| c.position == [i, j] }
        print cart&.direction || @tracks[[i, j]] || ' '
      end
      print "\n"
    end
  end
end

def part_1(input)
  world = World.new(input)
  iteration = 0
  loop do
    # world.draw(iteration)
    collision = world.animate
    return collision.join(',') if collision

    iteration += 1
  end
end

def part_2(input)
  world = World.new(input)
  iteration = 0
  loop do
    # world.draw(iteration)
    world.animate
    return world.carts.first.position.join(',') if world.carts.length == 1

    iteration += 1
  end
end
