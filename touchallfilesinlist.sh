#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
    file=$(echo "$line" | cut -d ' ' -f13)
    echo "Touching $file"
    touch $file
done < "$1"
