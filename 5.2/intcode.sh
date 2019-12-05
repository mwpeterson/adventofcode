#!/usr/bin/env bash


input="$2"

IFS=',' read -ra intcode < $1

for (( i=0; i<=$(( ${#intcode[*]} - 1 )); i++ )); do
  raw=${intcode[$i]}
  mask="00000${raw}"
  instruction=${mask: -5}
  opcode=${instruction:3:2}
  mode=${instruction:0:3}
  case $opcode in
    01) # add
      p1=${intcode[$(( ++i ))]}
      p2=${intcode[$(( ++i ))]}
      p3=${intcode[$(( ++i ))]}
      [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${intcode[$p1]}
      [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${intcode[$p2]}
      intcode[$p3]=$(( r1 + r2 ))
      ;;
    02) # multiply
      p1=${intcode[$(( ++i ))]}
      p2=${intcode[$(( ++i ))]}
      p3=${intcode[$(( ++i ))]}
      [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${intcode[$p1]}
      [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${intcode[$p2]}
      intcode[$p3]=$(( r1 * r2 ))
      ;;
    03) # input
      p1=${intcode[$(( ++i ))]}
      intcode[$p1]=$input
      ;;
    04) # output
      p1=${intcode[$(( ++i ))]}
      [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${intcode[$p1]}
      printf '%s\n' $r1
      ;;
    05) # jump-if-true
      p1=${intcode[$(( ++i ))]}
      p2=${intcode[$(( ++i ))]}
      [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${intcode[$p1]}
      [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${intcode[$p2]}
      [[ $r1 -ne 0 ]] && i=$(( $r2 - 1 )) # ++ in for loop
      ;;
    06) # jump-if-false
      p1=${intcode[$(( ++i ))]}
      p2=${intcode[$(( ++i ))]}
      [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${intcode[$p1]}
      [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${intcode[$p2]}
      [[ $r1 -eq 0 ]] && i=$(( $r2 - 1 )) # ++ in for loop
      ;;
    07) # less than
      p1=${intcode[$(( ++i ))]}
      p2=${intcode[$(( ++i ))]}
      p3=${intcode[$(( ++i ))]}
      [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${intcode[$p1]}
      [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${intcode[$p2]}
      intcode[$p3]=$(( r1 < r2 ))
      ;;
    08) # equals
      p1=${intcode[$(( ++i ))]}
      p2=${intcode[$(( ++i ))]}
      p3=${intcode[$(( ++i ))]}
      [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${intcode[$p1]}
      [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${intcode[$p2]}
      intcode[$p3]=$(( r1 == r2 ))
      ;;
    99) # halt
      echo "${intcode[*]}"
      exit
      ;;
  esac
done
