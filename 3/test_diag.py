import pandas as pd
import numpy as np
import diag


def test_diag():
    df = pd.read_fwf("test.txt", widths=np.repeat(1,5), header=None)
    print(diag.diag(df))
    assert diag.diag(df) == (198, 230)
