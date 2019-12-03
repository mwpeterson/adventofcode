#!/usr/bin/env bash

declare -A grid

set_grid() {
  loc="$1"; wire=$2
  if [ -z ${grid[$loc]} ] ; then
    grid[$loc]=$wire
  elif [ ${grid[$loc]} -ne $wire ] ; then
    grid[$loc]='X'
  fi
}

port_x=10000
port_y=10000
min_distance=99999
min_loc=''
max_distance=0
max_loc=''
wire=0
while read -r line; do
  pos_x=10000
  pos_y=10000
  wire=$(( wire + 1 ))
  IFS=,; for loc in $line; do
    vector=${loc:0:1}
    distance=${loc:1}
    case $vector in
      R)
        pos_x=$(( pos_x + 1 ))
        for ((x=pos_x; x<=$(( pos_x + distance - 1 )); x++)); do
          set_grid "${x}:${pos_y}" $wire
        done
        pos_x=$(( x - 1 ))
        ;;
      L)
        pos_x=$(( pos_x - 1 ))
        for ((x=pos_x; x>=$(( pos_x - distance + 1 )); x--)); do
          set_grid "${x}:${pos_y}" $wire
        done
        pos_x=$(( x + 1 ))
        ;;
      U)
        pos_y=$(( pos_y + 1 ))
        for ((y=pos_y; y<=$(( pos_y + distance  - 1 )); y++)); do
          set_grid "${pos_x}:${y}" $wire
        done
        pos_y=$(( y - 1 ))
        ;;
      D)
        pos_y=$(( pos_y - 1 ))
        for ((y=pos_y; y>=$(( pos_y - distance + 1 )); y--)); do
          set_grid "${pos_x}:${y}" $wire
        done
        pos_y=$(( y + 1 ))
        ;;
    esac
  done; unset IFS
done < $1
for i in "${!grid[@]}"; do
  if [ "${grid[$i]}" == "X" ] ; then
    cross_x=${i%:*}
    distance_x=$(( cross_x - port_x ))
    distance_x=${distance_x#-}
    cross_y=${i#*:}
    distance_y=$(( cross_y - port_y ))
    distance_y=${distance_y#-}
    distance=$(( distance_x + distance_y ))
    if [ $distance -lt $min_distance ] ; then
      min_distance=$distance
      min_loc=$i
    fi
    if [ $distance -gt $max_distance ] ; then
      max_distance=$distance
      max_loc=$i
    fi
  fi
done
printf "min_distance: %s at %s\n" "$min_distance" "$min_loc"
printf "max_distance: %s at %s\n" "$max_distance" "$max_loc"
if [ -f "$2" ]; then
  read -r sol_distance < "$2"
  if [ $sol_distance -eq $min_distance ]; then
    printf "%s\n" "Correct min_distance found!"
  else
    printf "wtf‽ expected distance %s, but found distance %s\n" "$sol_distance" "$min_distance"
  fi
fi
