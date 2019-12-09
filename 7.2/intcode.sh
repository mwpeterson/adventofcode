#!/usr/bin/env bash

run_program() {
  amp=$1
  declare input=( $2 $3)
  runcode=( ${machine[$amp]} )
  #echo ${!position[@]} >&2
  #echo ${position[@]} >&2
  for (( i=${position[$amp]}; i<=$(( ${#runcode[*]} - 1 )); i++ )); do
    raw=${runcode[$i]}
    mask="00000${raw}"
    instruction=${mask: -5}
    opcode=${instruction:3:2}
    mode=${instruction:0:3}
    case $opcode in
      01) # add
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        p3=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        runcode[$p3]=$(( r1 + r2 ))
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        ;;
      02) # multiply
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        p3=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        runcode[$p3]=$(( r1 * r2 ))
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        ;;
      03) # input
        p1=${runcode[$(( ++i ))]}
        runcode[$p1]=${input[@]:0:1}
        input=( ${input[@]:1} )
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        ;;
      04) # output
        p1=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        output=$r1
        return
        ;;
      05) # jump-if-true
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        [[ $r1 -ne 0 ]] && i=$(( $r2 - 1 )) # ++ in for loop
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        ;;
      06) # jump-if-false
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        [[ $r1 -eq 0 ]] && i=$(( $r2 - 1 )) # ++ in for loop
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        ;;
      07) # less than
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        p3=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        runcode[$p3]=$(( r1 < r2 ))
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        ;;
      08) # equals
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        p3=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        runcode[$p3]=$(( r1 == r2 ))
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        ;;
      99) # halt
        position[$amp]=$i
        machine[$amp]=${runcode[*]}
        return 1
        ;;
    esac
    #echo ${!position[@]} >&2
    #echo ${position[@]} >&2
  done
}

IFS=',' read -ra intcode < $1

declare -a combos
# create all combos
declare combos=( $( echo {9..5}{9..5}{9..5}{9..5}{9..5} ) )
# remove combos with dupliated digits
combos=( ${combos[*]%%*9*9*} )
combos=( ${combos[*]%%*8*8*} )
combos=( ${combos[*]%%*7*7*} )
combos=( ${combos[*]%%*6*6*} )
combos=( ${combos[*]%%*5*5*} )

declare -A results
for combo in ${combos[@]}; do 
  [[ "$combo" =~ ${combo//?/(.)} ]]          # splits into array
  declare -a signal=( "${BASH_REMATCH[@]:1}" ) # store it
  output=0
  s=0
  declare -A machine position 

  for amp in {A..E}; do
    machine[$amp]=${intcode[*]}
    position[$amp]=0
  done

  while :; do
    for amp in {A..E}; do
      phase=${signal[$s]}
      unset signal[$s]
      (( s++ ))
      run_program $amp $phase $output
      (( $? != 0 )) && {
        results[$combo]=$output
        break 2
      }
    done
  done
done

max_value=0
max_key=0
for i in "${!results[@]}"; do
  if [ ${results[$i]} -gt $max_value ]; then
    max_key=$i
    max_value=${results[$i]}
  fi
done
printf "%s:%d\n" $max_key $max_value
