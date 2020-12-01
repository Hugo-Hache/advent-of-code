class Player
  attr_accessor :hp, :row, :col

  def initialize(row, col, power = 3)
    @row = row
    @col = col
    @hp = 200
    @power = power
  end

  def alive?
    @hp.positive?
  end

  def move(move_to_closest_enemy)
    return unless move_to_closest_enemy

    self.row += move_to_closest_enemy[0]
    self.col += move_to_closest_enemy[1]
  end

  def attack(close_enemies)
    weakest_close_enemy = close_enemies.min_by(&:hp)
    weakest_close_enemy.hp -= @power if weakest_close_enemy
  end

  def distance_to(player)
    (row - player.row).abs + (col - player.col).abs
  end

  def status
    "#{to_s}(#{hp})"
  end
end

class Elf < Player
  def to_s
    'E'
  end
end

class Goblin < Player
  def to_s
    'G'
  end
end

class ElfJustDied < StandardError
end

class World
  MOVES = [[-1, 0], [0, -1], [0, 1], [1, 0]]

  def initialize(input, elf_power = nil)
    @rounds = 0
    @players = []
    @grid = []
    @elf_must_not_die = elf_power
    @grid = input.split.map.with_index do |row, i|
      row.split('').map.with_index do |char, j|
        case char
        when 'E'
          @players << (elf_power ? Elf.new(i, j, elf_power) : Elf.new(i, j))
          '.'
        when 'G'
          @players << Goblin.new(i, j)
          '.'
        else
          char
        end
      end
    end
  end

  def draw
    puts "After #{@rounds} rounds"
    @grid.each.with_index do |row, i|
      row_players = []
      row.each.with_index do |cell, j|
        player = alive_player_at(i, j)
        row_players << player if player
        print(player || cell)
      end
      print(" #{row_players.map(&:status).join(', ')}")
      print("\n")
    end
  end

  def alive_player_at(row, col)
    @players.find { |p| p.alive? && p.row == row && p.col == col }
  end

  def play
    @players.sort_by { |p| [p.row, p.col] }.each do |player|
      raise ElfJustDied if @elf_must_not_die && !player.alive? && player.is_a?(Elf)
      return false if @players.select(&:alive?).map(&:class).uniq.one?
      next unless player.alive?
      break unless @players.any? { |p| p.alive? && p.class != player.class }

      player.move(move_to_closest_enemy(player))
      player.attack(close_enemies(player))
    end

    @rounds += 1
  end

  def score
    @rounds * @players.select(&:alive?).sum(&:hp)
  end

  def move_to_closest_enemy(player)
    distance_for_cells = { [player.row, player.col] => 0 }
    new_distance_for_cells = { [player.row, player.col] => 0 }
    first_move_for_cell = {}
    loop do
      new_distance_for_cells = new_distance_for_cells.flat_map do |cell, distance|
        MOVES.map do |delta_row, delta_col|
          close_cell = [cell[0] + delta_row, cell[1] + delta_col]
          next if distance_for_cells[close_cell]
          next if @grid[close_cell[0]][close_cell[1]] == '#'

          close_player = alive_player_at(*close_cell)
          return first_move_for_cell[cell] if close_player && !close_player.is_a?(player.class)
          next if close_player

          first_move_for_cell[close_cell] ||= first_move_for_cell[cell] || [delta_row, delta_col]
          [close_cell, distance + 1]
        end.compact
      end.to_h
      return if new_distance_for_cells.empty?

      distance_for_cells.merge!(new_distance_for_cells)
    end
  end

  def close_enemies(player)
    MOVES.map do |delta_row, delta_col|
      close_player = alive_player_at(player.row + delta_row, player.col + delta_col)
      close_player.class != player.class ? close_player : nil
    end.compact
  end

  def draw_close_map(distance_for_cells)
    @grid.each.with_index do |row, i|
      row.each.with_index do |cell, j|
        distance = distance_for_cells[[i, j]]
        print(distance || cell)
      end
      print("\n")
    end
  end
end

def part_1(input)
  world = World.new(input)
  loop do
    return world.score unless world.play
  end
end

def part_2(input)
  elf_power = 3
  loop do
    world = World.new(input, elf_power)
    begin
      loop do
        return world.score unless world.play
      end
    rescue ElfJustDied
      elf_power += 1
    end
  end
end
