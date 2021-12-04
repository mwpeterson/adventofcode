import pandas as pd
import numpy as np

def diag(df):
    df_neg = df.replace(0, -1)

    maxbit = df_neg.sum(axis=0)

    maxbit.mask(maxbit == 0, 1, inplace=True)
    maxbit.mask(maxbit < 0, 0, inplace=True)
    maxbit.mask(maxbit > 0, 1, inplace=True)

    gamma = ''.join(str(e) for e in maxbit)

    minbit = df_neg.sum(axis=0)

    minbit.mask(minbit > 0, 0, inplace=True)
    minbit.mask(minbit < 0, 1, inplace=True)

    epsilon = ''.join(str(e) for e in minbit)

    power = int(gamma,2) * int(epsilon,2)

    # calculate oxygen
    keep = df
    bits = maxbit

    for i in range(len(bits)):
        keep = keep[keep.iloc[:,i] == bits[i]].copy()
        keep_neg= keep.replace(0, -1)
        bits = keep_neg.sum(axis=0)
        bits.mask(bits == 0, 1, inplace=True)
        bits.mask(bits < 0, 0, inplace=True)
        bits.mask(bits > 0, 1, inplace=True)
        if len(keep) == 1:
            break

    oxygen = ''.join(str(e) for e in keep.iloc[0])

    keep = df
    bits = minbit

    for i in range(len(bits)):
        keep = keep[keep.iloc[:,i] == bits[i]].copy()
        keep_neg= keep.replace(0, -1)
        newbits = keep_neg.sum(axis=0)
        newbits.mask(newbits > 0, 0, inplace=True)
        newbits.mask(newbits < 0, 1, inplace=True)
        bits[i+1] = newbits[i+1]
        if len(keep) == 1:
            break

    co2 = ''.join(str(e) for e in keep.iloc[0])

    life = int(oxygen,2) * int(co2,2)
    return (power, life)

def main():
    df = pd.read_fwf("input.txt", widths=np.repeat(1,12), header=None)
    (power, life) = diag(df)
    print(power)
    print(life)


if __name__ == "__main__":
    main()
