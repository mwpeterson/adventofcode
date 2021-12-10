from timeit import default_timer as timer
from datetime import timedelta

def check_syntax(nav):
    score = 0
    auto = []
    opener = set(['(', '[', '{', '<'])
    closer = set([')', ']', '}', '>'])
    match = {'(': ')', '[': ']', '{': '}', '<': '>'}
    scoring = {'(': 1, '[': 2, '{': 3, '<': 4, ')': 3, ']': 57, '}': 1197, '>': 25137}
    for line in nav:
        syntax = []
        for c in line:
            if c in opener:
                syntax.append(c)
            elif c in closer:
                d = syntax.pop()
                if c != match[d]:
                    score = score + scoring[c]
                    break
        else:
            complete = 0
            for m in syntax[::-1]:
                complete = 5*complete + scoring[m]
            auto.append(complete)
            continue
    return (score, sorted(auto)[len(auto)//2])


def main():
    start = timer()
    nav = []
    with open('input') as f:
        for line in f:
            nav.append(line.rstrip('\n'))
    load = timer()
    print(check_syntax(nav))
    end = timer()

    print("load: {} µs".format(timedelta(seconds=load - start).total_seconds() *1000*1000))
    print("calculate: {} µs".format(timedelta(seconds=end - load).total_seconds() * 1000*1000))
    print("overall: {} µs".format(timedelta(seconds=end - start).total_seconds() *1000*1000))


if __name__ == '__main__':
    main()