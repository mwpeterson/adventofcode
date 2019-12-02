#!/usr/bin/env bash


target="$2"
for (( n=0; n<=99; n++ )); do
  for (( v=0; v<=99; v++ )); do

    IFS=',' read -ra intcode < $1

    i=0
    intcode[1]=$n
    intcode[2]=$v

    for (( i=0; i<=$(( ${#intcode[*]} - 1 )); i++ )); do
      case ${intcode[$i]} in
        "1")
          p1=${intcode[$(( ++i ))]}
          #echo "p1:$p1"
          p2=${intcode[$(( ++i ))]}
          #echo "p2:$p2"
          p3=${intcode[$(( ++i ))]}
          #echo "p3:$p3"
          r1=${intcode[$p1]}
          #echo "r1:$r1"
          r2=${intcode[$p2]}
          #echo "r2:$r2"
          intcode[$p3]=$(( r1 + r2 ))
          ;;
        "2")
          p1=${intcode[$(( ++i ))]}
          #echo "p1:$p1"
          p2=${intcode[$(( ++i ))]}
          #echo "p2:$p2"
          p3=${intcode[$(( ++i ))]}
          #echo "p3:$p3"
          r1=${intcode[$p1]}
          #echo "r1:$r1"
          r2=${intcode[$p2]}
          #echo "r2:$r2"
          intcode[$p3]=$(( r1 * r2 ))
          ;;
        "99")
          if [ "$target" == "${intcode[0]}" ]; then
            echo "noun=$n; verb=$v; output=${intcode[0]}"
            echo "answer=$(( $n * 100 + $v ))"
            exit
          fi
          ;;
      esac
    done

  done
done
