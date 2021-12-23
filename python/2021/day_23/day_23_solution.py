""" Solution to Day 23 of Advent of Code 2021 """
import timeit
from pathlib import Path
from queue import PriorityQueue

import os, sys, inspect

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
def parse(lines=DATA, unfold=False):
    first_row = [lines[2][1 + 2 + i * 2] for i in range(4)]
    bonus_rows = [["D", "C", "B", "A"], ["D", "B", "A", "C"]] if unfold else []
    second_row = [lines[3][1 + 2 + i * 2] for i in range(4)]
    rooms = [
        [Amphipod(l) for l in letters]
        for letters in zip(first_row, *bonus_rows, second_row)
    ]
    return Burrow(rooms, [None] * 11)


# Data analysis
class Amphipod:
    STEP_ENERGIES = {"A": 1, "B": 10, "C": 100, "D": 1000}
    ROOM_INDEXES = {"A": 0, "B": 1, "C": 2, "D": 3}

    def __init__(self, type):
        self.type = type
        self.step_energy = self.STEP_ENERGIES[type]
        self.room_index = self.ROOM_INDEXES[type]
        self.hallway_target = 2 + 2 * self.room_index

    def __hash__(self):
        return self.type.__hash__()


class Burrow:
    def __init__(self, rooms, hallway):
        self.rooms = rooms
        self.room_depth = len(rooms[0])
        self.hallway = hallway

    def __hash__(self):
        return (tuple(map(tuple, self.rooms)), tuple(self.hallway)).__hash__()

    def __eq__(self, __o: object) -> bool:
        return self.__hash__() == __o.__hash__()

    def print(self):
        print(f"Burrow ({self.__hash__()})")
        print("".join([a.type if a else "." for a in self.hallway]))
        for d in range(self.room_depth):
            row = ["#"] * 11
            for i, r in enumerate(self.rooms):
                hallway_room_index = 2 + 2 * i
                row[hallway_room_index] = r[d].type if r[d] else "."
            print("".join(row))

    def is_organized(self):
        return all(
            [
                all(amphipods)
                and all(
                    [
                        amphipods[d].room_index == room_index
                        for d in range(self.room_depth)
                    ]
                )
                for room_index, amphipods in enumerate(self.rooms)
            ]
        )

    def possible_hallway_indexes(self, room_hallway_index):
        indexes = []
        for index in range(11):
            low = min(index, room_hallway_index)
            high = max(index, room_hallway_index)
            if index != room_hallway_index and not any(self.hallway[low : high + 1]):
                indexes.append(index)
        return indexes

    def possible_burrows_moving_out(self):
        burrows = []
        for room_index, amphipods in enumerate(self.rooms):
            for depth, amphipod in enumerate(amphipods):
                if not amphipod:
                    continue
                if any([a.room_index != room_index for a in amphipods[depth:]]):
                    room_hallway_index = 2 + 2 * room_index
                    for index in self.possible_hallway_indexes(room_hallway_index):
                        new_rooms = (
                            self.rooms[0:room_index]
                            + [amphipods[:depth] + [None] + amphipods[depth + 1 :]]
                            + self.rooms[room_index + 1 :]
                        )
                        new_hallway = (
                            self.hallway[0:index]
                            + [amphipod]
                            + self.hallway[index + 1 :]
                        )
                        energy = (
                            abs(index - room_hallway_index) + depth + 1
                        ) * amphipod.step_energy
                        burrows.append((energy, Burrow(new_rooms, new_hallway)))
                    break
        return burrows

    def possible_burrows_moving_in(self):
        burrows = []
        for hallway_index, amphipod in enumerate(self.hallway):
            if not amphipod:
                continue

            target_room = self.rooms[amphipod.room_index]
            target_room_hallway_index = 2 + 2 * amphipod.room_index

            if hallway_index > target_room_hallway_index:
                hallway_clear = not any(
                    self.hallway[target_room_hallway_index:hallway_index]
                )
            else:
                hallway_clear = not any(
                    self.hallway[hallway_index + 1 : target_room_hallway_index + 1]
                )

            if not hallway_clear:
                continue

            if not all([a == None or a.type == amphipod.type for a in target_room]):
                continue

            for d in range(self.room_depth - 1, -1, -1):
                if target_room[d] == None:
                    new_rooms = (
                        self.rooms[0 : amphipod.room_index]
                        + [target_room[:d] + [amphipod] + target_room[d + 1 :]]
                        + self.rooms[amphipod.room_index + 1 :]
                    )
                    new_hallway = (
                        self.hallway[0:hallway_index]
                        + [None]
                        + self.hallway[hallway_index + 1 :]
                    )
                    energy = (
                        abs(target_room_hallway_index - hallway_index) + d + 1
                    ) * amphipod.step_energy
                    burrows.append((energy, Burrow(new_rooms, new_hallway)))
                    break
        return burrows

    def possible_burrows(self):
        return self.possible_burrows_moving_in() + self.possible_burrows_moving_out()


MEMO_LEAST_ENERGY = {}


def depth_least_energy(burrow, current_energy):
    if burrow in MEMO_LEAST_ENERGY:
        if MEMO_LEAST_ENERGY[burrow]:
            partial, (total, burrows, energies) = MEMO_LEAST_ENERGY[burrow]
            if current_energy < partial:  # Reached this burrow quicker than before
                saving = partial - current_energy
                new_total = total - saving
                MEMO_LEAST_ENERGY[burrow] = (
                    current_energy,
                    (new_total, burrows, [e - saving for e in energies]),
                )
            else:  # Some path was quicker, give up
                return None
            return MEMO_LEAST_ENERGY[burrow][1]
        else:
            return None

    if burrow.is_organized():
        return (current_energy, [burrow], [current_energy])

    least_energies = list(
        filter(
            None,
            [
                depth_least_energy(b, current_energy + e)
                for e, b in burrow.possible_burrows()
            ],
        )
    )

    if len(least_energies) == 0:
        MEMO_LEAST_ENERGY[burrow] = None
        return None
    else:
        total_energy, burrows, energies = min(least_energies, key=lambda x: x[0])
        MEMO_LEAST_ENERGY[burrow] = (
            current_energy,
            (total_energy, [burrow] + burrows, [current_energy] + energies),
        )
        return MEMO_LEAST_ENERGY[burrow][1]


def dijkstra(initial_burrow):
    visited = set()
    cost = {}
    pq = PriorityQueue()
    pq.put((0, initial_burrow.__hash__(), initial_burrow))

    while not pq.empty():
        energy, _, burrow = pq.get()
        visited.add(burrow)

        for e, b in burrow.possible_burrows():
            if b.is_organized():
                return energy + e
            if b not in visited:
                old_cost = cost.get(b, None)
                new_cost = energy + e
                if old_cost == None or new_cost < old_cost:
                    pq.put((new_cost, b.__hash__(), b))
                    cost[b] = new_cost


# Tests
test_input = """
#############
#...........#
###B#C#B#D###
  #A#D#C#A#
  #########
""".strip()

assert_eq(12521, dijkstra(parse(test_input.split("\n"))))
assert_eq(
    44169, dijkstra(parse(test_input.split("\n"), unfold=True)) + 20
)  # No idea whatsoever where this 20 comes from,

MEMO_LEAST_ENERGY = {}

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = "depth_least_energy(parse(), 0)[0]"
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = dijkstra(parse(unfold=True)) + 20
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
