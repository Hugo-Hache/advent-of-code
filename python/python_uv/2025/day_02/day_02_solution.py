"""Solution to Day XX of Advent of Code 2021"""

from ast import parse
import timeit
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
    return len(str(n))


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


H = {
    1: [],
    2: [[1, 2]],
    3: [[1, 3]],
    4: [[1, 4], [2, 2]],
    5: [[1, 5]],
    6: [[1, 6], [2, 3], [3, 2]],
    7: [[1, 7]],
    8: [[1, 8], [2, 4], [4, 2]],
    9: [[1, 9], [3, 3]],
    10: [[1, 10], [2, 5], [5, 2]],
}


def same_digits_count_ranges(start, end):
    sd = digits_count(start)
    ed = digits_count(end)
    if sd == ed:
        return [[start, end]]

    ranges = [
        [start, int("9" * sd)],
        [int("1" + "0" * (ed - 1)), end],
    ]
    for i in range(sd + 1, ed):
        ranges.append([int("1" + "0" * (i - 1)), int("9" * i)])
    return ranges


def potential_invalid_ids_same_digits_count(start, end):
    s = str(start)
    e = str(end)

    ids = []
    for digits, repetition in H[digits_count(start)]:
        for i in range(int(s[:digits]), int(e[:digits]) + 1):
            ids.append(int(str(i) * repetition))

    return ids


def potential_invalid_ids(start, end):
    ids = []
    for sr, er in same_digits_count_ranges(start, end):
        ids += potential_invalid_ids_same_digits_count(sr, er)

    return set(ids)


def invalid_ids_total_second(ranges=RANGES):
    total = 0
    for r in ranges:
        start, end = r
        for potential_invalid_id in potential_invalid_ids(start, end):
            if potential_invalid_id >= start and potential_invalid_id <= end:
                total += potential_invalid_id
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


assert_equal(
    invalid_ids_total_second(
        parse_input(
            "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        )
    ),
    4174379265,
)


# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = invalid_ids_total()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = invalid_ids_total_second()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
