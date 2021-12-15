import numpy as np
from timeit import default_timer as timer
from datetime import timedelta


def fold_it(paper, folds):
    for f in folds:
        (d,n) = f.split('=')
        fold = [0, int(n)]
        if d == 'y':
            i = 1
            fold = np.array(fold)
        else:
            i = 0
            fold = np.array(fold[::-1])
        keep = paper[paper[:,i] < int(fold[i])]
        flip = paper[paper[:,i] > int(fold[i])]
        paper = np.unique(np.vstack((keep, abs(2*fold - flip))), axis=0)
    return paper

t_start = timer()
filename = 'input'
with open(filename, 'r') as f:
    input = list(f)
paper = np.array([[int(p) for p in c] for c in (i.split(',') for i in input if ',' in i)])
folds = [i.split()[2] for i in input if '=' in i]
t_load = timer()

paper = fold_it(paper, [folds.pop(0)])
print(len(paper))
t_one = timer()

paper = fold_it(paper, folds)
grid = np.full((max(paper[:,1])+1, max(paper[:,0])+1), ' ')
grid[paper[:,1], paper[:,0]] = 'X'

i = 0
print('')
for j in range(4,grid.shape[1]+1, (grid.shape[1]+1)//8):
    for g in grid[:,i:j]:
        print(''.join(g))
    print('')
    i = j+1
t_end = timer()

print("load: {} µs".format(round(timedelta(seconds=t_load - t_start).total_seconds() *1000*1000, 2)))
print("part1: {} µs".format(round(timedelta(seconds=t_one - t_load).total_seconds() *1000*1000, 2)))
print("part2: {} µs".format(round(timedelta(seconds=t_end - t_one).total_seconds() *1000*1000, 2)))
print("total: {} µs".format(round(timedelta(seconds=t_end - t_start).total_seconds() *1000*1000, 2)))
