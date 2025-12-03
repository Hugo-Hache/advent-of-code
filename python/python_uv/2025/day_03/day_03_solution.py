import timeit
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read().split("\n")

# Data parsing functions
BANKS = DATA


# Data analysis
def total_joltage(digits, banks=BANKS):
    total = 0
    for bank in banks:
        print(bank_max_voltage(bank, digits))
        total += int("".join(map(str, bank_max_voltage(bank, digits))))
    return total


def bank_max_voltage(bank, digits):
    if digits == 0:
        return []

    max_joltage_index = -1
    max_joltage = 0
    for i in range(len(bank) - max(0, digits - 1)):
        if int(bank[i]) > max_joltage:
            max_joltage = int(bank[i])
            max_joltage_index = i
    return [max_joltage, *bank_max_voltage(bank[max_joltage_index + 1 :], digits - 1)]


def assert_equal(actual, expected):
    assert expected == actual, f"Expected {expected} but got {actual}"


assert_equal(
    total_joltage(
        2,
        """987654321111111
811111111111119
234234234234278
818181911112111""".split(
            "\n"
        ),
    ),
    357,
)

assert_equal(
    total_joltage(
        12,
        """987654321111111
811111111111119
234234234234278
818181911112111""".split(
            "\n"
        ),
    ),
    3121910778619,
)


# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = total_joltage(2)
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = total_joltage(12)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
