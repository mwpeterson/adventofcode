import numpy as np
n, *b = open("test.txt")
n = np.loadtxt(n.split(','), int)
b = np.loadtxt(b, int).reshape(-1,5,5)

n = np.tile(n, len(n)).reshape(len(n), len(n))             # elements of the cartesian product
n[np.triu_indices_from(n,1)] = -1                          # use -1 as "None"

a = (b == n[:,:,None,None,None]).any(1)                    # broadcast all bingo numbers
m = (a.all(-1) | a.all(-2)).any(-1)                        # check win condition
m = np.where(np.add.accumulate(m, 0) == 1, True, False)    # take first win for each board
i,j = np.argwhere(m).T                                     # get indices
ans = b[j].sum(where=~a[m], axis=(-1,-2)) * n[-1][i]       # score of each board in order of winning 
print(ans[[0,-1]])                                         # print first and last score
