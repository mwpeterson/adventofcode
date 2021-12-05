import numpy as np
import pandas as pd


def check_winner(boards):
    #check rows
    try:
        rows = np.where(np.sum(boards, axis=2) == -5)[0]
    except IndexError:
        pass
    # check cols
    try:
        cols = np.where(np.sum(boards, axis=1) == -5)[0]
    except IndexError:
        pass
    return np.concatenate((rows, cols))


def bingo(draws, boards):
    seen = set()
    first = None; first_score = None
    last = None; last_score = None
    for i, draw in enumerate(draws):
        boards[boards == draw] = -1
        winner = check_winner(boards)
        if winner.any() and first is None:
            [first] = seen.symmetric_difference(winner.tolist())
            #first = boards[first,:,:].copy()
            #first[first == -1] = 0
            #first_score = draw*np.sum(first)
        if 0 in winner and 1 in winner and 2 in winner and last is None:
            last = seen.symmetric_difference(winner.tolist())
            print(last)
            [last] = last
            last = boards[last,:,:].copy()
            last[last == -1] = 0
            last_score = draw*np.sum(last)
        seen.update((winner).tolist())
        if first_score and last_score:
            return (first_score, last_score)


def main():
    file = "input.txt"
    draws = pd.read_csv(file, header=None, nrows=1).iloc[0]
    boards = list()
    with pd.read_csv(file, header=None, skiprows=2, 
        delim_whitespace=True, chunksize=5) as chunks:
        for chunk in chunks:
            boards.append(chunk.to_numpy())
    boards = np.stack(boards)
    print(bingo(draws, boards))


if __name__ == '__main__':
    main()
