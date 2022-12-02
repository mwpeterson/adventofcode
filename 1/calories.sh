#!/usr/bin/env bash

file=$1
most=0
cal=0
one=0
two=0
three=0

echo "" >> $file
while read -r line; do
    if [[ "$line" == "" ]]; then
	if ((cal > most)); then
	    most=$cal
	fi
	if ((cal > one)); then
	    three=$two
	    two=$one
	    one=$cal
	elif ((cal > two)); then
	    three=$two
	    two=$cal
	elif ((cal > three)); then
	    three=$cal
	fi
	cal=0
    else
	cal=$((cal + line))
    fi
done <$file 
echo "most: $most"
echo "one: $one"
echo "two: $two"
echo "three: $three"
echo "top: $((one + two + three))"
