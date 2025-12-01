""" Solution to Day 11 of Advent of Code 2021 """
import timeit
from pathlib import Path
import numpy as np
from operator import add

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


# Data parsing functions
def parse(data=DATA):
    return np.array([[int(e) for e in line.strip()] for line in data])


# Data analysis

NEIGHBORS = [(0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1)]


def valid_index(index):
    return 0 <= index[0] and index[0] < 10 and 0 <= index[1] and index[1] < 10


def neighbors(index):
    return [
        tuple(map(add, index, d))
        for d in NEIGHBORS
        if valid_index(tuple(map(add, index, d)))
    ]


def flashing_indexes(energies):
    return [index for index, e in np.ndenumerate(energies) if e > 9]


def tick(energies):
    cycle_flashes = 0
    new_energies = energies + 1

    indexes = flashing_indexes(new_energies)
    while len(indexes) > 0:
        for index in indexes:
            new_energies[index] = 0
            cycle_flashes += 1
            for n in neighbors(index):
                if new_energies[n] > 0:
                    new_energies[n] += 1
        indexes = flashing_indexes(new_energies)

    return (new_energies, cycle_flashes)


def total_flashes(energies=parse(DATA), cycle=100, flashes=0):
    if cycle == 0:
        return flashes

    (new_energies, cycle_flashes) = tick(energies)
    return total_flashes(new_energies, cycle - 1, flashes + cycle_flashes)


def all_flash_cycle(energies=parse(DATA), cycle=1):
    (new_energies, cycle_flashes) = tick(energies)

    if cycle_flashes == 100:
        return cycle

    return all_flash_cycle(new_energies, cycle + 1)


# Tests
test_input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
""".strip()

assert_eq(1656, total_flashes(parse(test_input.split("\n"))))
assert_eq(195, all_flash_cycle(parse(test_input.split("\n"))))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = total_flashes()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = all_flash_cycle()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
