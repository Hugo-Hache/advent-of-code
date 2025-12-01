""" Solution to Day 18 of Advent of Code 2021 """
from functools import reduce
import re
import timeit
from pathlib import Path
from math import floor, ceil
from itertools import permutations

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq, inclusive_range

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


# Data parsing functions
def parse(lines=DATA):
    return [eval(l.strip()) for l in lines]


# Data analysis
def explode(number, depth):
    if not isinstance(number, list):
        return (number, None)

    left, right = number
    if depth == 4:
        return ("X", (left, right))

    exploded_left, collaterals = explode(left, depth + 1)
    if collaterals:
        return ([exploded_left, right], collaterals)

    exploded_right, collaterals = explode(right, depth + 1)
    return ([left, exploded_right], collaterals)


def exploded(number):
    exploded_number, collaterals = explode(number, 0)
    if not collaterals:
        return None

    l, r = str(exploded_number).split("'X'")

    left_match = re.match(r"(.*)([, \[])(\d+)([^\d]*)", l)
    if left_match:
        left_groups = list(left_match.groups())
        left_groups[2] = str(int(left_groups[2]) + collaterals[0])
        l = "".join(left_groups)

    right_match = re.match(r"([^\d]*)(\d+)(.*)", r)
    if right_match:
        right_groups = list(right_match.groups())
        right_groups[1] = str(int(right_groups[1]) + collaterals[1])
        r = "".join(right_groups)

    return eval("".join([l, "0", r]))


def split(number):
    if not isinstance(number, list):
        if number < 10:
            return (number, False)
        else:
            return ([floor(number / 2), ceil(number / 2)], True)

    left, right = number
    splitted_left, left_did_split = split(left)
    if left_did_split:
        return ([splitted_left, right], True)

    splitted_right, right_did_split = split(right)
    return ([left, splitted_right], right_did_split)


def splitted(number):
    splitted_number, did_split = split(number)
    return splitted_number if did_split else None


def snail_reduce(number):
    while new_number := (exploded(number) or splitted(number)):
        number = new_number
    return number


def snail_add(n1, n2):
    return snail_reduce([n1, n2])


def sum(numbers=parse()):
    return reduce(snail_add, numbers)


def magnitude(number):
    if not isinstance(number, list):
        return number

    left, right = number
    return 3 * magnitude(left) + 2 * magnitude(right)


def largest_magnitude(numbers=parse()):
    return max([magnitude(sum(list(p))) for p in permutations(numbers, 2)])


# Tests
test_input = """
[1,1]
[2,2]
[3,3]
[4,4]
""".strip()
assert_eq([[[[1, 1], [2, 2]], [3, 3]], [4, 4]], sum(parse(test_input.split("\n"))))
test_input = """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
""".strip()
assert_eq([[[[3, 0], [5, 3]], [4, 4]], [5, 5]], sum(parse(test_input.split("\n"))))
test_input = """
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
""".strip()
assert_eq(
    [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]],
    sum(parse(test_input.split("\n"))),
)
test_input = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""".strip()
assert_eq(4140, magnitude(sum(parse(test_input.split("\n")))))
assert_eq(3993, largest_magnitude(parse(test_input.split("\n"))))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = magnitude(sum())
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = largest_magnitude()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
