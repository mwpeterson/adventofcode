def to_int(a):
    b = []
    for i in a:
        try:
            b.append(int(i))
        except ValueError:
            b.append(i)
    return b

def sf_list(a):
    return to_int(list(a.replace('[','[,').replace(']',',]').split(',')))

def sf_add(a,b):
    a = ['['] + a + b + [']']
    return a

def sf_explode(a):
    t = []
    b = 0
    x = 0
    for i,v in enumerate(a):
        if v == '[':
            b += 1
        if v == ']':
            b -= 1
        if b == 5 and v == '[':
            j = [x for x, v in enumerate(a[i:]) if v == ']'][0]
            t = a[i:i+j+1]
            n = [x for x, v in enumerate(a[i+j:]) if type(v) == int]
            if (len(n) > 0):
                n = n[0]
                a[i+j+n] += t[2]
            m = [x for x, v in enumerate(a[:i]) if type(v) == int]
            if (len(m) > 0):
                m = m[-1]
                a[m] += t[1]
            a = a[:i] + [0] + a[i+j+1:]
            x = 1
            break
    return (a, x)

def sf_split(a):
    x = 0
    for i,v in enumerate(a):
        if type(v) == int and v >= 10:
            n = v//2
            m = v-n
            t = [ '[', n, m, ']' ]
            a = a[:i] + t + a[i+1:]
            x = 1
            break
    return (a, x)

def sf_mag(a):
    t = []
    b = 0
    while len(a) > 1:
        for i,v in enumerate(a):
            if v == '[':
                b += 1
            if v == ']':
                b -= 1
            if v == ']':
                t = a[i-2:i]
                m = 3*t[0] + 2*t[1]
                a = a[:i-3] + [m] + a[i+1:]
                break
    return a

file = 'input'
nums = []
with open(file) as f:
    for line in f:
        nums.append(line.strip())
#z = sf_list('[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]')
a = sf_list(nums[0])


for i in range(1,len(nums)):
    b = sf_list(nums[i])
    c = sf_add(a,b)
    while True:
        (c, x) = sf_explode(c)
        if x == 1:
            next
        else:
            (c, y) = sf_split(c)
            if x == 0 and y == 0:
                break
    a = c

a = sf_mag(a)
print(*a)
print('')

mm = 0
ms = []
for i in range(0,len(nums)):
    a = sf_list(nums[i])
    for j in range(0,len(nums)):
        if i == j:
            next
        b = sf_list(nums[j])
        c = sf_add(a,b)
        while True:
            (c, x) = sf_explode(c)
            if x == 1:
                next
            else:
                (c, y) = sf_split(c)
                if x == 0 and y == 0:
                    break
        m = sf_mag(c)
        if m[0] > mm:
            mm = m[0]
            ms = c
        a = sf_list(nums[i])
        b = sf_list(nums[j])
        c = sf_add(b,a)
        while True:
            (c, x) = sf_explode(c)
            if x == 1:
                next
            else:
                (c, y) = sf_split(c)
                if x == 0 and y == 0:
                    break
        m = sf_mag(c)
        if m[0] > mm:
            mm = m[0]
            ms = c

print('')
print(*ms)
print(mm)
