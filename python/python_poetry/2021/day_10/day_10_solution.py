""" Solution to Day 10 of Advent of Code 2021 """
import timeit
from pathlib import Path
import math

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read()


# Data parsing functions
def parse(data=DATA):
    return [[c for c in line.strip()] for line in data.split("\n")]


# Data analysis
CHAR_CLOSING = {"(": ")", "[": "]", "{": "}", "<": ">"}


def first_illegal_char(chars):
    stack = []
    for c in chars:
        if CHAR_CLOSING.get(c, False):
            stack.append(c)
        elif c != CHAR_CLOSING[stack.pop()]:
            return c


def closing_sequence(chars):
    stack = []
    for c in chars:
        if CHAR_CLOSING.get(c, False):
            stack.append(c)
        elif c != CHAR_CLOSING[stack.pop()]:
            return ""
    return map(lambda c: CHAR_CLOSING[c], reversed(stack))


CHAR_COMPLETE_SCORE = {")": 1, "]": 2, "}": 3, ">": 4}


def complete_score(chars):
    score = 0
    for c in closing_sequence(chars):
        score = score * 5
        score += CHAR_COMPLETE_SCORE[c]
    return score


def middle_complete_score(lines=parse()):
    scores = sorted(filter(lambda s: s > 0, [complete_score(line) for line in lines]))
    return scores[math.floor(len(scores) / 2)]


CHAR_ERROR_SCORE = {")": 3, "]": 57, "}": 1197, ">": 25137, None: 0}


def syntax_error_score(lines=parse()):
    return sum([CHAR_ERROR_SCORE[first_illegal_char(line)] for line in lines])


# Tests
test_input = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
""".strip()

assert_eq(26397, syntax_error_score(parse(test_input)))
assert_eq(288957, middle_complete_score(parse(test_input)))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = syntax_error_score()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = middle_complete_score()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
