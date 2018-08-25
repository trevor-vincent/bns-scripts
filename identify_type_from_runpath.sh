#!/bin/bash

if [ "$#" -gt 1 ]; then
    echo "bns_eccred.sh <nsns_run_path>"
    exit
fi

if [ "$#" -eq 0 ]; then
    echo "bns_eccred.sh <nsns_run_path>"
    exit
fi

NSNS_RUN=$1

if [ ! -d "$NSNS_RUN" ]; then
    echo "directory $NSNS_RUN does not exist, please try again"
    exit
fi

NSNS_DIR='/scratch/p/pfeiffer/tvincent/BNS_Disks_project'
NSNS_DIR_EV="$NSNS_DIR/Evolutions"
NSNS_DIR_ID="$NSNS_DIR/InitialData"
NSNS_DIR_SCRIPTS="$NSNS_DIR/Scripts"
