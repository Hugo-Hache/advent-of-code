""" Solution to Day 20 of Advent of Code 2021 """
import timeit
from pathlib import Path

import os, sys, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from helpers import assert_eq

# Constants
DATA_PATH = Path.resolve(Path(__file__).parent)

# read data
with open(DATA_PATH / "input.txt") as input_file:
    DATA = input_file.read().strip()


# Data parsing functions
def parse(data=DATA):
    algorithm, image_data = data.split("\n\n")

    image = {}
    lines = image_data.split("\n")
    image = {
        (i, j)
        for i in range(len(lines))
        for j in range(len(lines[i]))
        if lines[i][j] == "#"
    }
    return (algorithm, image)


# Data analysis
def square_pixels(pixel):
    i, j = pixel
    return [(i + di, j + dj) for di in range(-1, 2) for dj in range(-1, 2)]


def enhance(algorithm, image, tick):
    i_s, j_s = list(zip(*image))
    min_i_s = min(i_s)
    max_i_s = max(i_s)
    min_j_s = min(j_s)
    max_j_s = max(j_s)

    if algorithm[0] == "#" and tick % 2 == 1:
        outside = lambda i, j: i < min_i_s or i > max_i_s or j < min_j_s or j > max_j_s
        was_pixel = lambda p: p in image or outside(p[0], p[1])
    else:
        was_pixel = lambda p: p in image

    new_image = set()
    for i in range(min_i_s - 1, max_i_s + 2):
        for j in range(min_j_s - 1, max_j_s + 2):
            pixel = (i, j)
            bits = "".join(["1" if was_pixel(p) else "0" for p in square_pixels(pixel)])
            decimal = int(bits, 2)
            if algorithm[decimal] == "#":
                new_image.add(pixel)

    return new_image


def pixels_count(input=parse(), tick=2):
    algorithm, image = input

    for tick in range(tick):
        image = enhance(algorithm, image, tick)

    return len(image)


# Tests
test_input = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
""".strip()
assert_eq(35, pixels_count(parse(test_input)))
assert_eq(3351, pixels_count(parse(test_input), 50))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = pixels_count()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = pixels_count(tick=50)
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
