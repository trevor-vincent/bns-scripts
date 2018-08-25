#!/bin/bash

OLD_RUN=$1
NEW_RUN=$2

cd $OLD_RUN
cd Run
cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | sort -n | tail -n1)" 
cd $LAST_CHK
Cptime=$(cat Cp-GrDomain.txt | cut -d ';' -f 1 | cut -d '=' -f 2)
Cpdir="$OLD_RUN/Run/Checkpoints/$LAST_CHK"

cd $NEW_RUN
OLDTIME=$(cat ControlParams.input | grep " Time=" | head -n1 | cut -d '=' -f2 | cut -d ';' -f1)

#postbounce_tracers.sh $1 $2
echo "********* RUNNING POSTBOUNCE_HYDOMAIN.SH************"
postbounce_hydomain_extend_bounds_not_extents.sh $1 $2
echo "********* RUNNING POSTBOUNCE_AMRDRIVER.SH************"
postbounce_amrdriver.sh $1 $2
echo "********* RUNNING POSTBOUNCE_CONTROLPARAMS.SH************"
postbounce_controlparams.sh $1 $2
echo "********* RUNNING POSTBOUNCE_EVOLUTION.SH************"
postbounce_evolution.sh $1 $2
echo "********* RUNNING POSTBOUNCE_GRDATABOXITEMS.SH************"
postbounce_grdataboxitems.sh $1 $2
echo "********* RUNNING POSTBOUNCE_GRDOMAIN.SH************"
postbounce_grdomain.sh $1 $2
echo "********* RUNNING POSTBOUNCE_GRSTATECHANGERS.SH************"
postbounce_grstatechangers.sh $1 $2
echo "********* RUNNING POSTBOUNCE_HYDATABOXITEMS_NEW.SH************"
postbounce_hydataboxitems_new.sh $1 $2
postbounce_hydataboxitems_aux.sh $1 $2
echo "********* RUNNING POSTBOUNCE_HYOBSERVERS.SH************"
postbounce_hyobservers.sh $1 $2 
echo "********* RUNNING POSTBOUNCE_HYSETUPANDEVOLUTION.SH************"
postbounce_hysetupandevolution.sh $1 $2 
echo "********* RUNNING POSTBOUNCE_HYSTATECHANGERS.SH************"
postbounce_hystatechangers.sh $1 $2 $OLDTIME $Cptime
postbounce_hystatechangers_aux.sh $1 $2
echo "********* RUNNING POSTBOUNCE_NEUTRINOITEMS2.SH************"
postbounce_neutrinoitems2.sh $1 $2
echo "********* RUNNING POSTBOUNCE_NEUTRINOITEMS.SH************"
postbounce_neutrinoitems.sh $1 $2
echo "********* RUNNING POSTBOUNCE_EJECTAITEMS.SH************"
postbounce_ejectaitems.sh $1 $2
echo "********* RUNNING POSTBOUNCE_NUEVOLUTION.SH************"
postbounce_nuevolution.sh $1 $2
echo "********* RUNNING POSTBOUNCE_RECOVEROLDCHECKPOINTS.SH************"
postbounce_recoveroldcheckpoints.sh $1 $2
echo "********* RUNNING POSTBOUNCE_YLEVWITHXLEV.SH************"
postbounce_ylevwithxlev.sh $1 $2
echo "********* RUNNING POSTBOUNCE_COMMUNICATIONS.SH************"
postbounce_communication.sh $1 $2
cd $2
echo "********* RUNNING REFRESHTHESPECS************"

cd ..
cd ..
refreshthespecs /scratch/p/pfeiffer/tvincent/SpEC_NOLEAK/Hydro/EvolveTwoDomains/Executables/EvolveGRHydro

cd $2
sed -i 's/Cores = [0-9]\+/Cores = 408/g' MakeSubmit.input
MakeSubmit.py update
