""" Solution to Day 16 of Advent of Code 2021 """
from functools import reduce
import timeit
from pathlib import Path
from operator import add
import numpy as np

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
    return list("".join([bin(int(c, 16))[2:].zfill(4) for c in data]))


# Data analysis
def consume(bits, count):
    v = bits[:count]
    del bits[:count]
    return v


def literal_value(bits):
    value_bits = []
    while consume(bits, 1) != ["0"]:
        value_bits += consume(bits, 4)
    return value_bits + consume(bits, 4)


def read_literal(bits):
    return int("".join(literal_value(bits)), 2)


def read_operator(bits):
    length_type_id = consume(bits, 1)
    if length_type_id == ["0"]:
        sub_packets_total_length = int("".join(consume(bits, 15)), 2)
        sub_packets_bits = consume(bits, sub_packets_total_length)
        return read(sub_packets_bits)
    else:
        sub_packets_count = int("".join(consume(bits, 11)), 2)
        return read(bits, sub_packets_count)


def read_body(type_id, bits):
    if type_id == 4:
        return read_literal(bits)
    else:
        return read_operator(bits)


def read_packet(bits):
    version = int("".join(consume(bits, 3)), 2)
    type_id = int("".join(consume(bits, 3)), 2)
    body = read_body(type_id, bits)
    return (version, type_id, body)


def read(bits, max_packet=None):
    packets = []
    while len(packets) < max_packet if max_packet else "1" in bits:
        packets.append(read_packet(bits))
    return packets


def version_sum(packets):
    sum = 0
    for p in packets:
        (version, _, body) = p
        sum += version
        if isinstance(body, list):
            sum += version_sum(body)
    return sum


def process(packet):
    (_, type_id, body) = packet

    if type_id == 4:
        return body

    subvalues = [process(p) for p in body]
    if type_id == 0:
        return reduce((lambda acc, v: acc + v), subvalues)
    if type_id == 1:
        return reduce((lambda acc, v: acc * v), subvalues)
    if type_id == 2:
        return min(subvalues)
    if type_id == 3:
        return max(subvalues)
    if type_id == 5:
        return subvalues[0] > subvalues[1]
    if type_id == 6:
        return subvalues[0] < subvalues[1]
    if type_id == 7:
        return subvalues[0] == subvalues[1]
    raise


# Tests
assert_eq(list("110100101111111000101000"), parse("D2FE28"))
assert_eq([(6, 4, 2021)], read(parse("D2FE28")))

assert_eq(
    list("00111000000000000110111101000101001010010001001000000000"),
    parse("38006F45291200"),
)

assert_eq([(1, 6, [(6, 4, 10), (2, 4, 20)])], read(parse("38006F45291200")))
assert_eq([(7, 3, [(2, 4, 1), (4, 4, 2), (1, 4, 3)])], read(parse("EE00D40C823060")))

assert_eq(16, version_sum(read(parse("8A004A801A8002F478"))))
assert_eq(12, version_sum(read(parse("620080001611562C8802118E34"))))
assert_eq(23, version_sum(read(parse("C0015000016115A2E0802F182340"))))
assert_eq(31, version_sum(read(parse("A0016C880162017C3686B18A3D4780"))))

assert_eq(3, process(read(parse("C200B40A82"))[0]))
assert_eq(1, process(read(parse("9C0141080250320F1802104A08"))[0]))

# Answers
PART_1_START_TIME = timeit.default_timer()
PART_1_ANS = version_sum(read(parse(DATA)))
PART_1_TIME_MS = (timeit.default_timer() - PART_1_START_TIME) * 1000

PART_2_START_TIME = timeit.default_timer()
PART_2_ANS = process(read(parse(DATA))[0])
PART_2_TIME_MS = (timeit.default_timer() - PART_2_START_TIME) * 1000

if __name__ == "__main__":
    print(f"{PART_1_ANS=}\n")
    print(f"{PART_2_ANS=}\n")

    print(f"Timed Results:\n{PART_1_TIME_MS=:.3f}\n{PART_2_TIME_MS=:.3f}\n")
