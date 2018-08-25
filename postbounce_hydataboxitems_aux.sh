#!/bin/bash

OLD_RUN=$1
NEW_RUN=$2

cd $NEW_RUN

function write_boundarymaskstuff_template {
    cat <<EOF1 > BoundaryMaskStuff.input
                                   
               GhostZoneBoundaryMask(
                Output=BoundaryMask;
             ),
             EvaluateScalarFormula(
             A=GhostZoneMask; B=BoundaryMask;
             Output=GhostZoneMaskForComm;
             Formula = (1-B) + B*A;
             ),
             DistanceFromMaskWithinSubdomain(
             Mask=BoundaryMask;
             Output=DistanceFromBoundaryMask;
             ),
             EvaluateScalarFormula(A = Minusu_t;
                                   B = Rho;
                                   Formula = (A-1)*B;
                                   Output = Energy;),

EOF1
}


bottomchunk=$(cat HyDataBoxItems.input | wc -l)
cutat=$(cat -n HyDataBoxItems.input | grep "FaceMaskFromCellMask(CellMask=GhostZoneMask;)," | cut -d 'F' -f1)
rest=`expr $bottomchunk - $cutat`

write_boundarymaskstuff_template
cat <(cat HyDataBoxItems.input | head -n$cutat) BoundaryMaskStuff.input <(cat HyDataBoxItems.input | tail -n$rest) > HyDataBoxItems_wboundary.input
rm BoundaryMaskStuff.input
sed -i '281,284d' HyDataBoxItems_wboundary.input
mv HyDataBoxItems.input HyDataBoxItems_old2.input
mv HyDataBoxItems_wboundary.input HyDataBoxItems.input
