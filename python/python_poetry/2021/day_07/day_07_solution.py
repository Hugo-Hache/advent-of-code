""" Solution to Day 07 of Advent of Code 2021 """
import timeit
from pathlib import Path

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read()


# Data parsing functions
def parse(data):
    return list(map(int, data.split(",")))


# Data analysis
def cost(position, target, inc_cost):
    distance = abs(position - target)
    return distance * (distance + 1) / 2 if inc_cost else distance


def min_fuel(positions=parse(DATA), inc_cost=False):
    return min(
        [
            sum([cost(p, i, inc_cost) for p in positions])
            for i in range(min(positions), max(positions))
        ]
    )


# Tests
test_input = "16,1,2,0,4,2,7,1,2,14"

assert_eq(37, min_fuel(parse(test_input)))
assert_eq(168, min_fuel(parse(test_input), True))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = min_fuel()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = min_fuel(inc_cost=True)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
