CWD=$PWD
cd /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions
nsns_run=$(ls | grep nsns | head -n$1 | tail -n1)
cd $nsns_run
echo Visualizing $nsns_run
cd Ev
echo $PWD
Run=$(find ${PWD} -name "Run" | grep Merger | sort -k2 | tail -n1)                                                                                                                                             
echo $Run
cd $Run  
echo $PWD                                                                                                                                                                                                       
cd Checkpoints                                                                                                                                                                                                  
if [ -z "$(ls -A ./)" ]; then
   echo "Checkpoints directory is empty, we will exit"
   exit
else
   echo "Checkpoints directory is not empty"
fi
LAST_CHK="$(ls | grep '[0-9]\+' | sort -n | tail -n1)"                                                                                                                                                          
echo $LAST_CHK                                                                                                                                                                                                  
cd $LAST_CHK
ApplyObservers  -h5prefix='Cp-Vars' -t Rho,PreAtmWT0,NuECons_nua0 -r Scalar,Scalar,Scalar -d 3,3,3 -s=1 -domaininput ../../HyDomain.input -o "ConvertToVtk(Input=Rho,PreAtmWT0,NuECons_nua0;Basename=CpVarsRhoTempENua)" -NoDomainHistory
echo $PWD
cd $CWD