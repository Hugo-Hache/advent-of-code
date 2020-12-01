class Group
  attr_reader :index, :unit_count, :initiative, :weaknesses, :immunities

  def initialize(input, index)
    @index = index
    _, unit_count, hp, features, attack, attack_type, initiative = /(\d+) units each with (\d+) hit points (?:\((.*)\) )?with an attack that does (\d+) (\w+) damage at initiative (\d+)/.match(input).to_a

    @unit_count = unit_count.to_i
    @hp = hp.to_i
    @attack = attack.to_i
    @attack_type = attack_type
    @initiative = initiative.to_i

    @weaknesses = @immunities = []
    features&.split('; ')&.each do |s|
      _, kind, items = /(.*) to (.*)/.match(s).to_a
      case kind
      when 'weak'
        @weaknesses = items.split(', ')
      when 'immune'
        @immunities = items.split(', ')
      end
    end
  end

  def boost(boost)
    @attack += boost
  end

  def power
    @unit_count * @attack
  end

  def target(enemies)
    enemies.select { |g| damage_to(g).positive? }.max_by do |g|
      [damage_to(g), g.power, g.initiative]
    end
  end

  def damage_to(enemy)
    return 0 if enemy.immunities.include?(@attack_type)

    enemy.weaknesses.include?(@attack_type) ? 2 * power : power
  end

  def attack(enemy)
    enemy.deal_with(damage_to(enemy))
  end

  def deal_with(damage)
    (damage / @hp).tap do |unit_lost|
      @unit_count = [@unit_count - unit_lost, 0].max
    end
  end
end

class Body
  attr_reader :immune_groups

  def initialize(input, immune_boost)
    @immune_groups, @infection_groups = input.split("\n\n").map do |system_input|
      system_input.split("\n")[1..-1].map.with_index { |group_input, i| Group.new(group_input, i) }
    end
    @immune_groups.each { |g| g.boost(immune_boost) } if immune_boost
  end

  def fight
    attack(targets(@immune_groups, @infection_groups) + targets(@infection_groups, @immune_groups))

    @immune_groups.delete_if { |g| g.unit_count.zero? }
    @infection_groups.delete_if { |g| g.unit_count.zero? }
  end

  def fighting?
    !@draw && @immune_groups.any? && @infection_groups.any?
  end

  def winning_groups
    return nil if @draw

    @immune_groups.any? ? @immune_groups : @infection_groups
  end

  def targets(attackers, defenders)
    defenders = defenders.dup
    attackers.sort_by { |g| [-g.power, -g.initiative] }.map do |g|
      next if defenders.empty?

      target = g.target(defenders)
      next unless target

      [g, defenders.delete(target)]
    end.compact
  end

  def attack(targets)
    @draw = targets.sort_by { |a, _| -a.initiative }.sum do |attacker, defender|
      attacker.attack(defender)
    end.zero?
  end
end

def part_1(input, immune_boost = nil)
  body = Body.new(input, immune_boost)
  body.fight while body.fighting?
  return 0 if body.winning_groups.nil?

  immune_boost ? body.immune_groups.sum(&:unit_count) : body.winning_groups.sum(&:unit_count)
end

def slow_start(param = 0)
  pow = 0
  loop do
    if yield(param + 2**pow)
      return param + 1 if pow.zero?

      param += 2**(pow - 1)
      pow = 0
    else
      pow += 1
    end
  end
end

def part_2(input)
  smallest_immune_boost = slow_start do |immune_boost|
    immune_unit_count = part_1(input, immune_boost)
    immune_unit_count.positive?
  end
  part_1(input, smallest_immune_boost)
end
