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
 PerimBlocks(BaseName = IntervalLev1m_;
         x-Axis = (Extents = $1;
                 Bounds = -4*$2,4*$2;
                 SplitIntervals=$3;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
         y-Axis = (Extents = $4;
                 Bounds = -4*$5,4*$5;
                 SplitIntervals=$6;
                 Maps = Lin;
                 IndexMap = Uniform;
                 Topology = I1;
                 GhostZones = 3;
                 GhostZonesOnBoundary=true;
         );
         z-Axis = (Extents = $7;
                 Bounds = -4*$8,4*$8;
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

X1_lev1="$(cat HyDomain.input | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_x_lev1="$(cat HyDomain.input | grep Extents | head -n1 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

Y1_lev1="$(cat HyDomain.input | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_y_lev1="$(cat HyDomain.input | grep Extents | head -n2 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

Z1_lev1="$(cat HyDomain.input | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Extents_z_lev1="$(cat HyDomain.input | grep Extents | head -n3 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

splitx_lev1="$(cat HyDomain.input | grep SplitIntervals | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ';' -f 1)"
splity_lev1="$(cat HyDomain.input | grep SplitIntervals | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ';' -f 1)"
splitz_lev1="$(cat HyDomain.input | grep SplitIntervals | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ';' -f 1)"

write_hydomain_template $Extents_x_lev1 $X1_lev1 12 $Extents_y_lev1 $Y1_lev1 4 $Extents_z_lev1 $Z1_lev1 4

mv HyDomain.input HyDomain_old.input
mv HyDomain_new.input HyDomain.input

sed -i "s/2\*(${X1_lev1}/4\*(${X1_lev1}/g" HyStateChangers.input HySetupAndEvolution.input
sed -i "s/2\*(${Z1_lev1}/4\*(${Z1_lev1}/g" HyStateChangers.input HySetupAndEvolution.input
sed -i "s/2\*${X1_lev1}/4\*${X1_lev1}/g" HyDataBoxItems.input
sed -i "s/2\*${Z1_lev1}/4\*${Z1_lev1}/g" HyDataBoxItems.input
