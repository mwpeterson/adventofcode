import sys
sys.path.append("..")
from aoc import read_input
import depth


def test_count_increase():
    """
    Test if the count increases
    """

    data = read_input("test.txt", int)

    assert depth.count_increase(data, 1) == 7
    assert depth.count_increase(data, 3) == 5
