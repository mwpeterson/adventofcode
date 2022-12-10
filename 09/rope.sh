#!/usr/bin/env bash

head=(0 0)
tail=(0 0)
min_x=0
max_x=0
min_y=0
max_y=0
visited=" "
while read -r line; do
  line=($line)
  echo "${line[0]}:${line[1]}"
  for (( x=1; x<= ${line[1]}; x++ )); do
    case ${line[0]} in 
      R)
	((head[1]+=1))
	;;
      L)
	((head[1]-=1))
	;;
      U)
	((head[0]+=1))
	;;
      D)
	((head[0]-=1))
	;;
    esac
    echo -n "h:${head[@]} "
    if (( tail[1] <= head[1] - 2 )); then
      if (( tail[0] != head[0] )); then
	echo -n " A "
	((tail[0]=head[0]))
      else
	echo -n " a "
      fi
      ((tail[1]+=1))
    elif (( tail[1] >= head[1] + 2 )); then
      if (( tail[0] != head[0] )); then
	echo -n " B "
	((tail[0]=head[0]))
      else
	echo -n " b "
      fi
      ((tail[1]-=1))
    elif (( tail[0] <= head[0] - 2 )); then
      if (( tail[1] != head[1] )); then
	echo -n " C "
	((tail[1]=head[1]))
      else
	echo -n " c "
      fi
      ((tail[0]+=1))
    elif (( tail[0] >= head[0] + 2 )); then
      if (( tail[1] != head[1] )); then
	echo -n " D "
	((tail[1]=head[1]))
      else
	echo -n " d "
      fi
      ((tail[0]-=1))
    fi
    visited+=" ${tail[0]}:${tail[1]} "
    if (( tail[0] > max_x )); then
      ((max_x=tail[0]))
    elif (( tail[0] < min_x )); then
      ((min_x=tail[0]))
    elif (( tail[1] > max_y )); then
      ((max_y=tail[1]))
    elif (( tail[1] < min_y )); then
      ((min_y=tail[1]))
    fi
    echo "t:${tail[@]}"
  done
done < $1
part1=0
echo $visited
echo "min: $min_x/$min_y"
for (( x=min_x; x<=max_x; x++ )); do
  for (( y=min_y; y<=max_y; y++ )); do
    if [[ "$visited" =~ " $x:$y " ]]; then
      echo "v: $x:$y"
      ((part1+=1))
    fi
  done
done
echo "max: $max_x/$max_y"
echo $part1
