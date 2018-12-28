#!/bin/bash

find $PWD -name "Lev0*" | sort | tail -n 10 | tac | while read line; do
echo $line
if [ -f "$line/Run/SpEC.out" ]; then
    echo "found"
    cat "$line/Run/SpEC.out" | grep CPU
    exit
fi
done
