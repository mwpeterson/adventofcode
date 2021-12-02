def read_input(filename, type):
    with open(filename) as f:
        data = f.read().splitlines()
    return list(map(type, data))
