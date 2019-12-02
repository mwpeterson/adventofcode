#!/usr/bin/env bash

total_fuel=0
while read -r mass; do
  fuel=$(( mass / 3 - 2 ))
  while [ $fuel -gt 0 ]; do
    total_fuel=$(( total_fuel + fuel ))
    fuel=$(( fuel / 3 - 2 ))
  done
done < $1
echo $total_fuel
