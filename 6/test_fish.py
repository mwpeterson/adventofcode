import numpy as np
import fish

def test_spawn():
    data = np.loadtxt('test.txt', delimiter=',', unpack=True, dtype=np.int64)
    bins = np.bincount(data, minlength=9)
    assert fish.spawn(bins, 80) == 5934
    assert fish.spawn(bins, 256) == 26984457539    