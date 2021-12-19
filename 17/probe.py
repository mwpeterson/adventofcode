from re import search

file = 'input'
with open(file) as f:
    line = f.readline()

m = search(r"x=(.+)\.\.(.*), y=(.+)\.\.(.*)", line)
(x1, x2, y1, y2) = m.groups()
X = (int(x1), int(x2)); Y = (int(y1), int(y2))

S = (0, 0)

def launch(S, v):
    p = list(S)
    v = list(v)
    is_max = max_y()
    def move():
        nonlocal p
        nonlocal v
        p[0] += v[0]
        p[1] += v[1]
        is_max(p)
        if v[0] > 0:
            v[0] -= 1
        elif v[0] < 0:
            v[0] += 1
        v[1] -= 1
        return p
    return move

def target(X, Y):
    def is_target(m):
        in_target = m[0] >= X[0] and m[0] <= X[1] and m[1] >= Y[0] and m[1] <= Y[1]
        past_target = m[0] > X[1] or m[1] < Y[0]
        if in_target:
            return True
        elif past_target:
            raise ValueError('Passed target')
        else:
            return False
    return is_target

max = 0
def max_y():
    global max
    max = 0
    def is_max(m):
        global max
        if m[1] > max:
            max = m[1]
        return max
    return is_max

x = X[0]
min_vx = 1
while x > 0:
    min_vx += 1
    x -= min_vx

x=X[1]
max_vx = 1
while x > 0:
    max_vx += 1
    x -= max_vx

max_v = [0,0]
total_v = set()
last_max = -1
for x in range(min_vx, max_vx+1):
    for y in range(0, -Y[0]+1):
        v = [x,y]
        move = launch(S, v)
        check = target(X, Y)
        while True:
            try:
                if check(move()):
                    total_v.add(tuple(v))
                    if max > last_max:
                        last_max = max
                        max_v = [x, y]
            except ValueError as e:
                break

for x in range(min_vx, X[1]+1):
    for y in range(0,Y[0]-1,-1):
        v = [x,y]
        move = launch(S, v)
        check = target(X, Y)
        while True:
            try:
                if check(move()):
                    total_v.add(tuple(v))
                    if max > last_max:
                        last_max = max
                        max_v = [x, y]
            except ValueError as e:
                break

print(max_v, last_max, len(total_v))
