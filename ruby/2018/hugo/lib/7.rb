require 'set'

def required_for_steps(input)
  input.split("\n").each_with_object({}) do |row, h|
    words = row.split
    required_step = words[1]
    blocked_step = words[-3]
    h[required_step] ||= Set.new
    h[blocked_step] ||= Set.new
    h[blocked_step] << required_step
  end.sort.to_h
end

def part_1(input)
  required_for_steps = required_for_steps(input)
  steps_done = Set.new
  while required_for_steps.any?
    step, = required_for_steps.find { |_, required_steps| required_steps.subset? steps_done }
    steps_done << step
    required_for_steps.delete(step)
  end

  steps_done.to_a.join
end

class WorkerPool
  def initialize(worker_count, additional_time)
    @worker_count = worker_count
    @step_cost = ('A'..'Z').map.with_index { |step, i| [step, i + 1 + additional_time] }.to_h
    @in_progress_steps = []
  end

  def available?
    @in_progress_steps.length < @worker_count
  end

  def works?
    @in_progress_steps.any?
  end

  def collect(time)
    ready_steps = @in_progress_steps.select { |_, t| t <= time }
    @in_progress_steps -= ready_steps
    ready_steps.map { |s, _| s }
  end

  def assign(step, current_time)
    @in_progress_steps << [step, current_time + @step_cost[step]]
  end
end

def part_2(input, worker_count = 5, additional_time = 60)
  required_for_steps = required_for_steps(input)

  steps_done = Set.new
  worker_pool = WorkerPool.new(worker_count, additional_time)
  time = 0
  while required_for_steps.any? || worker_pool.works?
    steps_done += worker_pool.collect(time)
    while worker_pool.available?
      step, = required_for_steps.find { |_, required_steps| required_steps.subset? steps_done }
      break unless step
      worker_pool.assign(step, time)
      required_for_steps.delete(step)
    end
    time += 1
  end

  time - 1
end
