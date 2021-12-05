def assert_eq(expected, value):
    assert expected == value, f"Expected {expected}, got {value}"


def flatten(t):
    return [item for sublist in t for item in sublist]


def inclusive_range(a, b):
    return range(a, b + 1) if b > a else range(a, b - 1, -1)
