#!/bin/bash

MakeNextSegment -d $1

OLD_RUN=${PWD}/$1
NEW_RUN=${PWD}/$(ls -t | head -n1)

echo "OLD_RUN = $OLD_RUN"
echo "NEW_RUN = $NEW_RUN"

cd $OLD_RUN
cd Run

cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | sort -n | tail -n1)"
cd $LAST_CHK

OLD_RUN_DIR=$(echo "$OLD_RUN/Run" | sed -e 's/^[ \t]*//')
OLD_TIME="$(cat Cp-GrDomain.txt | cut -d ';' -f 1 | cut -d '=' -f 2)"
OLD_CP_DIR=$(echo "$OLD_RUN/Run/Checkpoints/$LAST_CHK" | sed -e 's/^[ \t]*//')

cd $NEW_RUN
OLD_OLD_CP_DIR="$(grep " Dir" NeutrinoItems2.input |cut -d '=' -f2 | cut -d ';' -f1 | sed -e 's/^[ \t]*//')"
OLD_OLD_RUN_DIR="$(grep "DomainDir" NeutrinoItems2.input |cut -d '=' -f2 | cut -d ';' -f1 | sed -e 's/^[ \t]*//')"
OLD_OLD_TIME="$(grep " Time=" ControlParams.input | head -n1 | cut -d '=' -f2 | cut -d ';' -f1 | sed -e 's/^[ \t]*//')"

echo "Replacing"
echo $OLD_OLD_RUN_DIR
echo $OLD_OLD_TIME
echo $OLD_OLD_CP_DIR

echo "With"
echo $OLD_RUN_DIR
echo $OLD_TIME
echo $OLD_CP_DIR

echo "s|${OLD_OLD_CP_DIR}|${OLD_CP_DIR}|g"

sed -i "s|${OLD_OLD_CP_DIR}|${OLD_CP_DIR}|g" *.input
sed -i "s|${OLD_OLD_CP_DIR}\/|${OLD_CP_DIR}\/|g" *.input
sed -i "s|${OLD_OLD_RUN_DIR}|${OLD_RUN_DIR}|g" *.input
sed -i "s|${OLD_OLD_TIME}|${OLD_TIME}|g" *.input
