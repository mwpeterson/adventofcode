import numpy as np
from timeit import default_timer as timer
from datetime import timedelta


def search(lines):
    part_1 = 0
    part_2 = 0

    for l in lines:
        (signals, outputs) = l.split(" | ")
        signals = np.array([''.join(sorted(s)) for s in signals.split()])
        outputs = np.array([''.join(sorted(s)) for s in outputs.split()])
        part_1 = part_1 + outputs[np.char.str_len(outputs) == 2].size
        part_1 = part_1 + outputs[np.char.str_len(outputs) == 3].size
        part_1 = part_1 + outputs[np.char.str_len(outputs) == 4].size
        part_1 = part_1 + outputs[np.char.str_len(outputs) == 7].size

        signal = np.empty(10, dtype="U7")
        signal[1] = signals[np.char.str_len(signals) == 2][0]
        signal[4] = signals[np.char.str_len(signals) == 4][0]
        signal[7] = signals[np.char.str_len(signals) == 3][0]
        signal[8] = signals[np.char.str_len(signals) == 7][0]
        for a in signals[np.char.str_len(signals) == 6]:
            a_list = np.array(list(a))
            if a_list[np.isin(a_list, np.array(list(signal[4]))) == True].size == 4:
                signal[9] = a
            elif a_list[np.isin(a_list, np.array(list(signal[1]))) == True].size == 2:
                signal[0] = a
            else:
                signal[6] = a
        for a in signals[np.char.str_len(signals) == 5]:
            a_list = np.array(list(a))
            six_list = np.array(list(signal[6]))
            if a_list[np.isin(a_list, np.array(list(signal[1]))) == True].size == 2:
                signal[3] = a
            elif six_list[np.isin(six_list, a_list) == True].size == 5:
                signal[5] = a
            else:
                signal[2] = a
        part_2 = part_2 + int(''.join(map(str,[np.where(signal == o)[0][0] for o in outputs])))

    return(part_1, part_2)


def main():
    start = timer()
    with open("input") as f:
        lines = f.readlines()
        
    load = timer()
    print(search(lines))
    end = timer()

    print("load: {} ms".format(timedelta(seconds=load - start).total_seconds() *1000))
    print("total compute: {} ms".format(timedelta(seconds=end - load).total_seconds() * 1000))
    print("overall: {} ms".format(timedelta(seconds=end - start).total_seconds() *1000))



if __name__ == '__main__':
    main()
