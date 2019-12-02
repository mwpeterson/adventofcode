#!/usr/bin/env bash


target="$2"
for (( n=0; n<=99; n++ )); do
  for (( v=0; v<=99; v++ )); do

    IFS=',' read -ra intcode < $1

    intcode[1]=$n
    intcode[2]=$v

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
          if [ "$target" == "${intcode[0]}" ]; then
            echo "noun=$n; verb=$v; output=${intcode[0]}"
            echo "answer=$(( n * 100 + v ))"
            exit
          fi
          ;;
      esac
    done
  done
done
