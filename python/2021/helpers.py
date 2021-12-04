def assert_eq(expected, value):
    assert expected == value, f"Expected {expected}, got {value}"


def flatten(t):
    return [item for sublist in t for item in sublist]
