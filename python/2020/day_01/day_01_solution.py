""" Solution to Day XX of Advent of Code 2020 """
import timeit
import typing as ty
from pathlib import Path
from itertools import combinations

import numpy as np

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()

# Data parsing functions
EXPENSES = list(map(int, DATA))

# Data analysis
def solve(target: int, dim: int, expenses: ty.List[int] = EXPENSES) -> ty.List[int]:
    return [
        np.product(comb) for comb in combinations(expenses, dim) if sum(comb) == target
    ]


# Tests
assert solve(2020, 2, [1721, 979, 366, 299, 675, 1456]) == [514579]

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = solve(2020, 2)
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = solve(2020, 3)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
