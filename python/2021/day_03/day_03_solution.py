""" Solution to Day 03 of Advent of Code 2021 """
import timeit
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()

BITS = list(map(list, DATA))

# Data analysis
def power_consumption(bits=BITS):
    # ones = list(map(lambda x: x.count("1"), zip(*bits)))
    ones = [x.count("1") for x in zip(*bits)]
    gamma_bits = "".join(
        map(lambda one_count: str(int(one_count > len(bits) / 2)), ones)
    )
    epsilon_bits = "".join(
        map(lambda one_count: str(int(one_count < len(bits) / 2)), ones)
    )
    return int(gamma_bits, 2) * int(epsilon_bits, 2)


def rating(bits, bit_criteria, position=0):
    if len(bits) == 1:
        return int("".join(bits[0]), 2)

    # ones_in_positional_bit = list(zip(*bits))[position].count("1")
    ones_in_positional_bit = len([b for b in bits if b[position] == "1"])
    bit_filter = "1" if bit_criteria(ones_in_positional_bit, len(bits)) else "0"
    new_bits = list(filter(lambda b: b[position] == bit_filter, bits))
    return rating(new_bits, bit_criteria, position + 1)


def life_support_rating(bits=BITS):
    oxygen_generator_criteria = lambda one_count, size: one_count >= size / 2
    co2_scrubber_criteria = lambda one_count, size: one_count < size / 2
    return rating(bits, oxygen_generator_criteria) * rating(bits, co2_scrubber_criteria)


# Tests
test_input = [
    "00100",
    "10110",
    "11110",
    "10111",
    "10101",
    "01111",
    "00111",
    "11100",
    "10000",
    "11001",
    "00010",
    "01010",
]

assert power_consumption(list(map(list, test_input))) == 198
assert life_support_rating(list(map(list, test_input))) == 230

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = power_consumption()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = life_support_rating()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
