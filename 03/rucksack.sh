#!/usr/bin/env bash

file=$1

i=1
for letter in {{a..z},{A..Z}}; do
  declare $letter=$i
  i=$((i+1))
done

pack_sum=0
badge_sum=0
while read -r elf1; read -r elf2; read -r elf3; do
  # part1
  for line in elf1 elf2 elf3; do
    pack=${!line}
    len=${#pack}
    half=$((len/2))
    comp1="${pack:0:$half}"
    comp2="${pack:$half:$len}"
    both=$(comm -12 <(printf $comp1 | fold -w1 | sort ) <(printf $comp2 | fold -w1 | sort ) | head -1)
    pack_sum=$((pack_sum + ${!both}))
  done
  # part2
  fold1=$(printf $elf1 | fold -w1 | sort -u)
  fold2=$(printf $elf2 | fold -w1 | sort -u)
  fold3=$(printf $elf3 | fold -w1 | sort -u)
  comm12=$(comm -12 <(printf "$fold1") <(printf "$fold2"))
  badge=$(comm -12 <(printf "$comm12") <(printf "$fold3"))
  badge_sum=$((badge_sum + ${!badge}))
done < $file
echo $pack_sum
echo $badge_sum
