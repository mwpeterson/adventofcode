#!/usr/bin/env bash

declare -A atan count distance degree
declare -a rock

max_len=0
target_loc=
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
for i in "$2"; do
  IFS=',' read -ra p1 <<< "$i"
  for j in "${rock[@]}"; do
    if [[ $i == $j ]]; then
      continue
    fi
    IFS=',' read -ra p2 <<< "$j"
    y=$(( p1[1] - p2[1] ))
    x=$(( p1[0] - p2[0] ))
    vec=
    len="$(echo "sqrt($y^2+$x^2)" | bc -l)"
    if (( $( bc <<< "$max_len < $len" ) )); then
      max_len=$len
    fi
    distance[$j]=$len
    if (( x == 0 && y > 0)); then
      vec="$( bc -l <<< "((4*a(1)/2)/(4*a(1))*180)-90" )"
    elif(( x == 0 && y < 0)); then
      vec="$( bc -l <<< "((-4*a(1)/2)/(4*a(1))*180)+270" )"
    elif(( x < 0 && y < 0)); then
      vec="$( bc -l <<< "((a($y/$x)-4*a(1))/(4*a(1))*180)+270" )"
    elif(( x < 0 && y >= 0)); then
      vec="$( bc -l <<< "((a($y/$x)+4*a(1))/(4*a(1))*180)-90" )"
    else
      vec="$( bc -l <<< "((a($y/$x))/(4*a(1))*180)+270" )"
    fi
    [[ ! ${atan[$i]} =~ "=$vec" ]] && count[$i]=$(( count[$i] + 1 ))
    atan[$i]+="$j=$vec "
    degree[$vec]+="$j "
    if (( best_count < count[$i] )); then
      best_count=${count[$i]}
      best_loc=$i
    fi
  done
done
echo "${atan[@]}"
echo "${distance[@]}"
angles=${!degree[@]}
for i in $( sort -g <<< "${angles// /$'\n'}" ); do
  echo "$i: ${degree[$i]}"
done
c=0
while :; do
  angles=${!degree[@]}
  for i in $( sort -g <<< "${angles// /$'\n'}" ); do
    target_distance=$max_len
    for t in ${degree[$i]}; do
      #echo "${distance[$t]} < $target_distance"
      if (( $( bc <<< "${distance[$t]} < $target_distance" ) )); then
        target_loc=$t
      fi
    done
    regex="${degree[$i]}"
    degree[$i]=${regex//$target_loc /}
    c=$(( c + 1 ))
    if [[ $c -eq 200 ]]; then
      break 2
    fi
  done
  echo $c
  if [[ -z "${degree[$i]}" ]]; then
    unset degree[$i]
  fi
done
tx=${target_loc%,*}
ty=${target_loc#*,}
echo "200: $target_loc; asteroid $(( 100 * tx + ty ))"
echo "best: $best_count @ $best_loc"
