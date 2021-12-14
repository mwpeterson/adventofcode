from collections import defaultdict
from timeit import default_timer as timer
from datetime import timedelta

t_start = timer()

def step(pairs):
    new = defaultdict(int)
    for p in pairs:
        for k in ((p[0],rules[p]), (rules[p],p[1])):
            new[k] += pairs[p]
    return new

def score(pairs):
    elements = defaultdict(int)
    for (k,v) in pairs.items():
        for e in k:
            elements[e] += v
    min, *_, max = sorted(elements.values())
    return round((max-min+.5)/2)

file = 'input'
with open(file) as f:
    rules = [f.strip() for f in list(f)]

template = rules[0]
pairs = {(template[i],e):1 for (i,e) in enumerate(template[1:])}
rules = {tuple(list(a)): b for (a, b) in [r.split(' -> ') for r in rules[2:]]}

t_load = timer()

for _ in range(0,10):
    pairs = step(pairs)
print(score(pairs))

t_one = timer()

for _ in range(10,40):
    pairs = step(pairs)
print(score(pairs))

t_two = timer()

print("load: {} µs".format(round(timedelta(seconds=t_load - t_start).total_seconds() *1000*1000, 2)))
print("part1: {} µs".format(round(timedelta(seconds=t_one - t_load).total_seconds() *1000*1000, 2)))
print("part2: {} µs".format(round(timedelta(seconds=t_two - t_one).total_seconds() *1000*1000, 2)))
print("total: {} µs".format(round(timedelta(seconds=t_two - t_start).total_seconds() *1000*1000, 2)))
