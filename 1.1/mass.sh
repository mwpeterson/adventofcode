#!/usr/bin/env bash

fuel=0
while read -r mass; do
  fuel=$(( fuel + mass / 3 - 2))
done < $1
echo $fuel
