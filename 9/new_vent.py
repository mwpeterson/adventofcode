import numpy as np
from timeit import default_timer as timer
from datetime import timedelta

checked = set()

def count(neighbors):
    seen = set()
    while True:
        try:
            (x,y) = neighbors.pop()
            checked.add((x,y))
            if floor[x,y] != 9:
                seen.add((x,y))
                e = x-1 if x>0 else x
                w = x+1 if x<max_x-1 else x
                n = y-1 if y>0 else y
                s = y+1 if y<max_y-1 else y
                if (e,y) not in checked: neighbors.append((e,y)) 
                if (w,y) not in checked: neighbors.append((w,y))
                if (x,n) not in checked: neighbors.append((x,n))
                if (x,s) not in checked: neighbors.append((x,s))
        except IndexError:
            return(len(seen))


start = timer()
floor = np.genfromtxt('input', delimiter=1, dtype=int)

load = timer()

(max_x, max_y) = floor.shape
basin = {}

for i in range(0,9):
    coord = np.transpose(np.nonzero(floor==i))

    for (x,y) in coord:
        e = x-1 if x>0 else x
        w = x+1 if x<max_x-1 else x
        n = y-1 if y>0 else y
        s = y+1 if y<max_y-1 else y
        neighbors = {(e,y),(w,y),(x,n),(x,s)}
        neighbors.discard((x,y))
        for p in list(neighbors):
            if i < floor[p]: neighbors.discard(p)
        if len(neighbors) == 0:
            basin[(x,y)] = i

print(np.sum(list(basin.values()))+len(basin))

lap = timer()

for (x,y) in basin:
    neighbors = [(x,y)]
    basin[(x,y)] = count(neighbors)

print(np.prod(sorted(basin.values())[-3:]))

end = timer()

print("load: {} ms".format(timedelta(seconds=load - start).total_seconds() *1000))
print("part1: {} ms".format(timedelta(seconds=lap - load).total_seconds() * 1000))
print("part2: {} ms".format(timedelta(seconds=end - lap).total_seconds() * 1000))
print("overall: {} ms".format(timedelta(seconds=end - start).total_seconds() *1000))
