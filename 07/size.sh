#!/usr/bin/env bash

paths=()
while read -r line; do
  read -r arg1 arg2 arg3 <<<"$line"
  if [[ "$arg1" == "$" ]]; then
    if [[ "$arg2" == "cd" ]]; then
      p=$arg3
      if [[ "$p" == "/" ]]; then
	p="SLASH"
      fi
      if [[ "$p" == ".." ]]; then
	path="${path%_*}"
      else
	path="${path}_$p"
	paths+=($path)
	declare size$path=0
      fi
    fi
  elif [[ "$arg1" != "dir" ]]; then
    s=$arg1
    w=$path
    while [[ "$w" != "" ]]; do
      printf -v "size$w" $((size$w+s))
      w="${w%_*}"
    done
  fi
done < $1

total=70000000
unused=30000000
used=$size_SLASH
needed=$(( used - (total - unused) ))
part1=0
part2=$total
for s in ${!size*}; do
  n=${!s}
  if (( n <= 100000 )); then
    part1=$(( part1 + n ))
  fi
  if (( n >= needed )) && (( n < part2 )); then
    part2=$n
  fi
done
echo $part1
echo $part2
