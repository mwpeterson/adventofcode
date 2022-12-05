#!/usr/bin/env bash

shopt -s extglob                     # turn on extended glob

split -p "^$" -a 1 $1

read -r count < <(tail -1 xa)
max=${count##* }

stack1=()
while IFS= read -r start; do
  for (( c=1; c<=$max; c++ )); do
    i=$(( ( c - 1 ) * 4 + 1 ))
    stack1[$c]+="${start:$i:1}"
  done
done < <(tail -r xa | tail -n +2)

stack1=("" "${stack1[@]/%+([[:blank:]])/}" ) # remove trailing space/tab from each element

stack2=("${stack1[@]}")

while read -r line; do
  read junk m junk f junk t <<< "$line"
  # part 1 with CrateMover 9000
  for (( i=1; i<=$m; i++ )); do
    from=${stack1[$f]}
    stack1[$t]+=${from: -1}
    stack1[$f]=${from%?}
  done
  # part 2 with CrateMover 9001
  from=${stack2[$f]}
  stack2[$t]+=${from: -$m}
  stack2[$f]=${from:0:${#from}-$m}
done < <(tail -n +2 xb)

for (( c=1; c<=$max; c++ )); do
  part1+=${stack1[$c]: -1}
  part2+=${stack2[$c]: -1}
done
echo $part1
echo $part2

rm xa xb
