#!/bin/bash

SCRIPT_DIR=/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts
EV_DIR=/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions

$SCRIPT_DIR/bns_create_ev_nosubmit.sh $1 $2
$SCRIPT_DIR/convert_leakage_to_m1 $2

cd $EV_DIR

$SCRIPT_DIR/refreshthespecs /scratch/p/pfeiffer/tvincent/SpEC_NOLEAK_B4MYCHANGE/Hydro/EvolveTwoDomains/Executables/EvolveGRHydro

cd $EV_DIR/Ev/
sed -i 's/__StartTime__/0/g' NuEvolution.input
sed -i 's/HyErrorMaskDoNothing(),/HyErrorMaskDoNothing(),ConstDouble(Value=0.001; Output=SmoothMaximumDensity;),/g/' HyDataBoxItems.input

./StartJob.sh