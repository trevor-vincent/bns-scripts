#!/bin/bash

function write_hydomain_template {
    cat <<EOF1 > HyDomain_new.input

 SubdomainStructure=
 PerimBlocks(BaseName = IntervalLev1_;
         x-Axis = (Extents = ${1};
                 Bounds = -${2},${2};
                 SplitIntervals=$3;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
         y-Axis = (Extents = $4;
                 Bounds = -$5,$5;
                 SplitIntervals=$6;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
         z-Axis = (Extents = $7;
                 Bounds = -$8,$8;
                 SplitIntervals=$9;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
 ),
 PerimBlocks(BaseName = IntervalLev0_;
         x-Axis = (Extents = $1;
                 Bounds = -2*$2,2*$2;
                 SplitIntervals=$3;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
         y-Axis = (Extents = $4;
                 Bounds = -2*$5,2*$5;
                 SplitIntervals=$6;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
         z-Axis = (Extents = $7;
                 Bounds = -2*$8,2*$8;
                 SplitIntervals=$9;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
 ),
;

FileBaseName=HyDomain;

EOF1
}

OLD_RUN="$1"
NEW_RUN="$2"

cd $OLD_RUN
cd Run

expansion_factor="$(cat Hist-FuncExpansionFactor.txt | tail -n1 | cut -d ';' -f 6 | cut -d '=' -f 2)"

cd $NEW_RUN

echo $expansion_factor

X1_lev1_new=$(echo ".3/(2. * ${expansion_factor} * 1.48/200)" | sed -e 's/[eE]+*/\*10\^/' | bc -l )
Z1_lev1_new=$(echo ".3/(2. * ${expansion_factor} * 1.48/100)" | sed -e 's/[eE]+*/\*10\^/' | bc -l )
write_hydomain_template 201 $X1_lev1_new 12 201 $X1_lev1_new 4 101 $Z1_lev1_new 4

mv HyDomain.input HyDomain_old.input
mv HyDomain_new.input HyDomain.input


cd $OLD_RUN
X1_lev1_old="$(cat HyDomain.input | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Y1_lev1_old="$(cat HyDomain.input | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Z1_lev1_old="$(cat HyDomain.input | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
dxFD_old=$(cat HySetupAndEvolution.input | grep CubicalBoundary | cut -d '*' -f 3 | cut -d ')' -f1)

cd $NEW_RUN
X1_lev1="$(cat HyDomain.input | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Y1_lev1="$(cat HyDomain.input | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Z1_lev1="$(cat HyDomain.input | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
echo "s/${Y1_lev1}/${X1_lev1}/g"

sed -i "s/${X1_lev1_old}/${X1_lev1}/g" *.input
sed -i "s/${Y1_lev1_old}/${Y1_lev1}/g" *.input
sed -i "s/${Z1_lev1_old}/${Z1_lev1}/g" *.input

dxFD_new=$(source "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/postbounce_dxfd.sh")
sed -i "s/${dxFD_old}/${dxFD_new}/g" *.input