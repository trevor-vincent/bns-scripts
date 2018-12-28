#!/bin/bash

clear
FOLDER_NEW=$1
FOLDER_WORKING=$2
echo "Running diff $FOLDER_NEW $FOLDER_WORKING on each file individually"

cd $FOLDER_NEW
for file in $(ls | grep .input | grep -v MakeSubmit | grep -v VisualizeRho); do 
echo "****************************************************"
echo "          Do you want to diff $file (no=0/yes=1)?"
echo "****************************************************"
read ANS
if [ $ANS -eq 1 ]
then
diff -w $FOLDER_NEW/$file $FOLDER_WORKING/$file
fi
done
