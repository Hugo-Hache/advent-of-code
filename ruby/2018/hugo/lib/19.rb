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

  def initialize(registers = [0, 0, 0, 0, 0, 0])
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

def part_1(input)
  lines = input.split("\n")
  ip = lines.first.split[1].to_i
  instructions = lines[1..-1].map do |instruction|
    operation, first_input, second_input, output = instruction.split
    [operation.to_sym, first_input.to_i, second_input.to_i, output.to_i]
  end

  cpu = CPU.new
  loop do
    instruction_index = cpu.registers[ip]
    return cpu.registers[0] if instruction_index.negative? || instruction_index >= instructions.length

    cpu.execute(*instructions[instruction_index])
    cpu.registers[ip] += 1
  end
end

def part_2(input)
  lines = input.split("\n")
  ip = lines.first.split[1].to_i
  instructions = lines[1..-1].map do |instruction|
    operation, first_input, second_input, output = instruction.split
    [operation.to_sym, first_input.to_i, second_input.to_i, output.to_i]
  end

  cpu = CPU.new([1, 0, 0, 0, 0, 0])
  initialized = false
  loop do
    instruction_index = cpu.registers[ip]
    initialized = true if instruction_index == 1

    # Reverse engineered instructions by looking at executed cycles
    if initialized
      r = cpu.registers
      loop do
        r[1] += 1
        r[0] += r[1] if (r[2] % r[1]).zero?
        return r[0] if r[1] > r[2]
      end
    end

    cpu.execute(*instructions[instruction_index])
    cpu.registers[ip] += 1
  end
end
