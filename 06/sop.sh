#!/usr/bin/env bash

p=0
part=(0 0 0)
nope=(0 0 0)
while read -r line; do
  for n in 4 14; do
    p=$((p+1))
    for (( i=0; i<=${#line}; i++ )); do
      buf=${line:i:$n}
      if [[ ${part[$p]} == 0 ]]; then
	nope[$p]=0
	for (( a=0; a<$n; a++ )); do
	  for (( b=$a+1; b<$n; b++ )); do
	    if [[ ${buf:$a:1} == ${buf:$b:1} ]]; then
	      nope[$p]=1
	      break 2
	    fi
	  done
	done
      fi
      if [[ ${nope[$p]} == 0 ]]; then
	part[$p]=$((i+$n))
	break
      fi
    done
  done
done < $1
echo "part1: ${part[1]}"
echo "part2: ${part[2]}"
