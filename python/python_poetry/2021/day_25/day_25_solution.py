""" Solution to Day 25 of Advent of Code 2021 """
import timeit
from pathlib import Path
from queue import PriorityQueue

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


# Data parsing function
def parse(data=DATA):
    lines = data.split("\n")
    grid = Grid(len(lines), len(lines[0].strip()))

    easterns = set()
    southerns = set()
    for i, line in enumerate(lines):
        for j, c in enumerate(line.strip()):
            if c == ">":
                easterns.add((i, j))
            elif c == "v":
                southerns.add((i, j))
    grid.easterns = easterns
    grid.southerns = southerns

    return grid


# Data analysis
class Grid:
    def __init__(self, height, width):
        self.height = height
        self.width = width
        self.easterns = set()
        self.southerns = set()

    def set_easterns(self, easterns):
        self.easterns = easterns

    def set_southerns(self, southerns):
        self.southerns = southerns

    def print(self):
        for i in range(self.height):
            print(
                "".join(
                    [
                        ">"
                        if (i, j) in self.easterns
                        else "v"
                        if (i, j) in self.southerns
                        else "."
                        for j in range(self.width)
                    ]
                )
            )


def move_east(grid, i, j):
    next = (i, (j + 1) % grid.width)
    return move(grid, (i, j), next)


def move_south(grid, i, j):
    next = ((i + 1) % grid.height, j)
    return move(grid, (i, j), next)


def move(grid, current, next):
    if next in grid.easterns or next in grid.southerns:
        return (current, False)
    else:
        return (next, True)


def moving_steps(cucumbers=parse()):
    grid = cucumbers

    step = 0
    step_moved = True

    while step_moved:
        step_moved = False
        new_easterns = set()
        for i, j in grid.easterns:
            new, moved = move_east(grid, i, j)
            new_easterns.add(new)
            step_moved = step_moved or moved
        grid.set_easterns(new_easterns)

        new_southerns = set()
        for i, j in grid.southerns:
            new, moved = move_south(grid, i, j)
            new_southerns.add(new)
            step_moved = step_moved or moved
        grid.set_southerns(new_southerns)
        step += 1

    return step


# Tests
test_input = """
v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>
""".strip()

assert_eq(58, moving_steps(parse(test_input)))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = moving_steps()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n")
