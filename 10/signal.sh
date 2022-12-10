#!/usr/bin/env bash

X=1
cycle=1
signal=0
while read -r line; do
  line=($line)
  case ${line[0]} in
    noop)
      ((cycle+=1))
      for c in 20 60 100 140 180 220; do
	if (( cycle == c )); then
	  ((signal+=cycle*X))	    
	  echo "$((cycle * X))@$cycle"
	fi
      done
      ;;
    addx)
      ((cycle+=1))
      for c in 20 60 100 140 180 220; do
	if (( cycle == c )); then
	  ((signal+=cycle*X))	    
	  echo "$((cycle * X))@$cycle"
	fi
      done
      ((X+=line[1]))
      ((cycle+=1))
      for c in 20 60 100 140 180 220; do
	if (( cycle == c )); then
	  ((signal+=cycle*X))	    
	  echo "$((cycle * X))@$cycle"
	fi
      done
      ;;
  esac
done < $1
echo $signal
