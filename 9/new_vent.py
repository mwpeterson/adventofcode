import numpy as np
from timeit import default_timer as timer
from datetime import timedelta


def count(neighbors):
    n = 1
    while len(neighbors) > 0:
        (x,y) = neighbors.pop(0)
        if floor[x,y] != 9:
            if (x,y) not in seen: n = n + 1
            seen.add((x,y))
            lx = x-1 if x>0 else x
            rx = x+1 if x<max_x-1 else x
            uy = y-1 if y>0 else y
            dy = y+1 if y<max_y-1 else y
            if (lx,y) not in seen: neighbors.append((lx,y)) 
            if (rx,y) not in seen: neighbors.append((rx,y))
            if (x,uy) not in seen: neighbors.append((x,uy))
            if (x,dy) not in seen: neighbors.append((x,dy))
        else:
            seen.add((x,y))
    return(n)


start = timer()
floor = np.genfromtxt('input', delimiter=1, dtype=int)

load = timer()

(max_x, max_y) = floor.shape
lowest = []
seen = set()
basin = {}

for n in range(0,9):
    coord = np.transpose(np.nonzero(floor==n))

    for (x,y) in coord:
        row = floor[x-1 if x>0 else x:x+2,y]
        col = floor[x, y-1 if y>0 else y:y+2]
        if np.min(row) == n and np.min(col) == n and len(row[row==n]) == 1 and len(col[col==n]) == 1:
            seen.add((x,y))
            basin[(x,y)] = 0
            lowest.append(n)

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
