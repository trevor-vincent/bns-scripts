#!/bin/bash
nodeserv="$(checkjob -v $1 | grep "Task Distribution: " | awk -F' ' '{print $3}' | awk -F',' '{print $1}')" && ssh -t $nodeserv "pooid=\"\$(pgrep SpEC | head -n1)\" && kill -SIGUSR1 \$pooid"
