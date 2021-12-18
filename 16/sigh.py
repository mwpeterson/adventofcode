import sys
inf = sys.argv[1] if len(sys.argv) > 1 else 'input'

ll = open(inf).read().strip()

d = bin(int(ll, 16))[2:]
while len(d) < 4 * len(ll):
    d = '0' + d

def peek(data, n):
    ret = data[0][:n]
    data[0] = data[0][n:]
    return ret

sumofversions = 0
def parse(data):
    global sumofversions

    version = int(peek(data, 3), 2)
    sumofversions += version

    tid = int(peek(data, 3), 2)
    if tid == 4:
        t = []
        while True:
            cnt, *v = peek(data, 5)
            t += v
            if cnt == '0':
                break
        return int("".join(t), 2)

    ltid = peek(data, 1)[0]
    spv = []
    if ltid == '0':
        subpacketslen = int(peek(data, 15), 2)
        subpackets = [peek(data, subpacketslen)]
        while subpackets[0]:
            spv.append(parse(subpackets))
    else:
        spv = [parse(data) for i in range(int(peek(data, 11), 2))]
    if tid == 0:
        return sum(spv)
    elif tid == 1:
        p = 1
        for x in spv:
            p *= x
        return p
    elif tid == 2:
        return min(spv)
    elif tid == 3:
        return max(spv)
    elif tid == 5:
        return int(spv[0] > spv[1])
    elif tid == 6:
        return int(spv[0] < spv[1])
    elif tid == 7:
        return int(spv[0] == spv[1])

p2 = parse([d])
print(sumofversions)
print(p2)
