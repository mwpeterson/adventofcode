#!/usr/bin/env bash

file=$1

part1=0
part2=0
while IFS="," read -r one two; do
  IFS="-" read -r a b <<< "$one"
  IFS="-" read -r c d <<< "$two"
  if (( c >= a && d <= b )) || (( a >= c && b <= d )); then
    part1=$((part1 + 1))
  fi
  if (( a >= c && a <= d )) || (( b >= c && b <= d )) || (( c >= a && c <= b )) || (( d >= a && d <= b)); then
    part2=$((part2 + 1))
  fi
done < $file
echo $part1
echo $part2
