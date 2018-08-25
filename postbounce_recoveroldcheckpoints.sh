OLD_RUN=$1
NEW_RUN=$2

cd $OLD_RUN
cd Run
cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | grep -v orig | sort -n | tail -n1)" 
cd $LAST_CHK
python /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/RecoverOldCheckpoints3.py