#!/usr/bin/env bash

read -r input < $1

width=25
height=6
size=$(( width * height ))
min_zero=$size
solution=0
for ((i=0; i<${#input}; i=i+size)); do
  pixel=
  image=
  for tall in {0..5}; do
    start=$((i+tall*width))
    row="${input:start:width}\n"
    pixel="$pixel$row"
  done
  zeros="${pixel//[^0]}"
  if [ ${#zeros} -lt $min_zero ]; then
    min_zero=${#zeros}
    ones="${pixel//[^1]}"
    twos="${pixel//[^2]}"
    solution=$(( ${#ones} * ${#twos} ))
  fi
done

echo $solution

#   0,  25,  50,  75, 100, 125 i=0
# 150, 175, 200, 225, 250, 275 i=150o
# start=$((tall*width+i))
