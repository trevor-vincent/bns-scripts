#!/bin/bash

if [ "$#" -gt 3 ]; then
    echo "bns_eccred.sh <eos> <nsns_id_folder_name> <nsns_ev_folder_name>"
    echo "<nsns_ev_folder_name> is optional, it will be given the same name as id if not provided" 
    exit
fi


eos=$1
export NSNS_ID=$2

if [ "$#" -eq 2 ]; then
    export NSNS_EV=$NSNS_ID
fi

if [ "$#" -eq 3 ]; then
    export NSNS_EV=$3
fi

export NSNS_DIR='/scratch/p/pfeiffer/tvincent/BNS_Disks_project'
export NSNS_DIR_EV="$NSNS_DIR/Evolutions"
export NSNS_DIR_ID="$NSNS_DIR/InitialData"

#check for errors
cd $NSNS_DIR_ID

if [ ! -d "$NSNS_ID/EvID" ]; then
    echo "directory $NSNS_DIR_ID/$NSNS_ID/EvID does not exist, please try again"
    exit
fi

cd $NSNS_DIR_EV

if [ -d "$NSNS_EV" ]; then
    echo "directory $NSNS_DIR_EV/$NSNS_EV already exists, please try again"
    exit
fi


cd $NSNS_DIR_EV
mkdir $NSNS_EV
cd $NSNS_EV
mkdir Ev
mkdir ID
cd ID
ln -s $NSNS_DIR/InitialData/$NSNS_ID/EvID .
cd ..
cd Ev
PrepareEv -t nsns
sed -i 's/$NU = "#     "/$NU = "     "/g' DoMultipleRuns.input
sed -i 's/$YE = "#     "/$YE = "     "/g' DoMultipleRuns.input
sed -i 's/\/panfs\/ds06\/sxs\/mbdeaton\/EsOS\//\/scratch/p/pfeiffer\/foucartf\/EoSFiles\//g' DoMultipleRuns.input 
sed -i 's/__YE__                          TableOptions=(filename=__EOSMicroFile__;InfoToExtract=Entropy;),/__YE__                          TableOptions=(filename=__EOSMicroFile__;InfoToExtract=Entropy;)),/g' HyDataBoxItems.input
#perl -i -p0e 's/ReflectZ=true/ReflectZ=false/g' ./*.input
#perl -i -p0e 's/Symmetry=ReflectZ/Symmetry=None/g' ./*.input
#perl -i -p0e 's/DomainSymmetry         = ReflectZ/DomainSymmetry         = None/g' ./*.input
#perl -i -p0e 's/Symmetry = Equatorial/Symmetry = None/g' ./*.input
#perl -i -p0e 's/DomainSymmetry     = ReflectZ/DomainSymmetry     = None/g' ./*.input

if [ $eos = "sfho" ]
then
    perl -i -p0e 's/\$EOSFile = ".*";/\$EOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/SFHo_Tabulated.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$MuEOSFile = ".*";/\$MuEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/SFHo_ChemicalPotentials.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$EOSMicroFile = ".*";/\$EOSMicroFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/SFHo_Microphysics.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$YeEOSFile = ".*";/\$YeEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/SFHo_ColdBetaYe-T0.1.dat";/g' DoMultipleRuns.input
elif [ $eos = "ls220" ]
then
    perl -i -p0e 's/\$EOSFile = ".*";/\$EOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/LS220_Tabulated-smooth.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$MuEOSFile = ".*";/\$MuEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/LS220_ChemicalPotentials.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$EOSMicroFile = ".*";/\$EOSMicroFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/LS220_Microphysics.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$YeEOSFile = ".*";/\$YeEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/LS220_ColdBetaYe.dat";/g' DoMultipleRuns.input
elif [ $eos = "dd2" ]
then
    perl -i -p0e 's/\$EOSFile = ".*";/\$EOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HempDD2_Tabulated.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$MuEOSFile = ".*";/\$MuEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HempDD2_ChemicalPotentials.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$EOSMicroFile = ".*";/\$EOSMicroFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HempDD2_Microphysics.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$YeEOSFile = ".*";/\$YeEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HempDD2_ColdBetaYe-T0.1.dat";/g' DoMultipleRuns.input
elif [ $eos = "hshen" ]
then
    perl -i -p0e 's/\$EOSFile = ".*";/\$EOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HShen_Tabulated.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$MuEOSFile = ".*";/\$MuEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HShen_ChemicalPotentials.datt";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$EOSMicroFile = ".*";/\$EOSMicroFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HShen_Microphysics.dat";/g' DoMultipleRuns.input
    perl -i -p0e 's/\$YeEOSFile = ".*";/\$YeEOSFile = "\/scratch/p/pfeiffer\/foucartf\/EoSFiles\/HShen_ColdBetaYe.dat";/g' DoMultipleRuns.input    
else
    echo "Not a supported EOS"
    exit
fi

# perl -i -p0e 's/ReflectZ=true/ReflectZ=false/g' ./*.input

./StartJob.sh

# HempDD2_ChemicalPotentials.dat  HShenapp_ColdTable.dat        LS220app_ColdTable.dat        LS220_Tabulated-lowrho-smooth.dat                              SFHo_HotBetaYe.dat
# HempDD2_ColdBetaYe-T0.1.dat     HShen_ChemicalPotentials.dat  LS220_BetaEq.dat              LS220_Tabulated-smooth.dat                                     SFHo_Microphysics.dat
# HempDD2_ColdTable-T0.1.dat      HShen_ColdBetaYe.dat          LS220_ChemicalPotentials.dat  NuLib_LS220_rho82_temp65_ye51_ng24_ns3_version1.0_20130424.h5  SFHo_Tabulated.dat
# HempDD2_HotBetaYe.dat           HShen_ColdTable.dat           LS220_ColdBetaYe.dat          NuLib_Shen_rho90_temp75_ye50_ng12_ns3_version1.0_20130325.h5
# HempDD2_Microphysics.dat        HShen_HotBetaYe.dat           LS220_ColdTable.dat           SFHo_ChemicalPotentials.dat
# HempDD2_Tabulated.dat           HShen_Microphysics.dat        LS220_Microphysics.dat        SFHo_ColdBetaYe-T0.1.dat
# HempDD2_TabulatedTrim.dat       HShen_Tabulated.dat           LS220_Tabulated.dat           SFHo_ColdTable-T0.1.dat

