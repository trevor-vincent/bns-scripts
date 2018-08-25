#!/bin/bash

if [ "$#" -gt 1 ]; then
    echo "bns_eccred.sh <nsns_ev_folder_name> "
    exit
fi

NSNS_EV=$1

NSNS_DIR='/scratch/p/pfeiffer/tvincent/BNS_Disks_project'
NSNS_DIR_EV="$NSNS_DIR/Evolutions"
NSNS_DIR_ID="$NSNS_DIR/InitialData"
NSNS_DIR_SCRIPTS="$NSNS_DIR/Scripts"
NSNS_DIR_INPUTS="$NSNS_DIR/InputFiles"

#check for errors
cd $NSNS_DIR_EV



echo "What is the last run folder (e.g. Lev0_AA or Lev0_AB)?"
read LASTRUN_DIR

if [ ! -d "$NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR/Run/Checkpoints" ]; then
    echo "$NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR/Run/Checkpoints does not exist, please try again"
    exit
fi

current_dir=${PWD}
cd "$NSNS_DIR_EV/$NSNS_EV/Ev/Lev0_AA/bin"
rm -f RecoverOldCheckpoints
ln -s /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/RecoverOldCheckpoints2.py RecoverOldCheckpoints
cd $current_dir

if [ -d "$NSNS_DIR_EV/$NSNS_EV/Ev/bin" ]; then
    current_dir=${PWD}
    cd "$NSNS_DIR_EV/$NSNS_EV/Ev/bin"
    rm -f RecoverOldCheckpoints
    ln -s /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/RecoverOldCheckpoints2.py RecoverOldCheckpoints
    cd $current_dir
fi

#find last checkpoint
cd $NSNS_EV/Ev/$LASTRUN_DIR/Run/Checkpoints
for f in *; do
    if [[ -d $f ]]; then
        if [[ -f $f/FinalLayout.txt ]]; then
	    CPDIR=$f
	    cd $CPDIR;
	    TPLUNGE="$(cut -d ';' -f1 Cp-GrDomain.txt | cut -d '=' -f2 | awk '{$1=$1};1')"
	    break
	fi
    fi
done

echo "Checkpoint dir = $NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR/Run/Checkpoints/$CPDIR"
echo "Time of plunge = $TPLUNGE"

cd $NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR/Run/Checkpoints/
# mkdir "$CPDIR-ref"
# mkdir "$CPDIR-orig"
# cp ../HyDomain.input $CPDIR/HyDomain.input
# cp ../HyDomain.input $CPDIR-ref/HyDomain.input

#sed -i "s/z-Axis = (Extents = \([[:digit:]]\+\);/z-Axis = \(Extents = 2*\1-1;/g" HyDomain.input
# perl -i -p0e 's/z-Axis = \(Extents = ([0-9]+);/z-Axis = \(Extents = 2*\1-1;/g' $CPDIR-ref/HyDomain.input
# perl -i -p0e 's/Bounds = 0,\n(\s+)([0-9]+.[0-9]+);/Bounds = -\2,\n\1\2;/g' $CPDIR-ref/HyDomain.input
# ReflectZSymmetricDomain -s $CPDIR -t $CPDIR-ref -h5prefix Cp-Vars -dold $CPDIR/HyDomain.input -dnew HyDomain.input 'Rho(3,Scalar)' 'Tau(3,Scalar)' 'Sflux(3,1)' 'RhoYe(3,Scalar)' 'PreAtmWT0(3,Scalar)' 'PreAtmWT1(3,Scalar)'
# rsync -av --progress $CPDIR/ $CPDIR-orig/
# cp $CPDIR-ref/*.h5 $CPDIR

cd $CPDIR && python $NSNS_DIR_SCRIPTS/RecoverOldCheckpoints2.py
cd $NSNS_DIR_EV/$NSNS_EV/Ev/ && rm -rf *Merger
bin/MakeNextSegment -d $LASTRUN_DIR
cp $NSNS_DIR_INPUTS/Plunge/M1/* $NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR-Merger/
rm -rf $NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR-Merger/Lev0_AA
cd $NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR-Merger/ && DoMultipleRuns -n
cd $NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR-Merger/Lev0_AA/
sed -i 's/Cores = 408/Cores = 216/g' MakeSubmit.input
sed -i 's/Fraction=384/Fraction=204/g' Evolution.input
sed -i 's/Fraction=24/Fraction=12/g' Evolution.input
cd $NSNS_DIR_EV/$NSNS_EV/Ev/$LASTRUN_DIR-Merger/Lev0_AA/ && MakeSubmit.py update

# perl -i -p0e 's/@Extents = \((.*),(.*),(.*)\);/@Extents = \(\1,\2,2*\3-1\);/g' MergedBoxesParameters.perl
# perl -i -p0e 's/@Bounds = \((.*),(.*),(.*),(.*),(.*),(.*)\);/@Bounds = \(\1,\2,\3,\4,-\6,\6);/g' MergedBoxesParameters.perl
# perl -i -p0e 's/zExtents = q\((.*)\);/zExtents = q\(2*\1-1\);/g' InspiralSubstitutions.perl
# DoMultipleRuns -n
# cd $LASTRUN_DIR && qsub Submit.sh
