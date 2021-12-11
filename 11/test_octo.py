import numpy as np
import octo


def test_count_100():
    data = np.genfromtxt('test', delimiter=1, dtype=int)
    assert octo.count_100(data) == 1656


def test_count_all():
    data = np.genfromtxt('test', delimiter=1, dtype=int)
    assert octo.count_100(data) == 1656
    assert octo.count_all(data) == 195