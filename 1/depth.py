import sys
sys.path.append("..")
import aoc


def count_increase(lst, window):
    """
    Return the number of times the list is increasing.
    """
    count = 0
    for i in range(len(lst) - window):
        a = sum(lst[i:i+window])
        b = sum(lst[i+1:i+1+window])
        if a < b:
            count += 1
    return count


def main():
    """
    Read input from file and count the number of times the list is increasing.
    """
    data = aoc.read_input("input.txt", int)
    print(count_increase(data, 1))
    print(count_increase(data, 3))


if __name__ == "__main__":
    main()
