import numpy as np


def spawn(bins, days):
    for _ in range(days):
        bins = np.append(bins, bins[0])
        bins[7] += bins[0]
        bins = bins[1:]
    return bins.sum()


def main():
    data = np.loadtxt('input.txt', delimiter=',', unpack=True, dtype=np.int64)
    bins = np.bincount(data, minlength=9)
    print(spawn(bins, 80))
    print(spawn(bins, 256))


if __name__ == '__main__':
    main()