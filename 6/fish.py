import numpy as np
from timeit import default_timer as timer
from datetime import timedelta


def spawn(bins, days):
    for _ in range(days):
        bins = np.append(bins, bins[0])
        bins[7] += bins[0]
        bins = bins[1:]
    return bins.sum()


def main():
    start = timer()
    data = np.loadtxt('input.txt', delimiter=',', unpack=True, dtype=np.int64)
    load = timer()
    bins = np.bincount(data, minlength=9)
    bin = timer()
    print(spawn(bins, 80))
    lap = timer()
    print(spawn(bins, 256))
    end = timer()

    print("loadtxt: {} ms".format(timedelta(seconds=load - start).total_seconds() *1000))
    print("bin: {} μs".format(timedelta(seconds=bin - load).total_seconds() * 1000*1000))
    print("80 days: {} μs".format(timedelta(seconds=lap - bin).total_seconds() * 1000*1000))
    print("256 days: {} μs".format(timedelta(seconds=end - lap).total_seconds() * 1000*1000))
    print("total compute: {} μs".format(timedelta(seconds=end - load).total_seconds() * 1000*1000))
    print("overall: {} ms".format(timedelta(seconds=end - start).total_seconds() *1000))

if __name__ == '__main__':
    main()