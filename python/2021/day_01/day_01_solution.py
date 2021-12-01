""" Solution to Day 01 of Advent of Code 2021 """
import timeit
from pathlib import Path
from itertools import pairwise

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()

# Data parsing functions
DEPTHS = list(map(int, DATA))

# Data analysis
def increasing(depths=DEPTHS):
    return len([previous for previous, next in pairwise(depths) if next > previous])


def triplewise(iterable):
    for (a, _), (b, c) in pairwise(pairwise(iterable)):
        yield a, b, c


def three_window(depths=DEPTHS):
    return [sum(triplet) for triplet in triplewise(depths)]


# Tests
assert increasing([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 7
assert increasing(three_window([199, 200, 208, 210, 200, 207, 240, 269, 260, 263])) == 5

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = increasing()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = increasing(three_window())
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
