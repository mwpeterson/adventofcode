#!/usr/bin/env bash

part1=0
pair=0
wrong=1
while read left ; read riht; read blank; do
  if (( wrong == 0 )); then
    ((part1+=pair))
    echo "part1:$part1"
  fi
  ((pair++))
  wrong=0
  left=($(grep -o . <<<"$left"))
  riht=($(grep -o . <<<"$riht"))
  lnest=0
  rnest=0
  lv=
  rv=
  echo "${left[@]} : ${riht[@]}"
  for (( i=0; i<${#left[*]}; i++ )); do
    j=i
    l=${left[i]}
    if   [[ "$l" == '[' ]]; then
      ((lnest++))
    elif [[ "$l" == ']' ]]; then
      lop=1
      ((lnest--))
    elif [[ "$l" == ',' ]]; then
      lop=1
    else
      lv="$lv$l"
    fi
    r=${riht[j]}
    if   [[ "$r" == '[' ]]; then
      ((rnest++))
    elif [[ "$r" == ']' ]]; then
      rop=1
      ((rnest--))
    elif [[ "$r" == ',' ]]; then
      rop=1
    else
      rv="$rv$r"
    fi
    if (( lop == 1 && rop == 1 )); then
      if (( lv > rv )); then
	wrong=1
	break
      fi
      lv=
      rv=
    fi
  done
  echo
  echo '==='
done < $1
