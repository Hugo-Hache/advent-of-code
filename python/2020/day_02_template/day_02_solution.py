""" Solution to Day 02 of Advent of Code 2020 """
import timeit
import re
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


# Data parsing functions
def parse_rule(line):
    return re.match(r"(\d+)-(\d+) (\w): (\w*)", line).groups()


RULES = list(map(parse_rule, DATA))


# Data analysis
def valid_count(rule):
    low, high, letter, password = rule
    return int(low) <= password.count(letter) and password.count(letter) <= int(high)


def valid_position(rule):
    low, high, letter, password = rule
    return (password[int(low) - 1] == letter) ^ (password[int(high) - 1] == letter)


# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = len([r for r in RULES if valid_count(r)])
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = len([r for r in RULES if valid_position(r)])
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
