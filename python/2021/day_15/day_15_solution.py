""" Solution to Day 15 of Advent of Code 2021 """
import timeit
from pathlib import Path
from operator import add
import numpy as np

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
def parse(data=DATA):
    return np.array([[int(i) for i in line] for line in data.strip().split("\n")])


# Data analysis
NEIGHBORS = [(0, 1), (1, 0), (0, -1), (-1, 0)]


def valid_index(risks, index):
    return all([0 <= index[dim] and index[dim] < risks.shape[dim] for dim in range(2)])


def neighbors(risks, index):
    return [
        tuple(map(add, index, d))
        for d in NEIGHBORS
        if valid_index(risks, tuple(map(add, index, d)))
    ]


def five(risks):
    five_risks = np.block([[(risks + (r + c)) for c in range(5)] for r in range(5)])
    return np.array([[v if v < 10 else v - 9 for v in row] for row in five_risks])


def lowest_total_risk(risks=parse()):
    coords = (0, 0)
    total_risk = 0
    paths = {coords: total_risk}
    to_explore = []

    bottom_right = (risks.shape[0] - 1, risks.shape[1] - 1)
    while coords != bottom_right:
        for n in neighbors(risks, coords):
            new_risk = total_risk + risks[n]
            if n not in paths or new_risk < paths[n]:
                paths[n] = new_risk
                to_explore.append(n)

        coords = min(to_explore, key=(lambda c: paths[c]))
        to_explore.remove(coords)
        total_risk = paths[coords]

    return paths[coords]


# Tests
test_input = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
""".strip()

assert_eq(40, lowest_total_risk(parse(test_input)))
assert_eq(315, lowest_total_risk(five(parse(test_input))))

MEMO_FREQ = {}

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = lowest_total_risk()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = lowest_total_risk(five(parse()))
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
