#!/usr/bin/env bash

IFS=',' read -ra intcode < $1

i=0

for (( i=0; i<=$(( ${#intcode[*]} - 1 )); i++ )); do
  opcode=$i
  p1=${intcode[$(( ++i ))]}
  p2=${intcode[$(( ++i ))]}
  p3=${intcode[$(( ++i ))]}
  r1=${intcode[$p1]}
  r2=${intcode[$p2]}
  case ${intcode[$opcode]} in
    "1")
      intcode[$p3]=$(( r1 + r2 ))
      ;;
    "2")
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
