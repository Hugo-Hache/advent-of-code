class Memory
  def initialize(block_counts)
    @block_counts = block_counts
    @size = @block_counts.length
  end

  def redistribute
    i = max_block_index
    remaining_blocks = @block_counts[i]
    @block_counts[i] = 0
    while remaining_blocks.positive?
      i = (i + 1) % @size
      @block_counts[i] += 1
      remaining_blocks -= 1
    end
  end

  def max_block_index
    @block_counts.each_with_index.max_by { |a| a[0] }[1]
  end

  def state
    @block_counts.dup
  end
end

class StateTree
  attr_reader :insertion_count

  def initialize
    @tree = {}
    @insertion_count = 0
  end

  def insert(state)
    @insertion_count += 1

    node = @tree
    state[0..-2].each do |count|
      node[count] = {} unless node.key?(count)
      node = node[count]
    end

    return if node[state[-1]]
    node[state[-1]] = @insertion_count
  end
end

def part_1(input)
  memory = Memory.new(input.split.map(&:to_i))
  tree = StateTree.new
  memory.redistribute while tree.insert(memory.state)
  tree.insertion_count - 1
end

def old_part_1(input)
  memory = Memory.new(input.split.map(&:to_i))
  states = []
  until states.include?(memory.state)
    states << memory.state
    memory.redistribute
  end
  states.length
end

def part_2(input)
  memory = Memory.new(input.split.map(&:to_i))
  states = []
  until states.include?(memory.state)
    states << memory.state
    memory.redistribute
  end
  states.length - states.index(memory.state)
end

# TODO: Use Statetree in part 2 (return node value instead of nil for collision)
