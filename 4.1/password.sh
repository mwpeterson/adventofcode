#!/usr/bin/env bash

# must contain at least one digit pair
# digits always increase or stay the same
#

# split string into array
explode() {
  string="$1"
  [[ "$string" =~ ${string//?/(.)} ]]          # splits into array
  printf "%s\n" "${BASH_REMATCH[@]:1}"        # loop free: reuse fmtstr
  #declare -a digits=( "${BASH_REMATCH[@]:1}" ) # copy array for later
}
min_pass=382345
max_pass=843167

pair=('00' '11' '22' '33' '44' '55' '66' '77' '88' '99')

declare -a check sieve

for (( cur=$min_pass; cur<=$max_pass; cur++ )); do
  check=( $(explode $cur) )
  l=${check[0]}
  for (( d=1; d<"${#check[*]}"; d++ )); do
    if [ "${check[$d]}" -lt "$l" ]; then
     continue 3
    fi
    l="${check[$d]}"
  done
  for (( d=0; d<"${#pair[*]}"; d++ )); do
    if [[ $cur =~ ${pair[$d]} ]]; then
      sieve+=( $cur )
      break
    fi
  done
done

printf "possible passwords: %s\n" "${#sieve[*]}"
