"""Solution to Day XX of Advent of Code 2021"""

from ast import parse
import timeit
import math
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


def parse_input(input):
    return list(map(parse_range, input.split(",")))


def parse_range(r):
    return list(map(int, r.split("-")))


# Data parsing functions
RANGES = parse_input(DATA[0])


# Data analysis
def digits_count(n):
    return int(math.log(n, 10)) + 1


def invalid_ids_total(ranges=RANGES):
    max_end = max(r[1] for r in ranges)
    if digits_count(max_end) % 2 == 0:
        max_half_id = int(str(max_end)[: digits_count(max_end) // 2])
    else:
        max_half_id = int("9" * (digits_count(max_end) - 1) // 2)

    invalid_ids = []
    for i in range(1, max_half_id + 1):
        invalid_ids.append(int(f"{i}{i}"))

    total = 0
    for i, r in enumerate(ranges):
        start, end = r
        for id in invalid_ids:
            if id >= start and id <= end:
                total += id

    return total


# Assertions


def assert_equal(actual, expected):
    assert expected == actual, f"Expected {expected} but got {actual}"


assert_equal(
    invalid_ids_total(
        parse_input(
            "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        )
    ),
    1227775554,
)


# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = invalid_ids_total()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = "TODO"
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
