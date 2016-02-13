#!/bin/bash

set -e

MODEL=$1

while read line; do
  pycrc --model=$1 --check-string="$line"
done
