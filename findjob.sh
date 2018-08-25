#!/bin/bash
nodeserv="$(checkjob -v $1 | grep "Task Distribution: " | awk -F' ' '{print $3}' | awk -F',' '{print $1}')" && ssh -t $nodeserv "pooid=\"\$(pgrep SpEC | head -n1)\" && pwdx \$pooid"


# qstat -u tvincent | sed -e '1,5d' > temp.txt
# #cat temp.txt
# while read -u10 p ; do
# RUN="$(findjob.sh $p > temp1.txt 2>&1 && grep nsns temp1.txt | tr "/" "\n" | grep "nsns")"
# echo $p $
# done 10< temp.txt


# qstat -u tvincent | cut -c-7 | sed -e '1,5d' > temp.txt
