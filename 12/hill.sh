#!/usr/bin/env bash

rows=($(<$1))
declare -A map
for (( r=0; r<${#rows[*]}; r++ )); do
  row=${rows[$r]}
  [[ "$row" =~ ${row//?/(.)} ]]
  declare -a cols=( "${BASH_REMATCH[@]:1}" )
  for (( c=0; c<${#cols[*]}; c++ )); do
    e=${cols[$c]}
    if [[ $e == 'S' ]]; then
      S=($r $c)
    elif [[ $e == 'E' ]]; then
      E=($r $c)
    fi
    map["$r,$c"]=$e
  done
done

set -x

max_r=$((${#rows[*]}-1))
max_c=$((${#cols[*]}-1))
s="${S[0]},${S[1]}"
e="${E[0]},${E[1]}"
path=$s
h='S'
L=(${S[*]})
visit=" $s "
while [[ "${L[*]}" != "${E[*]}" ]]; do
  x=${L[0]}
  y=${L[1]}
  d=($((x-1)) $y $((x+1)) $y $x $((y-1)) $x $((y+1)))
  for ((xx=0; xx<${#d[*]}; xx=xx+2)); do
    i=${d[xx]}
    j=${d[xx+1]}
    if (( i < 0 || j < 0 || i > max_r || j > max_c )); then
      continue
    fi
    c="$i,$j"
    m=${map[$c]}
    if [[ "$visit" =~ " $c " ]]; then
      continue
    else
      visit="$visit $c "
    fi
    next_m=$(tr "ab-yE" "Sa-z" <<<"$m")
    if [[ "$h" == "$next_m" ]]; then
      path="$path-$c"
      h=$m
      L=($i $j)
      continue 2
    fi
  done
done
