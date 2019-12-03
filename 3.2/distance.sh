#!/usr/bin/env bash

# associative arrays to store grid and step coordinates
declare -A grid steps
# array to store intersections
declare -a intersections

# set both intersection grid and stepcount grid
#
set_grid() {
  loc="$1"; wire=$2; step=$3
  # if empty, set location to this wire
  if [ -z ${grid[$loc]} ]; then
    grid[$loc]=$wire
  # if set to other wire, set to intersection marker
  elif [ ${grid[$loc]} -ne $wire ] ; then
    grid[$loc]='X'
    intersections+=($loc)
  fi
  # if no step for this wire at location, set it
  # (ensures first visit is counted)
  if [ -z ${steps["$loc:$wire"]} ]; then
    steps["$loc:$wire"]=$step
  fi
}

# map wires onto grid and count the steps
#
# set port in "center" of grid
port_x=10000; port_y=10000
# initialize wire counter
wire=0
while read -r line; do
  # set current position at port in "center"
  pos_x=10000; pos_y=10000
  # enumerate this wire
  wire=$(( wire + 1 ))
  # reset step counter
  step=0
  # read each of our vectors
  IFS=,; for vec in $line; do
    direction=${vec:0:1}
    distance=${vec:1}
    while [ $distance -gt 0 ] ; do
      case $direction in
        R)
          pos_x=$(( pos_x + 1 ))
          ;;
        L)
          pos_x=$(( pos_x - 1 ))
          ;;
        U)
          pos_y=$(( pos_y + 1 ))
          ;;
        D)
          pos_y=$(( pos_y - 1 ))
          ;;
      esac
      step=$(( step + 1 ))
      set_grid "${pos_x}:${pos_y}" $wire $step
      distance=$(( distance - 1 ))
    done
  done; unset IFS
done < $1

# find our intersections and calculate distance and steps
#
# set fake max distance for finding minimums
min_distance=99999; min_steps=999999
distance_loc=''; steps_loc=''

# iterate over the intersections
#
for i in "${intersections[@]}"; do
  # figure out steps
  #
  total_steps=0
  # wire ends up as max wire; count backwards
  # add steps to this location for each wire to total
  for ((w=wire; w>0; w--)); do
    total_steps=$(( total_steps + steps["$i:$w"] ))
  done
  # store it if smaller
  if [ $total_steps -lt $min_steps ] ; then
    min_steps=$total_steps
    steps_loc=$i
  fi
  # figure out distance
  #
  # split x,y from location
  cross_x=${i%:*}; cross_y=${i#*:}
  # calculate Manhattan distance
  distance_x=$(( cross_x - port_x ))
  distance_x=${distance_x#-}
  distance_y=$(( cross_y - port_y ))
  distance_y=${distance_y#-}
  distance=$(( distance_x + distance_y ))
  # store it if its smaller
  if [ $distance -lt $min_distance ] ; then
    min_distance=$distance
    distance_loc=$i
  fi
done
# print our resutls
printf "min_distance: %s at %s\n" "$min_distance" "$distance_loc"
printf "min_steps: %s at %s\n" "$min_steps" "$steps_loc"
# check our solution if provided
if [ -f "$2" ]; then
  read -r sol < "$2"
  if [ $sol -eq $min_distance ]; then
    printf "%s\n" "Correct min_distance found!"
  fi
  if [ $sol -eq $min_steps ]; then
    printf "%s\n" "Correct min_steps found!"
  fi
fi
