import numpy as np
from heapq import heappush, heappop
from collections import defaultdict
from timeit import default_timer as timer
from datetime import timedelta

def neighbors(pos, end):
    (x,y) = pos
    n = (x-1 if x>0 else x,y)
    s = (x+1 if x<end[0] else x,y)
    w = (x,y-1 if y>0 else y)
    e = (x,y+1 if y<end[1] else y)
    return (n,s,w,e)

def find_path(start, end, data):
    seen = {}
    Q = []

    heappush(Q, (0, start))

    while Q:
        (d, u) = heappop(Q)
        if u in seen:
            continue
        if u == end:
            return d
        seen[u] = True
        for v in set(c for c in neighbors(u, end) if c not in seen):
            risk = data[v]
            heappush(Q, (d + risk, v))
    else:
        return np.inf
data = np.genfromtxt('input', delimiter=1, dtype=int)

t_start = timer()

start = (0,0)
end = tuple(np.subtract(data.shape, (1,1)))

t_load = timer()

print(find_path(start, end, data))

t_one = timer()

large = data.copy()
new = data.copy()
for _ in range(0,4):
    new += 1
    new[new == 10] = 1
    large = np.hstack((large, new.copy()))
new = large.copy()  
for _ in range(0,4):
    new += 1
    new[new == 10] = 1
    large = np.vstack((large, new.copy()))
end = tuple(np.subtract(large.shape, (1,1)))

t_expand = timer()

print(find_path(start, end, large))

t_end = timer()

print("load: {} ms".format(round(timedelta(seconds=t_load - t_start).total_seconds()*1000, 2)))
print("part1: {} ms".format(round(timedelta(seconds=t_one - t_load).total_seconds()*1000, 2)))
print("expand map: {} ms".format(round(timedelta(seconds=t_expand - t_one).total_seconds()*1000, 2)))
print("part2: {} ms".format(round(timedelta(seconds=t_end - t_expand).total_seconds()*1000, 2)))
print("overall: {} ms".format(round(timedelta(seconds=t_end - t_start).total_seconds()*1000, 2)))
