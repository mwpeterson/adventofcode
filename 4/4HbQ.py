from numpy import loadtxt;  n, *b = open('input.txt')

n = loadtxt(n.split(',')).reshape(-1,1,1,1)    # (numbers,1,1,1)
b = loadtxt(b).reshape(1,-1,5,5)               # (1,boards,5,5)

m = (n == b).cumsum(0)                         # (numbers,boards,5,5)
s = (n * b * (1-m)).sum((2,3))                 # (numbers,boards)
w = (m.all(2) | m.all(3)).any(2).argmax(0)     # (boards,)

print(s[w].diagonal()[w.argsort()[[0,-1]]])