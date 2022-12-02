#!/usr/bin/env bash

file=$1

total1=0
total2=0
while read -r them me; do
  case $them in
    A)
      case $me in
	X)
	  shape=1;outcome=3
	  pick=3;end=0
	  ;;
	Y)
	  shape=2;outcome=6
	  pick=1;end=3
	  ;;
	Z)
	  shape=3;outcome=0
	  pick=2;end=6
	  ;;
      esac
      ;;
    B)
      case $me in
	X)
	  shape=1;outcome=0
	  pick=1;end=0
	  ;;
	Y)
	  shape=2;outcome=3
	  pick=2;end=3
	  ;;
	Z)
	  shape=3;outcome=6
	  pick=3;end=6
	  ;;
      esac
      ;;
    C)
      case $me in
	X)
	  shape=1;outcome=6
	  pick=2;end=0
	  ;;
	Y)
	  shape=2;outcome=0
	  pick=3;end=3
	  ;;
	Z)
	  shape=3;outcome=3
	  pick=1;end=6
      esac
      ;;
  esac
  total1=$((total1 + shape + outcome))
  total2=$((total2 + pick + end))
done < $file
echo "total1: $total1"
echo "total2: $total2"
