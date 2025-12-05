import timeit
from pathlib import Path

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read()


# Data parsing functions
def parse_ranges(ranges_input):
    for range_input in ranges_input.split("\n"):
        start, end = range_input.split("-")
        yield [int(start), int(end)]


def parse_ingredients(ingredients_input):
    return list(map(int, ingredients_input.split("\n")))


# Data analysis
def fresh_ingredients_count(input=DATA):
    ranges_input, ingredients_input = input.split("\n\n")

    ranges = list(parse_ranges(ranges_input))
    ingredients = parse_ingredients(ingredients_input)

    count = 0
    for ingredient in ingredients:
        for range in ranges:
            if ingredient >= range[0] and ingredient <= range[1]:
                count += 1
                break
    return count


def all_fresh_ingredients_count(input=DATA):
    ranges_input, _ingredients_input = input.split("\n\n")
    ranges = list(parse_ranges(ranges_input))
    sorted_ranges = sorted(ranges, key=lambda x: x[0])

    merged_ranges = [sorted_ranges[0]]
    for i in range(1, len(sorted_ranges)):
        r = sorted_ranges[i]
        if r[0] <= merged_ranges[-1][1]:
            merged_ranges[-1][1] = max(merged_ranges[-1][1], r[1])
        else:
            merged_ranges.append(r)

    count = 0
    for r in merged_ranges:
        count += r[1] - r[0] + 1
    return count


def assert_equal(actual, expected):
    assert expected == actual, f"Expected {expected} but got {actual}"


assert_equal(
    fresh_ingredients_count(
        """3-5
10-14
16-20
12-18

1
5
8
11
17
32"""
    ),
    3,
)

assert_equal(
    all_fresh_ingredients_count(
        """3-5
10-14
16-20
12-18

1
5
8
11
17
32"""
    ),
    14,
)


# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = fresh_ingredients_count()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = all_fresh_ingredients_count()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
