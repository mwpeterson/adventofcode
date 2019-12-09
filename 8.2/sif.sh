#!/usr/bin/env bash

read -r input < $1

width=25
height=6
size=$(( width * height ))
declare -a image; i=$size; while [ $i -ne 0 ]; do image+=(2); ((i--)); done
for ((r=0; r<${#input}; r=r+size)); do
  row="${input:r:size}"
  [[ "$row" =~ ${row//?/(.)} ]]          # splits into array
  declare -a pixel=( "${BASH_REMATCH[@]:1}" ) # store it
  for ((j=0; j<$size; j++)); do
    i=${image[$j]}
    p=${pixel[$j]}
    [ $i -eq 2 ] && image[$j]=${pixel[$j]}
  done
done


output=
for ((i=0; i<${#image[@]}; i=i+width)); do
  line=$(echo "${image[@]:i:width}")
  line="${line// }"
  line="${line//0/ }"
  output="$output$line\n"
done

printf "$output"
