""" Solution to Day 23 of Advent of Code 2021 """
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
    DATA = input_file.readlines()


# Data parsing functions
def parse(lines=DATA):
    return [
        tuple(
            map(
                int,
                [
                    lines[i * 18 + 5].strip().split(" ")[-1],
                    lines[i * 18 + 15].strip().split(" ")[-1],
                ],
            )
        )
        for i in range(14)
    ]


# Data analysis

# Algo consists in :
# def alu(number):
#     z = 0
#     for c in str(number):
#         digit = int(c)
#         if (
#             z + int of line 5
#         ) != digit:
#             z += digit + int of line 15
#     return z


# Thanks reddit community
def monad(pairs=parse(), search_max=True):
    duo = {}
    stack = []
    for index, (a, b) in enumerate(pairs):
        if (
            a > 0
        ):  # No way you can have previous_b + a == digit, you'll need to balance it later
            stack.append((index, b))
        else:  # With neg a, you will be able to balance previous_b
            previous_index, previous_b = stack.pop()
            duo[index] = (previous_index, previous_b + a)

    solution = {}
    for (index, (previous_index, diff)) in duo.items():
        solution[index] = min(9, 9 + diff) if search_max else max(1, 1 + diff)
        solution[previous_index] = min(9, 9 - diff) if search_max else max(1, 1 - diff)

    return "".join([str(solution[i]) for i in range(14)])


# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = monad()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = monad(search_max=False)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
