from collections import deque
from statistics import median
from timeit import default_timer as timer
from datetime import timedelta

def check_syntax(nav):
    score = 0
    auto = []
    opener = set(['(', '[', '{', '<'])
    closer = set([')', ']', '}', '>'])
    match = {'(': ')', '[': ']', '{': '}', '<': '>'}
    scoring = {'(': 1, '[': 2, '{': 3, '<': 4, ')': 3, ']': 57, '}': 1197, '>': 25137}
    while True:
        try:
            line = nav.pop()
            syntax = deque()

            while True:
                try:
                    c = line.popleft()
                    if c in opener:
                        syntax.append(c)
                    elif c in closer:
                        d = syntax.pop()
                        if c != match[d]:
                            raise ValueError(c)
                except ValueError as e:
                    score = score + scoring[e.args[0]]
                    break
                except IndexError:
                    complete = 0
                    while True:
                        try:
                            m = syntax.pop()
                            complete = 5*complete + scoring[m]
                        except IndexError:
                            auto.append(complete)
                            break
                    break
        except IndexError:
            break

    return (score, median(sorted(auto)))


def main():
    start = timer()
    nav = deque()
    with open('input') as f:
        for line in f:
            nav.append(deque(line.rstrip('\n')))
    load = timer()
    print(check_syntax(nav))
    end = timer()

    print("load: {} µs".format(timedelta(seconds=load - start).total_seconds() *1000*1000))
    print("calculate: {} µs".format(timedelta(seconds=end - load).total_seconds() * 1000*1000))
    print("overall: {} µs".format(timedelta(seconds=end - start).total_seconds() *1000*1000))


if __name__ == '__main__':
    main()