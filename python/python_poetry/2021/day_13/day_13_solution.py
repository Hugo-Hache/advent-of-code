""" Solution to Day 13 of Advent of Code 2021 """
import re
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
def parse(data=DATA):
    dots_coords, folds_insts = data.strip().split("\n\n")

    dots = {
        tuple(reversed(list(map(int, c.split(","))))) for c in dots_coords.split("\n")
    }
    folds = []
    for inst in folds_insts.split("\n"):
        axis, val = re.match(r"fold along (\w)=(\d*)", inst).groups()
        folds.append((axis, int(val)))

    return (dots, folds)


# Data analysis
def fold(dots, axis, val):
    new_dots = set()
    for row, column in dots:
        if axis == "y" and row > val:
            new_row = val - (row - val)
            new_dots.add((new_row, column))
        elif axis == "x" and column > val:
            new_column = val - (column - val)
            new_dots.add((row, new_column))
        else:
            new_dots.add((row, column))
    return new_dots


def grid_print(dots):
    rows, columns = list(zip(*dots))
    for r in range(min(rows), max(rows) + 1):
        print(
            "".join(
                [
                    "#" if (r, c) in dots else "."
                    for c in range(min(columns), max(columns) + 1)
                ]
            )
        )


def visible_dots(input=parse(), first_fold_only=True):
    (dots, folds) = input

    for axis, val in folds[: (1 if first_fold_only else None)]:
        dots = fold(dots, axis, val)

    if not first_fold_only:
        grid_print(dots)

    return len(dots)


# Tests
test_input = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
""".strip()

assert_eq(17, visible_dots(parse(test_input)))
assert_eq(16, visible_dots(parse(test_input), first_fold_only=False))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = visible_dots()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = visible_dots(first_fold_only=False)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
