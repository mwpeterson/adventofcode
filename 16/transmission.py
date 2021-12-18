from functools import reduce
def packet(t):
    i = 0
    def bits(n):
        nonlocal i
        j = i+n if isinstance(n, int) else n
        ret = t[i:j]
        _l = ret != ''
        _n = len(ret) == n
        _z = t[i:] != '0'*len(t[i:])
        i = j
        return ret if _l and _n and _z else None
    return bits

version_sum = 0
def versions(v):
    global version_sum
    version_sum += v



def op_parse(i, literals):
    if i == 0: # sum
        ret = sum(literals)
        return ret
    elif i == 1: # product
        ret = 1
        for l in literals:
            ret *= l
        return ret
    elif i == 2: # minimun
        ret = min(literals)
        return ret
    elif i == 3: # maximum
        ret = max(literals)
        return ret
    elif i == 5: # greater than
        ret = 1 if literals[0] > literals[1] else 0
        return ret
    elif i == 6: # less than
        ret = 1 if literals[0] < literals[1] else 0
        return ret
    elif i == 7: # equal
        ret = 1 if literals[0] == literals[1] else 0
        return ret
    else:
        raise Exception('op_parse: unknown op {}'.format(i))

def parse(p):
    v = p(3)
    if v == None:
        return
    version = int(v, 2)
    versions(version)
    type_id = int(p(3), 2)
    if type_id == 4: # literal value
        mark = 1
        number = ''
        while mark != 0:
            group = p(5)
            if group == None:
                mark = 0
            else:
                mark = int(group[0])
                bits = group[1:]
                number += bits
        return(int(number, 2))
    ltype_id = int(p(1), 2)
    spv = []
    if ltype_id == 0:
        length = int(p(15),2)
        sp = p(length)
        if sp == None:
            return
        v = parse(packet(sp))
        spv.append(v)
        #parse(p)
    elif ltype_id == 1:
        length = int(p(11),2)
        for _ in range(0,length):
            v = parse(p)
            spv.append(v)
        #parse(p)
    else:
        raise Exception('length_id {} not 0 or 1'.format(ltype_id))
    print(type_id, spv)
    return(op_parse(type_id, spv))

#t = '110100101111111000101000'
#t = '00111000000000000110111101000101001010010001001000000000'
#t = '11101110000000001101010000001100100000100011000001100000'


file = 'input'
with open(file) as f:
    line = f.readline().strip()
t = bin(int(line, 16))[2:]

#line = '8A004A801A8002F478'
#line = '620080001611562C8802118E34'
#line = 'C0015000016115A2E0802F182340'
#line = 'A0016C880162017C3686B18A3D4780'
#line = 'C200B40A82' # finds the sum of 1 and 2, resulting in the value 3.
#line = '04005AC33890' # finds the product of 6 and 9, resulting in the value 54.
#line = '880086C3E88112' # finds the minimum of 7, 8, and 9, resulting in the value 7.
#line = 'CE00C43D881120' # finds the maximum of 7, 8, and 9, resulting in the value 9.
#line = 'D8005AC2A8F0' # produces 1, because 5 is less than 15.
#line = 'F600BC2D8F' # produces 0, because 5 is not greater than 15.
#line = '9C005AC2F8F0' # produces 0, because 5 is not equal to 15.
line = '9C0141080250320F1802104A08' #produces 1, because 1 + 3 = 2 * 2.
t = bin(int(line.strip(), 16))[2:]
while len(t) < 4 * len(line):
    t = '0' + t
parse(packet(t))
print(version_sum)