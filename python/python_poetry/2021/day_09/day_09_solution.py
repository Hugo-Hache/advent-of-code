""" Solution to Day 09 of Advent of Code 2021 """
from functools import reduce
import timeit
from pathlib import Path
import numpy as np
from operator import add, mul

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq, flatten

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


# Data parsing functions
def parse(data=DATA):
    return np.array([[int(h) for h in line.strip()] for line in data])


# Data analysis

NEIGHBORS = [(0, 1), (1, 0), (0, -1), (-1, 0)]


def valid_index(heights, index):
    return all(
        [0 <= index[dim] and index[dim] < heights.shape[dim] for dim in range(2)]
    )


def neighbors(heights, index):
    return [
        tuple(map(add, index, d))
        for d in NEIGHBORS
        if valid_index(heights, tuple(map(add, index, d)))
    ]


def low_points(heights):
    low_points = []
    for index, h in np.ndenumerate(heights):
        if all([h < heights[n] for n in neighbors(heights, index)]):
            low_points.append(index)
    return low_points


def risk_sum(heights=parse(DATA)):
    return sum([heights[index] + 1 for index in low_points(heights)])


def sexy(heights, basin_indexes):
    print("GRID")
    bold = lambda s, b: "\033[92m" + s + "\033[0m" if b else s
    for r in range(len(heights)):
        row = heights[r]
        print(
            "".join(
                [
                    bold(str(heights[r, c]), (r, c) in basin_indexes)
                    for c in range(len(row))
                ]
            )
        )


def explore_basin(heights, basin_indexes):
    new_basin_indexes = []
    not_in_new_basin = lambda i: i not in basin_indexes and i not in new_basin_indexes
    for basin_index in basin_indexes:
        new_basin_indexes += [
            n
            for n in filter(not_in_new_basin, neighbors(heights, basin_index))
            if heights[n] != 9
        ]
    return (
        basin_indexes
        if len(new_basin_indexes) == 0
        else explore_basin(heights, basin_indexes + new_basin_indexes)
    )


def basins(heights):
    return [explore_basin(heights, [index]) for index in low_points(heights)]


def three_largest_basins_product(heights=parse(DATA)):
    basins_size = [len(b) for b in basins(heights)]
    return reduce(mul, sorted(basins_size, reverse=True)[:3], 1)


# Tests
test_input = """
2199943210
3987894921
9856789892
8767896789
9899965678
""".strip()

assert_eq(15, risk_sum(parse(test_input.split("\n"))))
assert_eq(1134, three_largest_basins_product(parse(test_input.split("\n"))))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = risk_sum()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = three_largest_basins_product()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
