from timeit import default_timer as timer
from datetime import timedelta


# part 1
def visit1(v, walk, walks, paths):
    for e in paths[v]:
        if e == 'end':
            while v != walk[-1]:
                walk.pop()
            walk.append(e)
            walks.append(walk.copy())
            walk.pop()
            continue
        elif e.islower() and e in walk:
            continue
        while v != walk[-1]:
            walk.pop()
        walk.append(e)
        visit1(e, walk, walks, paths)
        walk.pop()


#part 2
def visit2(v, walk, walks, paths, small):
    for e in paths[v]:
        if e == 'end':
            while v != walk[-1]:
                walk.pop()
            walk.append(e)
            walks.append(walk.copy())
            walk.pop()
            continue
        elif e == 'start':
            continue
        elif e.islower():
            if small[e] == 0:
                small[e] = 1
            elif 2 in small.values():
                continue
            else:
                small[e] = 2
        while v != walk[-1]:
            walk.pop()
        walk.append(e)
        visit2(e, walk, walks, paths, small)
        s = walk.pop()
        if s in small and small[s] != 0:
            small[s] = small[s] - 1


t_start = timer()

paths = {}
small = {}
with open('input') as f:
    for line in f:
        (a,b) = line.rstrip('\n').split('-')
        if a in paths:
            paths[a].append(b)
        else:
            paths[a] = [b]
        if b in paths:
            paths[b].append(a)
        else:
            paths[b] = [a]
        if a.islower:
            small[a] = 0
        if b.islower:
            small[b] = 0

t_load = timer()

walks = []
walk = []
v = 'start'
walk.append(v)
visit1(v, walk, walks, paths)
print(len(walks))

t_lap = timer()

walks = []
walk = []
v = 'start'
walk.append(v)
visit2(v, walk, walks, paths, small)
print(len(walks))

t_end = timer()

print("part1: {} ms".format(timedelta(seconds=t_lap - t_load).total_seconds() *1000))
print("part2: {} ms".format(timedelta(seconds=t_end - t_lap).total_seconds() *1000))
