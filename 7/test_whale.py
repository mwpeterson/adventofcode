import numpy as np
import whale


def test_align():
    data = np.loadtxt('test', delimiter=',', dtype=np.int64)
    assert whale.align(data) == (37, 168)
