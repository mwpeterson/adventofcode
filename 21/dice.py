from turtle import st



def dice(n):
    i = 0
    def roll(m=1):
        nonlocal i
        if m == 0:
            return i
        i += 3
        a = (i-2) % n or n
        b = (i-1) % n or n
        c = (i) % n or n
        return (a, b, c)
    return roll

def qdice():
    dice = []
    for a in range(1,4):
        for b in range(1,4):
            for c in range(1,4):
                s = a+b+c
                dice.append(s)
    def roll(m=1):
        nonlocal dice
        return dice
    return roll

file = 'test'
# part 1
pos = ['']
with open(file) as f:
    for line in f:
        pos.append(int(line.strip().split(': ')[1]))

board = 10
score = ['', 0, 0]
roll = dice(100)

while True:
#for _ in range(0,4):
    try:
        for player in [1,2]:
            move = sum(roll())
            new_pos = (pos[player] + move) % board
            pos[player] = new_pos or 10
            score[player] += pos[player]
            #print(f'Player {player} rolls {move} and moves to space {pos[player]} for a total score of {score[player]}')
            if score[player] >= 1000:
                raise StopIteration
    except StopIteration:
        break
print(min(score[1:])*roll(0))

# part2
start = ['']
with open(file) as f:
    for line in f:
        start.append(int(line.strip().split(': ')[1]))

pos = start
board = 10
score = ['', 0, 0]
roll = qdice()
print(roll())
print(roll())
print(roll())
print(roll())
roll = qdice()
games = 0
for a in roll():
    for b in roll():
        #print(a,b)
        games += 1
print(games)
for move in range(3,10):
    pos = start
    num_moves = 0
    board = 10
    score = ['', 0, 0]
    for _ in range(0,9):
        try:
            for player in [1,2]:
                num_moves += 1
                new_pos = (pos[player] + move) % board
                pos[player] = new_pos or 10
                score[player] += pos[player]
                print(f'Player {player} rolls {move} and moves to space {pos[player]} for a total score of {score[player]}')
                if score[player] >= 21:
                    raise StopIteration
        except StopIteration:
            print(f'roll: {move} num_moves:{num_moves}')
            break
print(*score)
print(*pos)

