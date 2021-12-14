""" Solution to Day 14 of Advent of Code 2021 """
import re
import timeit
from pathlib import Path
from itertools import pairwise
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
    polymer, rules = data.strip().split("\n\n")
    return (polymer, dict([r.split(" -> ") for r in rules.split("\n")]))


# Data analysis
def merge_frequency(first_frequency, second_frequency):
    merge_frequency = first_frequency.copy()
    for elem, value in second_frequency.items():
        merge_frequency[elem] = first_frequency.get(elem, 0) + value
    return merge_frequency


def frequency(rules, first_elem, second_elem, remaining_steps):
    if remaining_steps == 0:
        return {first_elem: 1}

    new_element = rules[first_elem + second_elem]
    return merge_frequency(
        memoized_frequency(rules, first_elem, new_element, remaining_steps - 1),
        memoized_frequency(rules, new_element, second_elem, remaining_steps - 1),
    )


MEMO_FREQ = {}


def memoized_frequency(rules, first_elem, second_elem, remaining_steps):
    memo_key = (first_elem, second_elem, remaining_steps)
    memo = MEMO_FREQ.get(memo_key, False)
    if memo:
        return memo

    MEMO_FREQ[memo_key] = frequency(rules, first_elem, second_elem, remaining_steps)
    return MEMO_FREQ[memo_key]


def difference_minmax_frequency(input=parse(), remaining_steps=40):
    polymer, rules = input
    frequencies = [
        frequency(rules, first_elem, second_elem, remaining_steps)
        for first_elem, second_elem in pairwise(polymer)
    ]

    global_frequency = {polymer[-1]: 1}
    for f in frequencies:
        global_frequency = merge_frequency(global_frequency, f)

    return max(global_frequency.values()) - min(global_frequency.values())


def process(rules, polymer, remaining_steps):
    if remaining_steps == 0:
        return polymer

    new_polymer = ""
    for first_elem, second_elem in pairwise(polymer):
        new_polymer += first_elem
        new_polymer += rules[first_elem + second_elem]
    new_polymer += polymer[-1]
    return process(rules, new_polymer, remaining_steps - 1)


def difference_minmax_frequency_naive(input=parse(), remaining_steps=10):
    polymer, rules = input
    processed_polymer = process(rules, polymer, remaining_steps)
    frequency = {
        letter: processed_polymer.count(letter) for letter in set(processed_polymer)
    }
    return max(frequency.values()) - min(frequency.values())


# Tests
test_input = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
""".strip()

assert_eq(1588, difference_minmax_frequency_naive(parse(test_input)))
assert_eq(2188189693529, difference_minmax_frequency(parse(test_input)))

MEMO_FREQ = {}

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = difference_minmax_frequency_naive()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = difference_minmax_frequency()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
