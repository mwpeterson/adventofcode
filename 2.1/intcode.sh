#!/usr/bin/env bash

IFS=',' read -ra intcode < $1

i=0

for (( i=0; i<=$(( ${#intcode[*]} - 1 )); i++ )); do
  case ${intcode[$i]} in
    "1")
      p1=${intcode[$(( ++i ))]}
      echo "p1:$p1"
      p2=${intcode[$(( ++i ))]}
      echo "p2:$p2"
      p3=${intcode[$(( ++i ))]}
      echo "p3:$p3"
      r1=${intcode[$p1]}
      echo "r1:$r1"
      r2=${intcode[$p2]}
      echo "r2:$r2"
      intcode[$p3]=$(( r1 + r2 ))
      ;;
    "2")
      p1=${intcode[$(( ++i ))]}
      echo "p1:$p1"
      p2=${intcode[$(( ++i ))]}
      echo "p2:$p2"
      p3=${intcode[$(( ++i ))]}
      echo "p3:$p3"
      r1=${intcode[$p1]}
      echo "r1:$r1"
      r2=${intcode[$p2]}
      echo "r2:$r2"
      intcode[$p3]=$(( r1 * r2 ))
      ;;
    "99")
      if [ -f "$2" ] ; then
        IFS=',' read -ra sol_intcode < "$2"
        echo "solution:   ${sol_intcode[*]}"
      fi
      echo "calculated: ${intcode[*]}"
      exit
      ;;
  esac
done
