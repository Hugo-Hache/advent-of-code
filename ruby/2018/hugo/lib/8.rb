require 'byebug'

class Node
  attr_accessor :end_index, :metadata_sum

  def initialize(numbers, start_index)
    @start_index = start_index
    @child_nodes = []

    child_count = numbers[start_index]
    metadata_count = numbers[start_index + 1]

    i = start_index + 2
    child_count.times do
      child_node = Node.new(numbers, i)
      i = child_node.end_index + 1
      @child_nodes << child_node
    end

    @metadatas = metadata_count.positive? ? numbers[i..(i + metadata_count - 1)] : []
    @end_index = i + metadata_count - 1
  end

  def metadata_sum
    @child_nodes.sum(&:metadata_sum) + @metadatas.sum
  end

  def value
    if @child_nodes.any?
      @metadatas.sum do |metadata|
        @child_nodes[metadata - 1]&.value || 0
      end
    else
      metadata_sum
    end
  end
end

def part_1(input)
  numbers = input.split.map(&:to_i)
  root_node = Node.new(numbers, 0)
  root_node.metadata_sum
end

def part_2(input)
  numbers = input.split.map(&:to_i)
  root_node = Node.new(numbers, 0)
  root_node.value
end
