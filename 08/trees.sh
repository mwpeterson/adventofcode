#!/usr/bin/env bash

shopt -s extglob

x=0
y=0
rows=()
part2=0
visible=" "
while read -r line; do
  rows+=($line)
done < $1
max_x=$(( ${#rows[*]} - 1 ))

cols=()
for (( x=0; x <= max_x; x++ )); do
  c=""
  for line in "${rows[@]}"; do
    c+=${line:x:1}
  done
  cols+=($c)
done
max_y=$(( ${#cols[*]} - 1 ))

for (( y=0; y<=max_y; y++ )); do
  echo
  echo ${rows[y]}
  echo "from the left"
  max_height=-1
  for (( x=0; x<=max_x; x++ )); do
    tree=${rows[y]:x:1} 
    echo -n "$tree@$x,$y=$max_height"
    if (( tree > max_height )); then
      visible+=" $x,$y "
      echo " visible"
      max_height=$tree
    else
      echo
    fi
  done
  echo "from the right"
  max_height=-1
  for (( x=max_x; x>=0; x-- )); do
    tree=${rows[y]:x:1} 
    echo -n "$tree@$x,$y=$max_height"
    if (( tree > max_height )); then
      visible+=" $x,$y "
      echo " visible"
      max_height=$tree
    else
      echo
    fi
  done
done
for (( x=0; x<=max_x; x++ )); do
  echo
  echo ${cols[x]}
  echo "from the top"
  max_height=-1
  for (( y=0; y<=max_y; y++ )); do
    tree=${cols[x]:y:1}
    echo -n "$tree@$x,$y=$max_height"
    if (( tree > max_height )); then
      visible+=" $x,$y "
      echo " visible"
      max_height=$tree
    else
      echo
    fi
  done
  echo "from the bottom"
  max_height=-1
  for (( y=max_y; y>=0; y-- )); do
    tree=${cols[x]:y:1}
    echo -n "$tree@$x,$y=$max_height"
    if (( tree > max_height )); then
      visible+=" $x,$y "
      echo " visible"
      max_height=$tree
    else
      echo
    fi
  done
done
echo; echo "$visible"
echo
part1=0
for (( x=0; x<=max_x; x++ )); do
  for (( y=0; y<=max_y; y++ )); do
    if [[ "$visible" =~ " $x,$y " ]]; then
      part1=$(( part1 + 1 ))
      echo -n '+'
    else
      echo -n ' '
    fi
  done
  echo
done
echo $part1
