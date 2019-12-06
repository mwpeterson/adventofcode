#!/usr/bin/env bash

# from 6.1
# recursively count orbits
#count() {
#  i=${map[$1]}
#  count=$(( count + 1 ))
#  [[ "$i" != "COM" ]] && count $i
#}

# recursively build orbit paths
find_route() {
  j=${map[$1]}
  path="$2)$j"
  [[ "$j" != "COM" ]] && find_route $j $path
}

# build a map of orbits
declare -A map
while read -r line; do
  IFS=')' read -ra orbit <<< $line
  map[${orbit[1]}]=${orbit[0]}
done < $1

# find routes from YOU->COM and SAN->COM
declare -A route
for i in YOU SAN ; do
  find_route $i $i
  route[$i]=$path
done

# find first common orbit
count=0
IFS=')'; for orbit in ${route['YOU']}; do
  if [ -z "${route['SAN']##*)$orbit)*}" ]; then
    # remove all common orbits and count what's left
    count=0
    for i in YOU SAN ; do
      # count the orbits
      IFS=')' read -ra orbits <<< "${route[$i]%%)$orbit)*}"
      count=$(( count + ${#orbits[@]} ))
    done
    break
  fi
done; unset IFS

echo $(( count - 2 )) # remove 'YOU' and 'SAN' pseudo-orbits
