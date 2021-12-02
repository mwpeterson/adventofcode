import sys
sys.path.append("..")
from aoc import read_input
import dive


def test_dive():

    data = read_input("test.txt", str)

    assert dive.dive(data) == 150
    assert dive.aim(data) == 900