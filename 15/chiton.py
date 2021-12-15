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

def shortest_path(prev, data):
    S = []
    u = end
    while u:
        S.append(u)
        u = prev[u]

    distance = 0
    for s in S:
        distance += data[s]
    return distance

def find_path(start, end, data):
    seen = np.zeros(data.shape, dtype=bool)
    dist = np.full(data.shape, np.inf, dtype=float)

    Q = [start]
    dist[start] = 0

    while Q:
        u = heappop(Q)
        if seen[u]:
            continue
        seen[u] = True
        for neighbor in set(c for c in neighbors(u, end) if not seen[c]):
            risk = data[neighbor]
            alt = dist[u] + risk
            if alt < dist[neighbor]:
                dist[neighbor] = alt
                heappush(Q, neighbor)

    return int(dist[end])

    #return shortest_path(prev, data) - data[start]

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

print(find_path(start, end, large))

t_end = timer()

print("load: {} ms".format(round(timedelta(seconds=t_load - t_start).total_seconds()*1000, 2)))
print("part1: {} s".format(round(timedelta(seconds=t_one - t_load).total_seconds(), 2)))
print("part2: {} s".format(round(timedelta(seconds=t_end - t_load).total_seconds(), 2)))
print("overall: {} s".format(round(timedelta(seconds=t_end - t_start).total_seconds(), 2)))
