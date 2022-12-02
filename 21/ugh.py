from collections import defaultdict
from re import S
count = defaultdict(int)
for a in range(1,4):
    for b in range(1,4):
        for c in range(1,4):
            s = a+b+c
            print(f'({a},{b},{c}): {s}')
            count[s] += 1
print(count)