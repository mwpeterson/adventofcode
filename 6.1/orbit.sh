#!/usr/bin/env bash

count() {
  i=${map[$1]}
  count=$(( count + 1 ))
  [[ "$i" != "COM" ]] && count $i
}

declare -A map
while read -r line; do
  IFS=')' read -ra orbit <<< $line
  map[${orbit[1]}]=${orbit[0]}
done < $1

count=0
for i in "${!map[@]}"; do
  count $i
done
echo $count
