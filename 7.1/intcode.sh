#!/usr/bin/env bash

run_program() {
  declare input=( $1 $2 )
  runcode=( ${intcode[*]} )
  for (( i=0; i<=$(( ${#runcode[*]} - 1 )); i++ )); do
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
        ;;
      02) # multiply
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        p3=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        runcode[$p3]=$(( r1 * r2 ))
        ;;
      03) # input
        p1=${runcode[$(( ++i ))]}
        runcode[$p1]=${input[@]:0:1}
        input=( ${input[@]:1} )
        ;;
      04) # output
        p1=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        printf '%s\n' $r1
        ;;
      05) # jump-if-true
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        [[ $r1 -ne 0 ]] && i=$(( $r2 - 1 )) # ++ in for loop
        ;;
      06) # jump-if-false
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        [[ $r1 -eq 0 ]] && i=$(( $r2 - 1 )) # ++ in for loop
        ;;
      07) # less than
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        p3=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        runcode[$p3]=$(( r1 < r2 ))
        ;;
      08) # equals
        p1=${runcode[$(( ++i ))]}
        p2=${runcode[$(( ++i ))]}
        p3=${runcode[$(( ++i ))]}
        [[ ${mode:2:1} -eq 1 ]] && r1=$p1 || r1=${runcode[$p1]}
        [[ ${mode:1:1} -eq 1 ]] && r2=$p2 || r2=${runcode[$p2]}
        runcode[$p3]=$(( r1 == r2 ))
        ;;
      99) # halt
        return
        ;;
    esac
  done
}

IFS=',' read -ra intcode < $1

declare -a combos
# create all combos
declare combos=( $( echo {0..4}{0..4}{0..4}{0..4}{0..4} ) )
# remove combos with dupliated digits
combos=( ${combos[*]%%*0*0*} )
combos=( ${combos[*]%%*1*1*} )
combos=( ${combos[*]%%*2*2*} )
combos=( ${combos[*]%%*3*3*} )
combos=( ${combos[*]%%*4*4*} )

declare -A results
for combo in ${combos[@]}; do 
  [[ "$combo" =~ ${combo//?/(.)} ]]          # splits into array
  declare -a signal=( "${BASH_REMATCH[@]:1}" ) # copy array for later
  output=0
  for phase in ${signal[@]}; do
    output=$( run_program $phase $output )
  done
  results[$combo]=$output
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
