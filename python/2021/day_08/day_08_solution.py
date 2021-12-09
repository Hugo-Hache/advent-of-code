""" Solution to Day 08 of Advent of Code 2021 """
import timeit
from pathlib import Path

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data line by line
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


# Data parsing functions
def parse(data):
    return [[part.split(" ") for part in line.strip().split(" | ")] for line in data]


# Data analysis
def digits_with_unique_segments(lines=parse(DATA)):
    return len(
        [
            segment
            for line in lines
            for segment in line[1]
            if len(segment) in [2, 3, 4, 7]
        ]
    )


# 2: 1
# 3: 7
# 4: 4
# 5: 2,3,5
# 6: 0,6,9
# 7: 8
#
# 2 => pas 1 (1/2), pas 4 (2/4), pas 7 (2/3)
# 3 => 1, pas 4, 7
# 5 => pas 1 (1/2), pas 4 (3/4), pas 7 (2/3)
#
# 0 => 1, pas 4, 7
# 6 => pas 1, pas 4, pas, 7
# 9 => 1, 4, 7


def output_value(line):
    one = [d for d in line[0] if len(d) == 2][0]
    four = [d for d in line[0] if len(d) == 4][0]
    digits = []
    for segments in line[1]:
        if len(segments) == 2:
            digits.append("1")
        elif len(segments) == 3:
            digits.append("7")
        elif len(segments) == 4:
            digits.append("4")
        elif len(segments) == 5:
            if set(one).issubset(set(segments)):
                digits.append("3")
            else:
                diff = len(set(four).difference(set(segments)))
                digits.append("2" if diff == 2 else "5")
        elif len(segments) == 6:
            if set(one).issubset(set(segments)):
                digits.append("9" if set(four).issubset(set(segments)) else "0")
            else:
                digits.append("6")
        else:
            digits.append("8")
    return int("".join(digits))


def output_sum(lines=parse(DATA)):
    return sum([output_value(l) for l in lines])


# Tests
test_input = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
""".strip()

assert_eq(26, digits_with_unique_segments(parse(test_input.split("\n"))))
assert_eq(61229, output_sum(parse(test_input.split("\n"))))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = digits_with_unique_segments()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = output_sum()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
