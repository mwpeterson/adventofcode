import pandas as pd
import numpy as np
import bingo

def test_bingo():
    file = "test.txt"
    draws = pd.read_csv(file, header=None, nrows=1).iloc[0]
    boards = list()
    with pd.read_csv(file, header=None, skiprows=2, 
        delim_whitespace=True, chunksize=5) as chunks:
        for chunk in chunks:
            boards.append(chunk.to_numpy())
    boards = np.stack(boards)
    assert bingo.bingo(draws, boards) == (4512, 1924)