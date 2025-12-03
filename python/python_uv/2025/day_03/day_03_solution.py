"""Solution to Day XX of Advent of Code 2021"""

from ast import parse
import timeit
import math
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read().split("\n")

# Data parsing functions
BANKS = list(map(list, DATA))


# Data analysis
def total_joltage(banks=BANKS):
    total = 0
    for bank in banks:
        total += bank_max_voltage(bank)
    return total


def bank_max_voltage(bank):
    max_joltage_index = -1
    max_joltage = 0
    for i in range(len(bank) - 1):
        if int(bank[i]) > max_joltage:
            max_joltage = int(bank[i])
            max_joltage_index = i

    second_max_joltage = 0
    for i in range(max_joltage_index + 1, len(bank)):
        if int(bank[i]) > second_max_joltage and i != max_joltage_index:
            second_max_joltage = int(bank[i])

    return int(f"{max_joltage}{second_max_joltage}")


# Assertions


def assert_equal(actual, expected):
    assert expected == actual, f"Expected {expected} but got {actual}"


assert_equal(
    total_joltage(
        """987654321111111
811111111111119
234234234234278
818181911112111""".split(
            "\n"
        )
    ),
    357,
)


# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = total_joltage()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = "TODO"
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
