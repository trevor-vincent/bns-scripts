#!/bin/bash

#$1 is Lev which is usually 0
#$2 is r1 from EvolutionParameters.perl
#$3 is d (separation) from EvolutionParameters.perl
#$4 is Cptime from Evolution.input

function write_grdomain_template {
echo $1
echo $2
echo $3
echo $4
    cat <<EOF1 > GrDomain_new.input

# files for AMR
ReadFromFiles = RefinementOptionHistory.input;

SubdomainStructure=
#########################
# Interior of SphereC
#########################
  FilledSphere3D (
        BaseName = FilledSphere;
      L = 12 + 2*${1};
      Center= 0,0,0; 
      rmax = ${2} * 3./8.2;
        RadialMap = Lin;
        ForceIgnoreRefinementOptionHistory=true;
        ),

    SphericalShells3D (
        BaseName = SphereInner;
        L = 12+2*${1}; # Bela says having the same L everywhere is better used to be 9
        r-Axis = (
            Extents  = 39*(7+${1}); # lots of tiny shells, all the same number of points as FilledSphere
            Bounds   = ${2} * 3./8.2,2.5*${3};
	    SplitFactor = 39;
            Maps     = Lin;
            IndexMap = ChebyshevGaussLobatto;
            Topology = I1;
        );
    ),


################################
# SphereC
################################
    SphericalShells3D(BaseName=SphereC;
                      Center=0,0,0;
                      L=12+2*${1};
                      r-Axis=( Extents= 200+40*${1};
                               SplitFactor=20;
                               Bounds= 2.5*${3},40*${3};
                               Maps=Lin;
                               IndexMap=ChebyshevGaussLobatto;
                               Topology=I1; 
                               );
                      );

BoundaryInfo = (
                WarningLevel = 0;
                );

FileBaseName=GrDomain;

IgnoreCheckpointFileAtRestart=UseInitialData(Time=${4};
                Eps=1.e-8;);


EOF1
}

OLD_RUN=$1
NEW_RUN=$2

EV_DIR="/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/"
ID_DIR="/scratch/p/pfeiffer/tvincent/BNS_Disks_project/InitialData/"

RUN_NAME="$(echo ${NEW_RUN} | grep -o 'nsns.*' | cut -d '/' -f 1)"

echo ${RUN_NAME}

cd "$ID_DIR/$RUN_NAME/EvID/"
r1="$(cat EvolutionParameters.perl | grep "r1" | cut -d '=' -f 2 | cut -d ';' -f 1)"
ddd="$(cat EvolutionParameters.perl | grep "_d" | cut -d '=' -f 2 | cut -d ';' -f 1)"


cd $OLD_RUN
cd Run
cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | sort -n | tail -n1)"
cd $LAST_CHK
Cptime=$(cat Cp-GrDomain.txt | cut -d ';' -f 1 | cut -d '=' -f 2)
Cpdir="$OLD_RUN/Run/Checkpoints/$LAST_CHK"


echo $r1
echo $ddd
echo $Cptime


cd $NEW_RUN

write_grdomain_template 0 "$r1" "$ddd" "$Cptime"

mv GrDomain.input GrDomain_old.input
mv GrDomain_new.input GrDomain.input
