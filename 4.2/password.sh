#!/usr/bin/env bash

# must contain at least one digit pair
# digits always increase or stay the same
# must have standalone pair
#

# split string into array; stores in $digits
explode() {
  string="$1"
  [[ "$string" =~ ${string//?/(.)} ]]   # splits into array
  digits=( "${BASH_REMATCH[@]:1}" )     # copy array for later
}

# check a subset of digits according to the rules
check() {
  arg_len=${#*}
  IFS=''; value="$*"; unset IFS
  min_limit=''; max_limit=''
  for (( i=0; i<arg_len; i++ )); do
    min_limit="${min_limit}${min_pass[$i]}"
    max_limit="${max_limit}${max_pass[$i]}"
  done
  # fail the set of numbers that are < min_pass or > max_pass
  if [ $value -lt $min_limit -o $value -gt $max_limit ] ; then
    return 0
  elif [ $arg_len -gt 1 ]; then
    # if a subset of numbers doesn't pass the >= rule
    # then every number that begins with that subset fails
    if [ ${value:$(( $arg_len - 1 )):1} -lt ${value:$(( $arg_len - 2 )):1} ]; then
      return 0
    else
      return 1 # potential password
    fi
  else
    return 1 # potential password
  fi
}

declare -a digits min_pass max_pass sieve
explode 382345
min_pass=( ${digits[@]} )
explode 843167
max_pass=( ${digits[@]} )

# check first digit
for (( a=0; a<=9; a++ )); do
  if check $a; then continue; fi
  # check second digit
  for (( b=0; b<=9; b++ )); do
    if check $a $b; then continue; fi
    # check third digit
    for (( c=0; c<=9; c++ )); do
      if check $a $b $c; then continue; fi
      # check fourth digit
      for (( d=0; d<=9; d++ )); do
        if check $a $b $c $d; then continue; fi
        # check fifth digit
        for (( e=0; e<=9; e++ )); do
          if check $a $b $c $d $e; then continue; fi
          # check sixth digit
          for (( f=0; f<=9; f++ )); do
            if check $a $b $c $d $e $f; then continue; fi
            # check for discrete pairs of numbers
            for (( t=0; t<=9; t++ )); do
              maybe="$a$b$c$d$e$f"
              if [[ $maybe =~ ^$t{2}[^$t]|[^$t]$t{2}[^$t]|[^$t]$t{2}$ ]]; then
                sieve+=( $maybe ) # we found a potential password
                break
              fi
            done
          done
        done
      done
    done
  done
done

printf "possible passwords: %s\n" "${#sieve[*]}"
