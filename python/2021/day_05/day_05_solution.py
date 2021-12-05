""" Solution to Day 05 of Advent of Code 2021 """
import timeit
from pathlib import Path

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq, inclusive_range

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


# Data parsing functions
def vents(data=DATA):
    vents = []
    for line in data:
        start, end = line.split(" -> ")
        x1, y1 = map(int, start.split(","))
        x2, y2 = map(int, end.split(","))
        vents.append([(x1, y1), (x2, y2)])
    return vents


# Data analysis
def print_diagram(diagram):
    print("DIAGRAM")
    for y in range(10):
        print(" ".join([str(diagram.get((x, y), 0)) for x in range(10)]))


def update_diagram(diagram, coords):
    for c in coords:
        diagram[c] = diagram.get(c, 0) + 1


def diagram(vents, diagonal=False):
    diagram = {}
    for vent in vents:
        [(x1, y1), (x2, y2)] = vent
        if y1 == y2:
            update_diagram(diagram, [(i, y1) for i in inclusive_range(x1, x2)])
        if x1 == x2:
            update_diagram(diagram, [(x1, i) for i in inclusive_range(y1, y2)])
        if diagonal and abs(x2 - x1) == abs(y2 - y1):
            update_diagram(
                diagram, zip(inclusive_range(x1, x2), inclusive_range(y1, y2))
            )
    return diagram


def vented(diagram):
    return len([v for v in diagram.values() if v > 1])


# Tests
test_input = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
""".strip()

assert_eq(5, vented(diagram(vents(test_input.split("\n")))))
assert_eq(12, vented(diagram(vents(test_input.split("\n")), diagonal=True)))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = vented(diagram(vents()))
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = vented(diagram(vents(), diagonal=True))
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
