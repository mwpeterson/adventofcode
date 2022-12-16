#!/usr/bin/env bash

while read monkey; read items; read op; read test; read true; read false; read blank; do
  m=${monkey:7:1}
  items=${items:15}
  items=${items// }
  printf -v "items_$m" "$items,"
  printf -v "op_$m" "${op#*=}"
  test=($test)
  printf -v "div_$m" ${test[3]}
  true=($true)
  printf -v "true_$m" ${true[5]}
  false=($false)
  printf -v "false_$m" ${false[5]}
done < $1

rounds=20
for (( round=1; round<=rounds; round++ )); do
  for (( n=0; n<=m; n++ )); do
    x="items_$n"
    items=${!x}
    echo "monkey $n"
    echo "items: '$items'"
    while [[ "$items" != "" ]]; do
      x="inspect_$n"
      inspect=${!x}
      printf -v "inspect_$n" $(( inspect + 1 ))
      x="inspect_$n"
      inspect=${!x}
      echo "inspect: $inspect"
      old=${items%%,*}
      echo "old: $old"
      x="op_$n"
      op=${!x}
      op=${op//old/$old}
      op=${op//new/$new}
      echo "op: $op"
      new=$(bc <<< "$op")
      echo "new: $new"
      x="div_$n"
      test=$(bc <<< "$new % ${!x}")
      echo "test: $test"
      if (( test == 0 )); then
	x="true_$n"
      else
	x="false_$n"
      fi
      next=${!x}
      echo "next: $next"
      x="items_$next"
      list=${!x}
      printf -v "items_$next" "$list$new,"
      items=${items#*,}
      echo $items
    done
    echo
    unset items_$n
  done
  #if (( round == 1 || round == 20 )) || (( round % 100 == 0 )); then
    echo "== After round $round =="
    for (( n=0; n<=m; n++ )); do
      x="inspect_$n"
      items=${!x}
      echo "Monkey $n inspected items $items times."
    done
    echo
  #fi
done
most=(0 0)
for x in ${!inspect_*}; do
  inspect=${!x}
  if (( inspect > most[0] )); then
    most[1]=${most[0]}
    most[0]=$inspect
  elif (( inspect > most[1] )); then
    most[1]=$inspect
  fi
done
echo "part2: $(( most[0] * most[1] ))"
