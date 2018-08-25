#!/bin/bash
if [ "$#" -ne 4 ]; then
    echo "run_tov.sh <separation> <m1> <m2> <eos=sfho,ls220,dd2,hshen,poly>"
    exit
fi

sep=$1
m1=$2
m2=$3
eos=$4


if [ $eos = "sfho" ]
then
    echo "Using sfho table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/tvincent/EoSFiles/SFHo_ColdTable-T0.1.dat;)' -d $sep -q m_adm $m1 $m2 
elif [ $eos = "ls220" ]
then
    echo "Using ls220 table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/tvincent/EoSFiles/LS220app_ColdTable.dat;)' -d $sep -q m_adm $m1 $m2 
elif [ $eos = "dd2" ]
then
    echo "Using dd2 table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/tvincent/EoSFiles/HempDD2_ColdTable-T0.1.dat;)' -d $sep -q m_adm $m1 $m2      
elif [ $eos = "poly" ]
then
    echo "Using gamma2 poly table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e 'Gamma(Gamma=2.0; Kappa=123.6)' -d $sep -q m_adm $m1 $m2 
elif [ $eos = "hshen" ]
then
    echo "Using hshen table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/tvincent/EoSFiles/HShen_ColdTable.dat;)' -d $sep -q m_adm $m1 $m2 
else
    echo "Not a supported EOS"
    exit
fi
