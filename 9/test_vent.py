import numpy as np
import vent

def test_vent():
    data = np.genfromtxt('test', delimiter=1, dtype=int)
    assert vent.low(data) == 15