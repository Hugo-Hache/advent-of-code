""" Solution to Day 04 of Advent of Code 2021 """
import timeit
from pathlib import Path

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq, flatten

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data as a block
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read()


# Data parsing functions
class Grid:
    def __init__(self, block) -> None:
        self.rows = [row.split() for row in block.split("\n")]
        self.rows_as_set = [set(row) for row in self.rows]
        self.columns_as_set = [set(column) for column in zip(*self.rows)]

    def is_winner(self, drawn_numbers):
        drawn_numbers_set = set(drawn_numbers)
        return any(
            row_set.issubset(drawn_numbers_set) for row_set in self.rows_as_set
        ) or any(
            column_set.issubset(drawn_numbers_set) for column_set in self.columns_as_set
        )

    def unlucky_numbers(self, drawn_numbers):
        return [n for n in flatten(self.rows) if n not in drawn_numbers]


def bingo(data=DATA):
    blocks = data.split("\n\n")
    lucky_numbers = blocks[0].split(",")
    grids = [Grid(block) for block in blocks[1:]]
    return (lucky_numbers, grids)


# Data analysis
def play(lucky_numbers, grids, let_paul_win=False):
    playing_grids = grids
    for i in range(len(lucky_numbers)):
        drawn_numbers = lucky_numbers[:i]
        winning_grids = [
            grid for grid in playing_grids if grid.is_winner(drawn_numbers)
        ]
        if winning_grids:
            if let_paul_win and len(playing_grids) > 1:
                playing_grids = [
                    grid for grid in playing_grids if grid not in winning_grids
                ]
                continue

            return sum(map(int, winning_grids[0].unlucky_numbers(drawn_numbers))) * int(
                lucky_numbers[i - 1]
            )


# Tests
test_input = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

assert_eq(4512, play(*bingo(test_input.strip())))
assert_eq(1924, play(*bingo(test_input.strip()), let_paul_win=True))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = play(*bingo())
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = play(*bingo(), let_paul_win=True)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
