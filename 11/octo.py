import numpy as np
from timeit import default_timer as timer
from datetime import timedelta


def count_flash(data):
    flash = np.transpose(np.nonzero(data > 9))
    if flash.size == 0: return 0
    data[data > 9] = 0
    for (x,y) in flash:
        grid = data[x-1 if x>0 else x:x+2, y-1 if y>0 else y:y+2]
        grid[(grid < 10)&(grid > 0)] += 1
    return flash.size+count_flash(data)


def count_100(data):
    flashes = 0
    for _ in range(0,100):
        data[data < 10] += 1
        flashes = flashes + count_flash(data)//2 # why???
    return flashes

def count_all(data):
    flash = 0; i = 0
    while flash < 100:
        data[data < 10] += 1
        flash = count_flash(data)//2 # why???
        i = i +1
    return 100+i

def main():
    t_start = timer()
    data = np.genfromtxt('input', delimiter=1, dtype=int)
    t_load = timer()
    print(count_100(data))
    t_part = timer()
    print(count_all(data))
    t_end = timer()

    print("load: {} ms".format(timedelta(seconds=t_load - t_start).total_seconds() *1000))
    print("part 1: {} ms".format(timedelta(seconds=t_part - t_load).total_seconds() *1000))
    print("part 2: {} ms".format(timedelta(seconds=t_end - t_part).total_seconds() *1000))
    print("overall: {} ms".format(timedelta(seconds=t_end - t_start).total_seconds() *1000))


if __name__ == "__main__":
    main()
