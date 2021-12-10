from collections import deque
import syntax

def test_check_syntax():
    nav = deque()
    with open('test') as f:
        for line in f:
            nav.append(deque(line.rstrip('\n')))

    assert syntax.check_syntax(nav) == (26397, 288957)