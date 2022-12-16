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
	min[n]=${new_loc[n]}
	#echo "new min - n=$n: ${min[*]}"
      elif (( ${new_loc[n]} > ${max[n]} )); then
	max[n]=${new_loc[n]}
	#echo "new max - n=$n: ${max[*]}"
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
	  #echo "x:$x y:$y"
	  cave[$x,$y]='#'
	done
      done
    fi
    old_loc=(${new_loc[*]})
  done
  old_loc=()
done <$1
#declare -p min
#declare -p max
#declare -p cave
draw_cave
#exit
x=500; y=0
part1=0
max_y=${max[1]}
while (( x == 500 )); do
  for ((y=0;y<=${max[1]};y++)); do
    #echo "$x,$y: ${cave[$x,$y]}"
    next_y=$((y+1))
    left=$((x-1))
    right=$((x+1))
    if [[ "${cave[$x,$next_y]}" == 'o' || "${cave[$x,$next_y]}" == "#" ]]; then
      if [[ -z "${cave[$left,$next_y]}" ]]; then
	((x-=1))
      elif [[ -z "${cave[$right,$next_y]}" ]]; then
	((x+=1))
      else
	cave[$x,$y]='o'
	((part1+=1))
	#echo "setting $x,$y: ${cave[$x,$y]}"
	x=500
	break
      fi
    #elif [[ "${cave[$x,$next_y]}" == '#' ]]; then
    #  cave[$x,$y]='o'
    #  echo "setting $x,$y: ${cave[$x,$y]}"
    #  x=500
    #  break
    fi
  done
  #draw_cave
done
draw_cave
echo "part1: $part1"
