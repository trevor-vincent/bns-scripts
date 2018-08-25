#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "postbounce_tracers.sh <OLD_RUN_LEV> <NEW_RUN_LEV> <NUM_TRACERS_PER_DIM>"
    exit
fi

OLD_RUN=$1
NEW_RUN=$2
NUM_TRACERS_PER_DIM=$3

cd $OLD_RUN
cd Run

X1_lev1="$(cat HyDomain.input | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_x_lev1="$(cat HyDomain.input | grep Extents | head -n1 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

Y1_lev1="$(cat HyDomain.input | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_y_lev1="$(cat HyDomain.input | grep Extents | head -n2 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

Z1_lev1="$(cat HyDomain.input | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_z_lev1="$(cat HyDomain.input | grep Extents | head -n3 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | grep -v withtracers | sort -n | tail -n1)"

if [ -d "${OLD_RUN}/Run/Checkpoints/$LAST_CHK/TracerData" ]; then
    echo "TracerData folder exists in $LAST_CHK, we will exit"
    exit
fi

if [ ! -d "${OLD_RUN}/Run/Checkpoints/${LAST_CHK}_withtracers/" ]; then
    embed_tracers_in_chk.sh $OLD_RUN/Run/Checkpoints/ ${LAST_CHK} $NUM_TRACERS_PER_DIM $NUM_TRACERS_PER_DIM $NUM_TRACERS_PER_DIM 2*$X1_lev1 2*$Y1_lev1 2*$Z1_lev1 $OLD_RUN/Run/
#    echo "${OLD_RUN}Run/Checkpoints/${LAST_CHK}_withtracers/"
#    echo "${OLD_RUN}Run/Checkpoints/"
else
    echo "./Checkpoints/${LAST_CHK}_withtracers/ exists so we will not be creating any TracerData" 
fi

cd $OLD_RUN
cd Run
cd Checkpoints
echo $LAST_CHK
echo "orig-${LAST_CHK}"
echo "${LAST_CHK}_withtracers"

mv "$LAST_CHK" "orig-${LAST_CHK}"
mv "${LAST_CHK}_withtracers" "$LAST_CHK"

/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/postbounce_tracers_2.sh $1 $2