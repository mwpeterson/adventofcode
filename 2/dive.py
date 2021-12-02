import sys
sys.path.append("..")
from aoc import read_input


def dive(lst):
    h = 0
    v = 0
    for i in range(len(lst)):
        (d, n) = lst[i].split()
        if d == 'forward':
            h += int(n)
        elif d == 'up':
            v -= int(n)
        elif d == 'down':
            v += int(n)
        else:
            raise ValueError('Invalid direction: ' + d)
    return h*v

def aim(lst):
    h = 0
    v = 0
    a = 0
    for i in range(len(lst)):
        (d, n) = lst[i].split()
        if d == 'forward':
            h += int(n)
            v += int(n)*a
        elif d == 'up':
            a -= int(n)
        elif d == 'down':
            a += int(n)
        else:
            raise ValueError('Invalid direction: ' + d)
    return h*v

def main():
    """
    Read input from file and count the number of times the list is increasing.
    """
    data = read_input("input.txt", str)
    print(dive(data))
    print(aim(data))



if __name__ == "__main__":
    main()
