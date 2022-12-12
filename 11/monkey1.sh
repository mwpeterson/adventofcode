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

for (( n=0; n<=m; n++ )); do
  x="items_$n"
  #echo "monkey $n has starting items: ${!x}"
  x="op_$n"
  #echo -n " op: ${!x}"
  x="div_$n"
  #echo -n " div: ${!x}"
  x="true_$n"
  #echo -n " true: ${!x}"
  x="false_$n"
  #echo " false: ${!x}"
done

rounds=20
for (( round=1; round<=rounds; round++ )); do
  for (( n=0; n<=m; n++ )); do
    x="items_$n"
    items=${!x}
    #echo "monkey $n"
    #echo "items: '$items'"
    while [[ "$items" != "" ]]; do
      x="inspect_$n"
      inspect=${!x}
      printf -v "inspect_$n" $(( inspect + 1 ))
      old=${items%%,*}
      #echo "old: '$old'"
      x="op_$n"
      new=$(( ${!x} ))
      #echo "new: $new"
      worry=$(( new / 3 ))
      #echo "worry: $worry"
      x="div_$n"
      test=$(( worry % ${!x} ))
      #echo "test: $test"
      if (( test == 0 )); then
	x="true_$n"
      else
	x="false_$n"
      fi
      next=${!x}
      #echo "next: $next"
      x="items_$next"
      list=${!x}
      printf -v "items_$next" "$list$worry,"
      items=${items#*,}
      #echo "items: $items"
    done
    unset items_$n
    #echo
  done
  if (( round <= 10 || round % 5 == 0 )); then
    echo "After round $round, the monkeys are holding items with these worry levels:"
    for (( n=0; n<=m; n++ )); do
      x="items_$n"
      items=${!x}
      echo "Monkey $n: $items"
    done
    echo
  fi
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
echo "part1: $(( most[0] * most[1] ))"
