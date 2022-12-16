#!/usr/bin/env bash

draw_cave () {
  echo
  local x
  local y
  for ((y=0;y<=${max[1]};y++)); do
    for ((x=${min[0]};x<=${max[0]};x++)); do
      if [[ ! -z "${cave[$x,$y]}" ]]; then
	echo -n ${cave[$x,$y]}
      elif (( x==500 && y==0 )); then
	echo -n '+'
      else
	echo -n '.'
      fi
    done
    echo
  done
  echo
}

drop_sand () {
  while (( x == 500 )); do
    for ((y=0;y<=max[1];y++)); do
      next_y=$((y+1))
      left=$((x-1))
      right=$((x+1))
      if [[ ! -z "${cave[$x,$next_y]}" ]]; then
	if [[ -z "${cave[$left,$next_y]}" ]]; then
	  ((x-=1))
	elif [[ -z "${cave[$right,$next_y]}" ]]; then
	  ((x+=1))
	else
	  cave[$x,$y]='o'
	  ((count+=1))
	  if (( x == 500 && y == 0 )); then
	    x=0
	  else
	    x=500
	  fi
	  break
	fi
      fi
    done
    #draw_cave
  done
}

declare -A cave
old_loc=()
min=(999999 999999)
max=(0 0)
while read line; do
  path=(${line//->/ })
  for p in ${path[*]}; do
    new_loc=(${p//,/ })
    for n in 0 1; do
      if (( ${new_loc[n]} < ${min[n]} )); then
	min[$n]=${new_loc[$n]}
      elif (( ${new_loc[n]} > ${max[n]} )); then
	max[$n]=${new_loc[$n]}
      fi
    done
    if (( ${#old_loc[*]} == 0 )); then
      cave[$p]='#'
    else
      old0=${old_loc[0]}; old1=${old_loc[1]}
      new0=${new_loc[0]}; new1=${new_loc[1]}
      if (( old0 < new0 )); then
	start_x=$old0; end_x=$new0
      else
	start_x=$new0; end_x=$old0
      fi
      if (( old1 < new1 )); then
	start_y=$old1; end_y=$new1
      else
	start_y=$new1; end_y=$old1
      fi
      for ((x=start_x;x<=end_x;x++)); do
	for ((y=start_y;y<=end_y;y++)); do
	  cave[$x,$y]='#'
	done
      done
    fi
    old_loc=(${new_loc[*]})
  done
  old_loc=()
done <$1
draw_cave
count=0
x=500
drop_sand
draw_cave
echo "part1: $count"

((max[1]+=2))
((min[0]-=max[1]))
((max[0]+=max[1]))
for ((n=${min[0]};n<=${max[0]};n++)); do
  cave[$n,${max[1]}]='#'
done
x=500
drop_sand
draw_cave
echo "part2: $count"
