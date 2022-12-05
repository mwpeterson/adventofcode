#!/usr/bin/env bash

shopt -s extglob                     # turn on extended glob

file=$1

split -p "^$" -a 1 $file

part1=""

max=0
stack=()
while read -r count; do
  for c in $count; do
    max=$c
  done
done < <(tail -1 xa)
echo $max

while IFS= read -r start; do
  for (( c=1; c<=$max; c++ )); do
    i=$(( ( c - 1 ) * 4 + 1 ))
    stack[$c]+="${start:$i:1}"
  done
done < <(tail -r xa | tail -n +2)

declare -p stack
stack=("" "${stack[@]/%+([[:blank:]])/}" ) # remove trailing space/tab from each element
declare -p stack

while read -r line; do
  read junk m junk f junk t <<< "$line"
  for (( i=1; i<=$m; i++ )); do
    from=${stack[$f]}
    to=${stack[$t]}
    stack[$t]+=${from:(-1)}
    stack[$f]=${from%?}
  done
done < <(tail -n +2 xb)
declare -p stack

for (( c=1; c<=$max; c++ )); do
  part1="$part1${stack[$c]:(-1)}"
done
echo $part1
rm xa xb
