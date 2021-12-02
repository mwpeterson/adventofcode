import depth


def test_count_increase():
    """
    Test if the count increases
    """

    data = depth.read_input("1/test.txt")

    assert depth.count_increase(data, 1) == 7
    assert depth.count_increase(data, 3) == 5
