require 'byebug'

class CPU
  OPERATIONS = [
    :addr, :addi,
    :mulr, :muli,
    :banr, :bani,
    :borr, :bori,
    :setr, :seti,
    :gtir, :gtri, :gtrr,
    :eqir, :eqri, :eqrr
  ]

  attr_reader :registers

  def initialize(registers = [0, 0, 0, 0])
    @registers = registers
  end

  def execute(operation, first_input, second_input, output)
    send(operation, first_input, second_input, output)
  end

  def addr(first_input, second_input, output)
    @registers[output] = @registers[first_input] + @registers[second_input]
  end

  def addi(first_input, second_input, output)
    @registers[output] = @registers[first_input] + second_input
  end

  def mulr(first_input, second_input, output)
    @registers[output] = @registers[first_input] * @registers[second_input]
  end

  def muli(first_input, second_input, output)
    @registers[output] = @registers[first_input] * second_input
  end

  def banr(first_input, second_input, output)
    @registers[output] = @registers[first_input] & @registers[second_input]
  end

  def bani(first_input, second_input, output)
    @registers[output] = @registers[first_input] & second_input
  end

  def borr(first_input, second_input, output)
    @registers[output] = @registers[first_input] | @registers[second_input]
  end

  def bori(first_input, second_input, output)
    @registers[output] = @registers[first_input] | second_input
  end

  def setr(first_input, _second_input, output)
    @registers[output] = @registers[first_input]
  end

  def seti(first_input, _second_input, output)
    @registers[output] = first_input
  end

  def gtir(first_input, second_input, output)
    @registers[output] = first_input > @registers[second_input] ? 1 : 0
  end

  def gtri(first_input, second_input, output)
    @registers[output] = @registers[first_input] > second_input ? 1 : 0
  end

  def gtrr(first_input, second_input, output)
    @registers[output] = @registers[first_input] > @registers[second_input] ? 1 : 0
  end

  def eqir(first_input, second_input, output)
    @registers[output] = first_input == @registers[second_input] ? 1 : 0
  end

  def eqri(first_input, second_input, output)
    @registers[output] = @registers[first_input] == second_input ? 1 : 0
  end

  def eqrr(first_input, second_input, output)
    @registers[output] = @registers[first_input] == @registers[second_input] ? 1 : 0
  end
end

class Sample
  def initialize(before, instruction, after)
    @before = /(\d+), (\d+), (\d+), (\d+)/.match(before)[1..4].map(&:to_i)
    @instruction = instruction.split.map(&:to_i)
    @after = /(\d+), (\d+), (\d+), (\d+)/.match(after)[1..4].map(&:to_i)
  end

  def possible_operations
    CPU::OPERATIONS.select do |op|
      cpu = CPU.new(@before.dup)
      cpu.execute(op, *@instruction[1..3])
      cpu.registers == @after
    end
  end

  def opcode
    @instruction[0]
  end
end

def part_1(input)
  samples = input.split("\n\n\n\n")[0].split("\n").each_slice(4).map do |before, instruction, after, _|
    Sample.new(before, instruction, after)
  end

  samples.select { |s| s.possible_operations.length >= 3 }.length
end

def part_2(input)
  input_samples, input_instructions = input.split("\n\n\n\n")
  samples = input_samples.split("\n").each_slice(4).map do |before, instruction, after, _|
    Sample.new(before, instruction, after)
  end

  operations_for_opcode = {}
  samples.map do |s|
    operations_for_opcode[s.opcode] ||= s.possible_operations
    operations_for_opcode[s.opcode] &= s.possible_operations
  end

  operation_for_opcode = {}
  while operations_for_opcode.any?
    operations_for_opcode = operations_for_opcode.map do |opcode, operations|
      ops = operations - operation_for_opcode.values
      operation_for_opcode[opcode] = ops.first if ops.length == 1
      [opcode, ops] if ops.length > 1
    end.compact.to_h
  end

  cpu = CPU.new
  input_instructions.split("\n").each do |instruction|
    opcode, first_input, second_input, output = instruction.split.map(&:to_i)
    operation = operation_for_opcode[opcode]
    cpu.execute(operation, first_input, second_input, output)
  end
  cpu.registers[0]
end
