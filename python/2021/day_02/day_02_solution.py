""" Solution to Day 02 of Advent of Code 2021 """
import timeit
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()

# Data parsing functions
def parse_command(line):
    return line.split(" ")


COMMANDS = list(map(parse_command, DATA))

# Data analysis
def navigate_without_aim(commands=COMMANDS):
    depth = 0
    horizontal = 0
    for action, units in commands:
        if action == "forward":
            horizontal += int(units)
        if action == "down":
            depth += int(units)
        if action == "up":
            depth -= int(units)
    return depth * horizontal


def navigate_with_aim(commands=COMMANDS):
    depth = 0
    horizontal = 0
    aim = 0
    for action, units in commands:
        if action == "forward":
            horizontal += int(units)
            depth += aim * int(units)
        if action == "down":
            aim += int(units)
        if action == "up":
            aim -= int(units)
    return depth * horizontal


# Tests
test_input = ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"]

assert navigate_without_aim(map(parse_command, test_input)) == 150
assert navigate_with_aim(map(parse_command, test_input)) == 900

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = navigate_without_aim()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = navigate_with_aim()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
