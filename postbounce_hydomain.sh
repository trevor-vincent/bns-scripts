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

X1_lev1="$(cat HyDomain.input | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_x_lev1="$(cat HyDomain.input | grep Extents | head -n1 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

Y1_lev1="$(cat HyDomain.input | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_y_lev1="$(cat HyDomain.input | grep Extents | head -n2 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

Z1_lev1="$(cat HyDomain.input | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_z_lev1="$(cat HyDomain.input | grep Extents | head -n3 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

splitx_lev1="$(cat HyDomain.input | grep SplitIntervals | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ';' -f 1)"
splity_lev1="$(cat HyDomain.input | grep SplitIntervals | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ';' -f 1)"
splitz_lev1="$(cat HyDomain.input | grep SplitIntervals | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ';' -f 1)"


expansion_factor="$(cat Hist-FuncExpansionFactor.txt | tail -n1 | cut -d ';' -f 6 | cut -d '=' -f 2)"

echo "2 * ${X1_lev1} * ${expansion_factor} * 1.48 * (1./.3)"
#we want 300m which is .3 in km and 1.48 is the conversion between geometric units of length to km
Extents_x_new=$(echo "2 * ${X1_lev1} * ${expansion_factor} * 1.48 * (1./.3)" | sed -e 's/[eE]+*/\*10\^/' | bc -l )
echo $Extents_x_new
Extents_x_new_rnded=$(printf "%.0f\n" ${Extents_x_new})

Extents_z_new=$(echo "2 * ${Z1_lev1} * ${expansion_factor} * 1.48 * (1./.3)" | sed -e 's/[eE]+*/\*10\^/' | bc -l )
echo $Extents_z_new
Extents_z_new_rnded=$(printf "%.0f\n" ${Extents_z_new})

echo $X1_lev1 $Extents_x_new_rnded $Y1_lev1 $Extents_x_new_rnded $Z1_lev1 $Extents_z_new_rnded

cd $NEW_RUN

write_hydomain_template $Extents_x_new_rnded $X1_lev1 12 $Extents_x_new_rnded $X1_lev1 4 $Extents_z_new_rnded $Z1_lev1 4


mv HyDomain.input HyDomain_old.input
mv HyDomain_new.input HyDomain.input
