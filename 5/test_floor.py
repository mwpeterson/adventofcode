import floor

def test_find_vents():
    file = "test.txt"
    assert floor.find_vents((10,10), file) == (5, 12)
