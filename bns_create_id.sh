#!/bin/bash
if [ "$#" -ne 8 ]; then
    echo "bns_id_create.sh <separation> <m1> <m2> <eos=sfho,ls220,dd2,hshen,poly> <hours> <lastres> <paramres> <directory_name>"
    exit
fi

sep=$1
m1=$2
m2=$3
eos=$4
hours=$5
lastres=$6
paramres=$7
export NSNS_DIR=$8

echo "Separation = $sep"
echo "M1 = $m1"
echo "M2 = $m2"
echo "EOS = $eos"
echo "Hours = $hours"
echo "Last Resolution = $lastres"
echo "Top Level Parameter Solve = $paramres"

#export NSNS_DIR='nsns_id_dd2_d30_m1.32_m1.2'
#export NSNS_DIR='nsns_id_hshen_d30_m1.32_m1.2'
#export NSNS_DIR='nsns_id_sfho_d30_m1.32_m1.2'
#export NSNS_DIR='nsns_id_ls220_d30_m1.4_m1.3'
#export NSNS_DIR='nsns_id_ls220_d30_m1.32_m1.2_eccred0_try2'
#export NSNS_DIR='nsns_id_poly_d30_m1.32_m1.2'
#export NSNS_DIR='nsns_id_poly_d30_m1.32_m1.2'

cd /scratch/p/pfeiffer/tvincent/BNS_Disks_project/InitialData
mkdir $NSNS_DIR
cd $NSNS_DIR
sed -i 's/    "MaxRuntimeHours"   => "[[:digit:]]\+",/    "MaxRuntimeHours"   => "'"$hours"'",/g' /scratch/p/pfeiffer/tvincent/SpEC/Support/Perl/Machines.pm

PrepareID -t nsns
#cut all the redundant bnssystems examples from DoMultipleRuns.input
sed -i.bak -e '24,311d' DoMultipleRuns.input
#paste in dmrgen_spec into DoMultipleRuns.input
cat DoMultipleRuns.input | sed -n '23,495p' >> DMR_temp.txt
sed -i.bak -e '23,495d' DoMultipleRuns.input
#if on briaree

if [ $eos = "sfho" ]
then
    echo "Using sfho table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/foucartf/EoSFiles/SFHo_ColdTable-T0.1.dat;)' -d $sep -q m_adm $m1 $m2 > TOV_output.txt
elif [ $eos = "ls220" ]
then
    echo "Using ls220 table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/foucartf/EoSFiles/LS220app_ColdTable.dat;)' -d $sep -q m_adm $m1 $m2 > TOV_output.txt
elif [ $eos = "dd2" ]
then
    echo "Using dd2 table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/foucartf/EoSFiles/HempDD2_ColdTable-T0.1.dat;)' -d $sep -q m_adm $m1 $m2 > TOV_output.txt     
elif [ $eos = "poly" ]
then
    echo "Using gamma2 poly table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e 'Gamma(Gamma=2.0; Kappa=123.6)' -d $sep -q m_adm $m1 $m2 > TOV_output.txt
elif [ $eos = "hshen" ]
then
    echo "Using hshen table"
    ${SPEC_HOME}/FluidInitialData/TOVSolverC/Executables/dmrgen_spec -e  'Tabulated(filename=/scratch/p/pfeiffer/foucartf/EoSFiles/HShen_ColdTable.dat;)' -d $sep -q m_adm $m1 $m2 > TOV_output.txt
else
    echo "Not a supported EOS"
    exit
fi

sed -i 's/=>/|/g' TOV_output.txt
sed -i '1d' TOV_output.txt 
sed -i '1d' TOV_output.txt 
sed -i '$ d' TOV_output.txt 
sed -i 's/,//g' TOV_output.txt
python /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/tab_dmgen.py
cat DoMultipleRuns.input TOV_output_fortab.txt DMR_temp.txt >> DoMultipleRunsNew.input
rm DoMultipleRuns.input *.txt
mv DoMultipleRunsNew.input DoMultipleRuns.input
sed -i.bak '/eos_dir/d' DoMultipleRuns.input
sed -i 's/$lastRes  = [[:digit:]]\+/$lastRes = '"$lastres"'/g' DoMultipleRuns.input
sed -i "s/'TopLevParamSolve'=> [[:digit:]]\+/'TopLevParamSolve'=> $paramres/g" DoMultipleRuns.input
./StartJob.sh
echo DONE AND DONE
