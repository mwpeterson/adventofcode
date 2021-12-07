from numpy import *
from timeit import default_timer as timer
from datetime import timedelta

def align(data):
    naive = int(sum(abs(data - median(data))))
    gauss = lambda x: x * (x+1) // 2
    fuel = (abs(data - floor(mean(data))), 
            abs(data - ceil(mean(data))))

    correct = int(min(sum(gauss(fuel[0])),sum(gauss(fuel[1]))))
    return (naive, correct)


def main():
    start = timer()
    crabs = loadtxt('input', delimiter=',', dtype=int64)
    load = timer()
    print(align(crabs))
    end = timer()

    print("loadtxt: {} ms".format(timedelta(seconds=load - start).total_seconds() *1000))
    print("total compute: {} μs".format(timedelta(seconds=end - load).total_seconds() * 1000*1000))
    print("overall: {} ms".format(timedelta(seconds=end - start).total_seconds() *1000))


if __name__ == '__main__':
    main()
