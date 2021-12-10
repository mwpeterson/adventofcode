from collections import deque
from statistics import median
from timeit import default_timer as timer
from datetime import timedelta

def check_syntax(nav):
    score = 0
    auto = []
    while True:
        try:
            line = nav.pop()
            syntax = deque()

            while True:
                try:
                    c = line.popleft()
                    if c == '(':
                        syntax.append(c)
                    elif c == ')':
                        d = syntax.pop()
                        if d != '(':
                            raise ValueError(c)
                    elif c == '[':
                        syntax.append(c)
                    elif c == ']':
                        d = syntax.pop()
                        if d != '[':
                            raise ValueError(c)
                    elif c == '{':
                        syntax.append(c)
                    elif c == '}':
                        d = syntax.pop()
                        if d != '{':
                            raise ValueError(c)
                    elif c == '<':
                        syntax.append(c)
                    elif c == '>':
                        d = syntax.pop()
                        if d != '<':
                            raise ValueError(c)
                except ValueError as e:
                    if e.args[0] == ')':
                        score = score + 3
                    elif e.args[0] == ']':
                        score = score + 57
                    elif e.args[0] == '}':
                        score = score + 1197
                    elif e.args[0] == '>':
                        score = score + 25137
                    break
                except IndexError:
                    complete = 0
                    while True:
                        try:
                            m = syntax.pop()
                            if m == '(':
                                complete = 5*complete + 1
                            elif m == '[':
                                complete = 5*complete + 2
                            elif m == '{':
                                complete = 5*complete + 3
                            elif m == '<':
                                complete = 5*complete + 4
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

    print("load: {} ms".format(timedelta(seconds=load - start).total_seconds() *1000))
    print("calculate: {} ms".format(timedelta(seconds=end - load).total_seconds() * 1000))
    print("overall: {} ms".format(timedelta(seconds=end - start).total_seconds() *1000))


if __name__ == '__main__':
    main()