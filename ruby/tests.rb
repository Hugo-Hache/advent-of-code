gem 'test-unit'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require_relative 'helper'
require 'benchmark'

def run_all_tests(year, day)
  results = []
  Dir.foreach(year).each do |folder|
    next if %w[tests . ..].include?(folder)
    results.concat(run_tests_for_user(folder, year, day))
  end
  results
end

def load_test_files(year)
  Dir["#{year}/tests/**/*.rb"].each do |test_file|
    require_relative test_file
  end
end

def verify_with_resource_for_day(day, folder, year)
  puts "Part 1 result for input from #{folder} is #{part_1(read_resource("#{year}/#{folder}/resources/#{day}.txt"))}"
  puts "Part 2 result for input from from #{folder} is #{part_2(read_resource("#{year}/#{folder}/resources/#{day}.txt"))}"
end

def run_tests_for_user(user, year, day)
  return Array(run_test_for_day(day, user, year)) if day
  (1..24).map { |d| run_test_for_day(d, user, year) }
end

def run_test_for_day(day, user, year)
  Benchmark.measure("#{user}_#{day}_#{year}") do
    file = Dir["#{year}/#{user}/**/#{day}.rb"].first
    return unless file
    load(file)
    class_test = Object.const_get("Test#{day}")
    tests_suite = Test::Unit::TestSuite.new("########### TESTING SOLUTION OF DAY #{day} FROM #{user.upcase} ###########\n")
    tests_suite << class_test.suite()
    result = Test::Unit::UI::Console::TestRunner.run(tests_suite)
    return if result.failure_occurred?
    verify_with_resource_for_day(day, user, year)
    puts "\n"
  end
end


def run_script
  year = '2017'
  user = nil
  day = nil
  ARGV.each_with_index do |arg, index|
    case arg
    when '-y'
      year = ARGV[index + 1]
    when '-u'
      user = ARGV[index + 1]
    when '-d'
      day = ARGV[index + 1]
    end
  end

  load_test_files(year)
  results = user ? run_tests_for_user(user, year, day) : run_all_tests(year, day)
  puts "\n########## FINAL RESULTS ##########"
  Benchmark.bm(20) do
    results
  end
end

run_script



