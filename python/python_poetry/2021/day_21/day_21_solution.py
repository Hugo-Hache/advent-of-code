""" Solution to Day 21 of Advent of Code 2021 """
import timeit
from pathlib import Path

import os, sys, inspect
from typing import Counter

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.readlines()


# Data parsing functions
def parse(lines=DATA):
    return tuple([int(l.split(" ")[-1]) for l in lines])


# Data analysis
def play(input=parse()):
    pos_1, pos_2 = input
    score_1 = 0
    score_2 = 0
    dice = 2
    while score_2 < 1000:
        pos_1 = (pos_1 + dice * 3) % 10
        if pos_1 == 0:
            pos_1 = 10
        score_1 += pos_1
        dice += 3

        if score_1 >= 1000:
            break

        pos_2 = (pos_2 + dice * 3) % 10
        if pos_2 == 0:
            pos_2 = 10
        score_2 += pos_2
        dice += 3

    return min(score_1, score_2) * (dice - 2)


DIRAC_TRIPLE_ROLLS_COUNTER = Counter(
    [i + j + k for i in range(1, 4) for j in range(1, 4) for k in range(1, 4)]
).items()

MEMO_PLAY = {}


def quantum_play(positions, scores, player_1_turn):
    memo_key = (positions, scores, player_1_turn)
    if MEMO_PLAY.get(memo_key, False):
        MEMO_PLAY[memo_key]

    pos_1, pos_2 = positions
    score_1, score_2 = scores

    outcomes = []
    if player_1_turn:
        for value, repeat in DIRAC_TRIPLE_ROLLS_COUNTER:
            new_pos = (pos_1 + value) % 10
            if new_pos == 0:
                new_pos = 10
            new_score = score_1 + new_pos
            outcome = (
                quantum_play((new_pos, pos_2), (new_score, score_2), not player_1_turn)
                if new_score < 21
                else [1, 0]
            )
            outcomes.append([repeat * outcome[0], repeat * outcome[1]])
    else:
        for value, repeat in DIRAC_TRIPLE_ROLLS_COUNTER:
            new_pos = (pos_2 + value) % 10
            if new_pos == 0:
                new_pos = 10
            new_score = score_2 + new_pos
            outcome = (
                quantum_play((pos_1, new_pos), (score_1, new_score), not player_1_turn)
                if new_score < 21
                else [0, 1]
            )
            outcomes.append([repeat * outcome[0], repeat * outcome[1]])
    MEMO_PLAY[memo_key] = [sum(x) for x in zip(*outcomes)]

    return MEMO_PLAY[memo_key]


def quantum_winner_universes_count(positions=parse()):
    return max(quantum_play(positions, (0, 0), True))


# Tests
test_input = """
Player 1 starting position: 4
Player 2 starting position: 8
""".strip()
assert_eq(739785, play(parse(test_input.split("\n"))))
assert_eq(
    444356092776315, quantum_winner_universes_count(parse(test_input.split("\n")))
)

MEMO_PLAY = {}

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = play()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = quantum_winner_universes_count()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
