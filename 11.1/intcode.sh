#!/bin/bash

get_r() {
  _mode=$1
  for (( _p=1; _p<=${#p[*]}; _p++ )); do
    _m=${_mode: -1}
    _mode=${_mode:0: -1}
    echo ">>: _p:$_p _m:$_m"
    case $_m in
      2) # relative mode
        echo ">>: case 2"
        echo -n '>>: $(( base + p[$_p] )): '; echo " $base + ${p[${_p}]}: $(( base + p[$_p] ))"
        echo ">>: before: ${r[$_p]}"
        r[$_p]=${runcode[$(( base + p[$_p] ))]}
        echo ">>: after: ${r[$_p]}"
        ;;
      1) # immediate mode
        echo ">>: case 1"
        echo ">>: before: ${r[$_p]}"
        r[$_p]=${p[$_p]}
        echo ">>: after: ${r[$_p]}"
        ;;
      0) # position mode
        echo ">>: case 0"
        echo ">>: before: ${r[$_p]}"
        r[$_p]=${runcode[${p[$_p]}]}
        echo ">>: after: ${r[$_p]}"
        ;;
    esac
  done
  set_m=$_m
}

get_p() {
  _at=$1
  _count=$2
  for (( _i=1; _i<=_count; _i++ )); do
    p[$_i]=${runcode[$(( _i + _at ))]}
  done
}

IFS=',' read -ra runcode < $1

declare -a p r
base=0
declare input=( $2 $3)
for (( i=0; i<=$(( ${#runcode[*]} - 1 )); i++ )); do
  mask="00000${runcode[$i]}"
  instruction=${mask: -5}
  opcode=${instruction:3:2}
  mode=${instruction:0:3}
  echo ">>: i:$i opcode:$opcode mode:$mode base:$base"
  set_m=
  case $opcode in
    01) # add
      get_p $i 3
      i=$(( i + 3 ))
      get_r $mode
      if (( set_m == 2 )); then
        p[3]=$(( base + p[3] ))
      fi
      runcode[${p[3]}]=$(( r[1] + r[2] ))
      ;;
    02) # multiply
      get_p $i 3
      i=$(( i + 3 ))
      get_r $mode
      if (( set_m == 2 )); then
        p[3]=$(( base + p[3] ))
      fi
      runcode[${p[3]}]=$(( r[1] * r[2] ))
      ;;
    03) # input
      get_p $i 1
      echo ">>: p:${p[@]}"
      i=$(( i + 1 ))
      _m=${mode: -1}
      echo ">>: m:$_m"
      case $_m in
        2) # relative mode
          echo ">>: relative_base: $(( base + p[1] ))"
          echo ">>: before:${runcode[$(( base + p[1] ))]}"
          runcode[$(( base + p[1] ))]=${input[@]:0:1}
          echo ">>: after:${runcode[$(( base + p[1] ))]}"
          ;;
        1) # immediate mode
          p[1]=${input[@]:0:1}
          echo ">>: m:$_m"
          echo ">>: before:${p[1]}"
          echo ">>: ${p[1]}=${input[@]:0:1}"
          echo ">>: after:${p[1]}"
          ;;
        0) # position mode
          runcode[${p[1]}]=${input[@]:0:1}
          echo ">>: m:$_m"
          echo ">>: before:$runcode[${p[1]}]"
          echo ">>: $runcode[${p[1]}]=${input[@]:0:1}"
          echo ">>: after:$runcode[${p[1]}]"
          ;;
      esac
      input=( ${input[@]:1} )
      ;;
    04) # output
      get_p $i 1
      echo ">>: p:${p[@]}"
      i=$(( i + 1 ))
      get_r $mode
      echo -n "${r[1]} "
      ;;
    05) # jump-if-true
      get_p $i 2
      echo ">>: p:${p[@]}"
      i=$(( i + 2 ))
      get_r $mode
      if (( r[1] != 0 )) ; then
        i=$(( r[2] - 1 )) # ++ in for loop
      fi
      ;;
    06) # jump-if-false
      get_p $i 2
      echo ">>: p:${p[@]}"
      i=$(( i + 2 ))
      get_r $mode
      if (( r[1] == 0 )) ; then
        i=$(( r[2] - 1 )) # ++ in for loop
      fi
      ;;
    07) # less than
      get_p $i 3
      echo ">>: p:${p[@]}"
      i=$(( i + 3 ))
      get_r $mode
      echo ">>: r:${r[@]}"
      echo ">>: less_than:$(( r[1] < r[2] ))"
      echo ">>: before:${runcode[${p[3]}]}"
      echo ">>: set_m:$set_m"
      if (( set_m == 2 )); then
        p[3]=$(( base + p[3] ))
      fi
      echo ">>: before:${runcode[${p[3]}]}"
      runcode[${p[3]}]=$(( r[1] < r[2] ))
      echo ">>: after:${runcode[${p[3]}]}"
      ;;
    08) # equals
      get_p $i 3
      echo ">>: p:${p[@]}"
      i=$(( i + 3 ))
      get_r $mode
      echo ">>: r:${r[@]}"
      echo ">>: set_m:$set_m"
      if (( set_m == 2 )); then
        p[3]=$(( base + p[3] ))
      fi
      echo ">>: before:${runcode[${p[3]}]}"
      runcode[${p[3]}]=$(( r[1] == r[2] ))
      echo ">>: after:${runcode[${p[3]}]}"
      ;;
    09) # adjust relative base
      get_p $i 1
      echo ">>: p:${p[@]}"
      i=$(( i + 1 ))
      get_r $mode
      _m=${mode: -1}
      echo ">>: m:$_m"
      case $_m in
        2) # relative mode
          echo ">>: r:${r[@]}"
          echo ">>: before:$base"
          base=$(( base + r[1] ))
          #base=${r[1]}
          echo ">>: after:$base"
          ;;
        1) # immediate mode
          echo ">>: r:${r[@]}"
          echo ">>: before:$base"
          base=$(( base + r[1] ))
          echo ">>: after:$base"
          ;;
        0) # position mode
          echo ">>: r:${r[@]}"
          echo ">>: before:$base"
          base=$(( base + r[1] ))
          echo ">>: after:$base"
          ;;
      esac
      ;;
    99) # halt
      echo ""
      exit
      ;;
  esac
  unset p r set_m
done

