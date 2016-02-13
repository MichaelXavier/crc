#!/bin/bash
set -e

COUNTER=0
N=${1:-1000}
while [  $COUNTER -lt $N ]; do
    line=$(awk -v lineno="$RANDOM" 'lineno==NR{print;exit}' /usr/share/dict/american-english)
    enc=$(echo $line | chardet)
    if [[ $enc =~ "ascii" ]]; then
        echo $line
        let COUNTER=COUNTER+1
    fi
done
