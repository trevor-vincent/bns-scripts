#!/bin/bash

CHK_DIR=$1
HY_PATH=$2

cd $CHK_DIR

X1_lev1="$(cat $HY_PATH | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_x_lev1="$(cat $HY_PATH | grep Extents | head -n1 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"
Y1_lev1="$(cat $HY_PATH | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_y_lev1="$(cat $HY_PATH | grep Extents | head -n2 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"
Z1_lev1="$(cat $HY_PATH | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_z_lev1="$(cat $HY_PATH | grep Extents | head -n3 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

dx_lev1=$(echo "2*${X1_lev1}/$Extents_x_lev1" | bc -l)
dy_lev1=$(echo "2*${Y1_lev1}/$Extents_y_lev1" | bc -l)
dz_lev1=$(echo "2*${Z1_lev1}/$Extents_z_lev1" | bc -l)
dx_lev0=$(echo "2*2*${X1_lev1}/$Extents_x_lev1" | bc -l)
dy_lev0=$(echo "2*2*${Y1_lev1}/$Extents_y_lev1" | bc -l)
dz_lev0=$(echo "2*2*${Z1_lev1}/$Extents_z_lev1" | bc -l)

for f in $(ls | grep Cp-Vars_IntervalLev1 | grep h5); do
    echo "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/h5createmass.py $CHK_DIR/$f $dx_lev1 $dy_lev1 $dz_lev1";
    python /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/h5createmass.py $CHK_DIR/$f $dx_lev1 $dy_lev1 $dz_lev1
done;


for f in $(ls | grep Cp-Vars_IntervalLev0 | grep h5); do
    echo "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/h5createmass.py $CHK_DIR/$f $dx_lev0 $dy_lev0 $dz_lev0";
    python /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/h5createmass.py $CHK_DIR/$f $dx_lev0 $dy_lev0 $dz_lev0
done;
		

# "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/h5createmass.py $CHK_DIR/$f $dx_lev1 $dy_lev1 $dz_lev1"; done;

# for f in $(ls | grep Cp-Vars_IntervalLev0*.h5)
# do
#     echo "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/h5createmass.py $CHK_DIR/$f $dx_lev0 $dy_lev0 $dz_lev0"
# done

