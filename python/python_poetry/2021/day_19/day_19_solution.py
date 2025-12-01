""" Solution to Day 19 of Advent of Code 2021 """
import timeit
from typing import Counter
import numpy as np
from pathlib import Path
from itertools import permutations

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
    scanners_data = data.split("\n\n")
    return [Scanner(scanner_data.split("\n")) for scanner_data in scanners_data]


# Data analysis
def rot_z(alpha):
    return np.array(
        [
            [np.cos(alpha), -np.sin(alpha), 0],
            [np.sin(alpha), np.cos(alpha), 0],
            [0, 0, 1],
        ]
    ).astype(int)


def rot_y(beta):
    return np.array(
        [
            [np.cos(beta), 0, np.sin(beta)],
            [0, 1, 0],
            [-np.sin(beta), 0, np.cos(beta)],
        ]
    ).astype(int)


def rot_x(gamma):
    return np.array(
        [
            [1, 0, 0],
            [0, np.cos(gamma), -np.sin(gamma)],
            [0, np.sin(gamma), np.cos(gamma)],
        ]
    ).astype(int)


ROTATIONS_MATRICES = [
    rot_z(alpha) @ rot_y(beta) @ rot_x(gamma)
    for alpha in [0, np.pi / 2, np.pi, 3 * np.pi / 2]
    for beta in [0, np.pi / 2, np.pi, 3 * np.pi / 2]
    for gamma in [0, np.pi / 2, np.pi, 3 * np.pi / 2]
]
ROTATIONS_MATRICES = [
    ROTATIONS_MATRICES[i]
    for i in range(len(ROTATIONS_MATRICES))
    if not any(
        [np.array_equal(ROTATIONS_MATRICES[i], m) for m in ROTATIONS_MATRICES[i + 1 :]]
    )
]


class Scanner:
    def __init__(self, lines):
        self.name = lines[0]

        points = [np.array(list(map(int, l.split(",")))) for l in lines[1:]]
        self.points = points
        self.compute_distances()
        self.translation = np.array([0, 0, 0])
        self.rotation_matrix = np.diag([1, 1, 1])

    def compute_distances(self):
        self.distances = {}
        for i in range(len(self.points)):
            for j in range(i + 1, len(self.points)):
                self.distances[np.linalg.norm(self.points[j] - self.points[i])] = (
                    self.points[i],
                    self.points[j],
                )

    def overlapping_points(self, other_scanner):
        return [
            [self.distances[d], other_scanner.distances[d]]
            for d in self.distances.keys()
            if other_scanner.distances.get(d, False)
        ]

    def reconcile(self, overlapping_points):
        transformations = []
        for ref_points, points in overlapping_points:
            ref_vec = ref_points[1] - ref_points[0]
            vec = points[1] - points[0]

            rotation_matrices = list(
                filter(lambda m: np.array_equal(m @ vec, ref_vec), ROTATIONS_MATRICES)
            )
            if len(rotation_matrices) == 1:
                rotation_matrix = rotation_matrices[0]
                translation = ref_points[0] - rotation_matrix @ points[0]
                transformations.append((rotation_matrix, translation))

        s, _ = Counter([str(t) for t in transformations]).most_common(1)[0]

        self.rotation_matrix, self.translation = filter(
            lambda t: str(t) == s, transformations
        ).__next__()
        self.points = [
            (self.rotation_matrix @ p + self.translation) for p in self.points
        ]
        self.compute_distances()
        return self


def reconcile(scanners):
    reconciled_scanners = scanners[:1]
    to_reconcile_scanners = scanners[1:]
    i = 0
    while len(to_reconcile_scanners) > 0:
        scanner = reconciled_scanners[i]
        newly_reconciled_scanners = []
        for to_reconcile_scanner in to_reconcile_scanners:
            overlapping_points = scanner.overlapping_points(to_reconcile_scanner)
            if len(overlapping_points) >= (11 * 12) / 2:
                newly_reconciled_scanners.append(
                    to_reconcile_scanner.reconcile(overlapping_points)
                )

        for s in newly_reconciled_scanners:
            reconciled_scanners.append(s)
            to_reconcile_scanners.remove(s)

        i += 1

    return reconciled_scanners


def beacons_count(scanners=parse()):
    reconciled_scanners = reconcile(scanners)
    deduplicated_points = {tuple(p) for s in reconciled_scanners for p in s.points}
    return len(deduplicated_points)


def most_distant_scanners(scanners=parse()):
    reconciled_scanners = reconcile(scanners)
    distances = []
    for i in range(len(reconciled_scanners)):
        for j in range(i + 1, len(reconciled_scanners)):
            distances.append(
                np.linalg.norm(
                    reconciled_scanners[i].translation
                    - reconciled_scanners[j].translation,
                    1,
                )
            )
    return max(distances)


# Tests
test_input = """
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
""".strip()
assert_eq(79, beacons_count(parse(test_input)))
assert_eq(3621, most_distant_scanners(parse(test_input)))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = beacons_count()
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = most_distant_scanners()
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
