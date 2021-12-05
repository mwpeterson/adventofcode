import numpy as np
from skimage.draw import line


def find_vents(dim, file):
    floor = np.zeros(dim)
    diag = np.zeros(dim)
    with open(file, 'r') as f:
        for data in f:
            (s,e) = [l.split(',') for l in data.strip().split(' -> ')]
            (s,e) = (tuple(int(i) for i in e), tuple(int(i) for i in s))
            if s[0] == e[0] or s[1] == e[1]:
                floor[line(*s,*e)] += 1
            
            diag[line(*s,*e)] += 1
    f.close()
    return(floor[floor > 1].size, diag[diag > 1].size)


def main():
    print(find_vents((1000,1000), "input.txt"))


if __name__ == '__main__':
    main()
