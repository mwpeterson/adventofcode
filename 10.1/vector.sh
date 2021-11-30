#!/usr/bin/env bash

declare -A atan count
declare -a rock

best_count=
best_loc=
c=0
while read -r line; do
  [[ "$line" =~ ${line//?/(.)} ]]          # splits into array
  declare -a row=( "${BASH_REMATCH[@]:1}" ) # copy array for later
  for (( r=0; r<${#row[*]}; r++ )); do
    if [[ ${row[$r]} == '#' ]]; then
      rock+=("$r,$c")
    fi
  done
  c=$(( c + 1 ))
done < $1
for i in "${rock[@]}"; do
  IFS=',' read -ra p1 <<< "$i"
  for j in "${rock[@]}"; do
    if [[ $i == $j ]]; then
      continue
    fi
    IFS=',' read -ra p2 <<< "$j"
    y=$(( p1[1] - p2[1] ))
    x=$(( p1[0] - p2[0] ))
    vec=
    if (( x == 0 && y > 0)); then
      vec=="$( bc -l <<< "4*a(1)/2" )"
    elif(( x == 0 && y < 0)); then
      vec="$( bc -l <<< "-4*a(1)/2" )"
    elif(( x < 0 && y < 0)); then
      vec="$( bc -l <<< "a($y/$x)-4*a(1)" )"
    elif(( x < 0 && y >= 0)); then
      vec="$( bc -l <<< "a($y/$x)+4*a(1)" )"
    else
      vec="$( bc -l <<< "a($y/$x)" )"
    fi
    [[ ! ${atan[$i]} =~ "=$vec" ]] && count[$i]=$(( count[$i] + 1 ))
    atan[$i]+="$j=$vec "
    if (( best_count < count[$i] )); then
      best_count=${count[$i]}
      best_loc=$i
    fi
  done
done
echo "best: $best_count @ $best_loc"
