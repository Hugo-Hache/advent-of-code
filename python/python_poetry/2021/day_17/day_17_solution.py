""" Solution to Day 17 of Advent of Code 2021 """
from functools import reduce
import re
import timeit
from pathlib import Path

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq, inclusive_range

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read().strip()


# Data parsing functions
def parse(data=DATA):
    xmin, xmax, ymin, ymax = re.match(
        r"target area: x=(-?\d*)..(-?\d*), y=(-?\d*)..(-?\d*)", data
    ).groups()
    return (int(xmin), int(xmax), int(ymin), int(ymax))


# Data analysis
def sexy(trajectory, target):
    xs, ys = list(zip(*trajectory))
    xmin, xmax, ymin, ymax = target

    print("Trajectory")
    for y in inclusive_range(max(ymax, *ys), min(ymin, *ys)):
        print(
            "".join(
                [
                    "#"
                    if (x, y) in trajectory
                    else ("T" if on_target(target, x, y) else ".")
                    for x in inclusive_range(min(xmin, *xs), max(xmax, *xs))
                ]
            )
        )


def on_target(target, xn, yn):
    xmin, xmax, ymin, ymax = target
    return xmin <= xn and xn <= xmax and ymin <= yn and yn <= ymax


def compute_trajectory(target, x, y):
    _, xmax, ymin, _ = target
    xn = 0
    yn = 0
    trajectory = [(xn, yn)]

    while xn <= xmax and yn >= ymin:
        xn += x
        yn += y
        x = 0 if x == 0 else x - 1
        y -= 1

        trajectory.append((xn, yn))
        if on_target(target, xn, yn):
            return trajectory

    return None


def valid_trajectory(target, y):
    _, xmax, _, _ = target

    x = 1
    trajectory = compute_trajectory(target, x, y)
    while not trajectory and (x <= xmax):
        x += 1
        trajectory = compute_trajectory(target, x, y)

    return trajectory


def highest_trajectory(target):
    y = 0
    step = 10

    valid_trajectories = []
    one_valid_trajectory = True
    while one_valid_trajectory:
        one_valid_trajectory = False
        for i in range(step):  # to overcome local minimum
            trajectory = valid_trajectory(target, y + i)
            if trajectory:
                one_valid_trajectory = True
                valid_trajectories.append(trajectory)
        y += step

    return valid_trajectories.pop()


def highest_position(target=parse()):
    trajectory = highest_trajectory(target)
    ys = list(zip(*trajectory))[1]
    return max(ys)


def distinct_initial_velocities(target=parse()):
    _, xmax, ymin, _ = target
    x_highest_trajectory, y_highest_trajectory = highest_trajectory(target)[1]

    velocities = set()
    for x in range(x_highest_trajectory, xmax + 1):
        for y in range(ymin - 1, y_highest_trajectory + 1):
            if compute_trajectory(target, x, y):
                velocities.add((x, y))
    return len(velocities)


# Tests
test_input = "target area: x=20..30, y=-10..-5"

assert_eq(45, highest_position(parse(test_input)))
assert_eq(112, distinct_initial_velocities(parse(test_input)))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = highest_position()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = distinct_initial_velocities()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
