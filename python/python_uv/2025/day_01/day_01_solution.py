"""Solution to Day XX of Advent of Code 2021"""

import timeit
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()

# Data parsing functions
# DEFINE HERE...


# Data analysis
def rotate(rotations=DATA):
    dial = 50
    password = 0
    for r in rotations:
        letter = r[0]
        count = int(r[1:])
        sign = -1 if letter == "L" else 1

        dial = (dial + sign * count) % 100

        password += 1 if dial == 0 else 0
    return password


def rotate_second(rotations=DATA):
    dial = 50
    password = 0
    for r in rotations:
        letter = r[0]
        count = int(r[1:])
        sign = -1 if letter == "L" else 1

        q, r = divmod(dial + sign * count, 100)

        previous_dial = dial
        dial = r

        password += abs(q)
        password -= 1 if previous_dial == 0 and q < 0 else 0
        password += 1 if dial == 0 and q <= 0 else 0
    return password


assert (
    rotate(["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"])
) == 3

assert (
    rotate_second(["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"])
) == 6

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = rotate()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = rotate_second()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
