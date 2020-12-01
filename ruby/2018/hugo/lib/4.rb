require 'date'

class Record
  attr_accessor :date_time

  def initialize(input)
    timestamp, @action = input.split('] ')
    @date_time = DateTime.parse(timestamp[1..-1])
  end

  def id
    @action.split[1]
  end

  def sleep?
    @action.include? 'asleep'
  end

  def wake?
    @action.include? 'wakes'
  end

  def begin?
    @action.include? 'begins'
  end
end

class Shift
  attr_accessor :guard_id, :sleep_minutes

  def initialize(id)
    @guard_id = id
    @records = []
    @sleep_minutes = []
  end

  def update(record)
    @records << record

    if record.sleep?
      @sleep_starts_at = record.date_time.minute
    elsif record.wake?
      @sleep_minutes += (@sleep_starts_at..(record.date_time.minute - 1)).to_a
    end
  end
end

def shifts_for_id(sorted_records)
  shift = nil
  sorted_records.each_with_object({}) do |record, shifts_for_id|
    if record.begin?
      shift = Shift.new(record.id)
      shifts_for_id[record.id] ||= []
      shifts_for_id[record.id] << shift
    end
    shift.update(record)
  end
end

def repetition_for_minute(shifts)
  shifts.map(&:sleep_minutes).each_with_object(Hash.new { 0 }) do |sleep_minutes, repetition_for_minute|
    sleep_minutes.each { |minute| repetition_for_minute[minute] += 1 }
  end
end

def part_1(input)
  records = input.split("\n").map { |i| Record.new(i) }
  sorted_records = records.sort_by(&:date_time)

  sleeper_id, sleeper_shifts = shifts_for_id(sorted_records).max_by { |_, shifts| shifts.map(&:sleep_minutes).sum(&:length) }
  sleepy_minute, = repetition_for_minute(sleeper_shifts).max_by { |_, r| r }

  sleeper_id[1..-1].to_i * sleepy_minute
end

def part_2(input)
  records = input.split("\n").map { |i| Record.new(i) }
  sorted_records = records.sort_by(&:date_time)

  max_repetition = 0
  max_sleepy_minute = nil
  max_sleeper_id = nil

  shifts_for_id(sorted_records).each do |id, shifts|
    sleepy_minute, repetition = repetition_for_minute(shifts).max_by { |_, r| r }
    next unless repetition && repetition > max_repetition

    max_repetition = repetition
    max_sleeper_id = id
    max_sleepy_minute = sleepy_minute
  end

  max_sleeper_id[1..-1].to_i * max_sleepy_minute
end
