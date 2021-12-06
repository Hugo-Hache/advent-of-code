""" Solution to Day 06 of Advent of Code 2021 """
import timeit
from pathlib import Path
import numpy as np
from numpy.linalg import matrix_power

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


def parse_distrib(data):
    timers = parse(data)
    return [timers.count(i) for i in range(9)]


# Data analysis
def tick(timers=parse(DATA), remaining_days=80):
    if remaining_days == 0:
        return len(timers)

    updated_timers = []
    new_timers = []
    for timer in timers:
        if timer == 0:
            updated_timers.append(6)
            new_timers.append(8)
        else:
            updated_timers.append(timer - 1)
    return tick(updated_timers + new_timers, remaining_days - 1)


def tick_distrib(distrib=parse_distrib(DATA), remaining_days=256):
    if remaining_days == 0:
        return sum(distrib)

    new_distrib = [distrib[i + 1] for i in range(8)]
    new_distrib[6] += distrib[0]
    new_distrib.append(distrib[0])
    return tick_distrib(new_distrib, remaining_days - 1)


DISTRIB_TICK_MATRIX = np.array(
    [
        [0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 0, 0],
        [1, 0, 0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0],
    ]
)


def tick_distrib_with_math(distrib=parse_distrib(DATA)):
    return sum(matrix_power(DISTRIB_TICK_MATRIX, 256) @ distrib)


# Tests
test_input = "3,4,3,1,2"

assert_eq(5934, tick(parse(test_input)))
assert_eq(26984457539, tick_distrib_with_math(parse_distrib(test_input)))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = tick()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = tick_distrib_with_math()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
