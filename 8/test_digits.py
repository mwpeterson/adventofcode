import digits

def test_search():
    with open("test") as f:
        lines = f.readlines()
    f.close
    assert digits.search(lines) == (26, 61229)