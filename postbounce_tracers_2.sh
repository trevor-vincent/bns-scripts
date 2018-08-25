#!/bin/bash
OLD_RUN=$1
NEW_RUN=$2

cd $OLD_RUN
cd Run
cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | grep -v withtracers | sort -n | tail -n1)"

mv "$LAST_CHK" "orig-orig-$LAST_CHK"
mv "orig-$LAST_CHK" "$LAST_CHK"