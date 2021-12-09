import numpy as np

def neighbors(pos):

def low(floor):
    lowest = []
    basin = []
    for n in range(0,9):
        coord = np.transpose(np.nonzero(floor==n))
        for (x,y) in coord:
            grid = floor[x-1 if x>0 else x:x+2, y-1 if y>0 else y:y+2]
            row = floor[x-1 if x>0 else x:x+2,y]
            col = floor[x, y-1 if y>0 else y:y+2]
            if np.min(row) == n and np.min(col) == n and len(row[row==n]) == 1 and len(col[col==n]) == 1:
                basin.append((x,y))
                lowest.append(n)
    for (x,y) in basin:
    return (np.sum(lowest)+len(lowest)


def main():
    floor = np.genfromtxt('test', delimiter=1, dtype=int)
    print(low(floor))

if __name__ == '__main__':
    main()