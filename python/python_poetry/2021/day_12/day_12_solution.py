""" Solution to Day 12 of Advent of Code 2021 """
import timeit
from pathlib import Path

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
def parse(lines=DATA):
    nexts = {}
    for line in lines:
        start, end = line.strip().split("-")
        nexts[start] = [*nexts.get(start, []), end]
        nexts[end] = [*nexts.get(end, []), start]
    return nexts


# Data analysis
def valid_next_cave(next_cave, small_caves_visited, double_small):
    if next_cave.isupper():
        return True

    if next_cave not in small_caves_visited:
        return True

    return (
        double_small
        and next_cave != "start"
        and all([v == 1 for v in small_caves_visited.values()])
    )


def paths(nexts, double_small, cave="start", small_caves_visited={}):
    if cave == "end":
        return [["end"]]

    if cave.islower():
        small_caves_visited = small_caves_visited | {
            cave: small_caves_visited.get(cave, 0) + 1
        }

    return [
        [cave, *p]
        for next_cave in nexts.get(cave, [])
        if valid_next_cave(next_cave, small_caves_visited, double_small)
        for p in paths(nexts, double_small, next_cave, small_caves_visited)
    ]


def paths_count(nexts=parse(), double_small=False):
    p = paths(nexts, double_small)
    return len(p)


# Tests
test_input = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
""".strip()

assert_eq(19, paths_count(parse(test_input.split("\n"))))
assert_eq(103, paths_count(parse(test_input.split("\n")), True))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = paths_count()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = paths_count(double_small=True)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
