function write_submit {

cat <<EOF > submit_scinet.sh

#!/bin/bash
# MOAB/Torque submission script for SciNet GPC (OpenMP)
#
#PBS -l nodes=1:ppn=8,walltime=1:00:00
#PBS -N test
 
# load modules (must match modules used for compilation)
module load intel/15.0.2
 
# DIRECTORY TO RUN - $PBS_O_WORKDIR is directory job was submitted from
cd $PBS_O_WORKDIR
 
export OMP_NUM_THREADS=8
$3/visualize_last_checkpoint.sh $1 $2

EOF
}


write_submit 1 /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts
qsub submit_scinet.sh
write_submit 2 /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts
qsub submit_scinet.sh
write_submit 3 /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts
qsub submit_scinet.sh
write_submit 4 /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts
qsub submit_scinet.sh