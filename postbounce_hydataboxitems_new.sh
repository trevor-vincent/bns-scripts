#!/bin/bash

function write_tracerdataboxitems_template {
    cat <<EOF1 > TracerDataBoxItems1.input
                                   
           InterpAtPoints(Function = vInertial;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerV;),
                InterpAtPoints(Function = Temp;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerT;),
                InterpAtPoints(Function = Rho0Phys;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerRho0Phys;),
                  InterpAtPoints(Function = Rho;
                                 Points = TracerX;
                                 Map = GridToInertialFD::SpatialCoordMap;
                                 TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                 TerminateOnPointsOutside = false;
                                 Symmetry = None;
                                 Output = TracerRho;),
                InterpAtPoints(Function = Entropy;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerS;),
                InterpAtPoints(Function = Ye;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerYe;),
                InterpAtPoints(Function = Energy;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerEnergy;),

                   InterpAtPoints(Function = g;
                                  Points = TracerX;
                                  Map = GridToInertialFD::SpatialCoordMap;
                                  TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                  TerminateOnPointsOutside = false;
                                  Symmetry = None;
                                  Output = Tracerg;),

                   InterpAtPoints(Function = Lapse;
                                  Points = TracerX;
                                  Map = GridToInertialFD::SpatialCoordMap;
                                  TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                  TerminateOnPointsOutside = false;
                                  Symmetry = None;
                                  Output = TracerLapse;),

                   InterpAtPoints(Function = Shift;
                                  Points = TracerX;
                                  Map = GridToInertialFD::SpatialCoordMap;
                                  TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                  TerminateOnPointsOutside = false;
                                  Symmetry = None;
                                  Output = TracerShift;),

                InterpAtPoints(Function = ECons_e;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerECons_e;),

                InterpAtPoints(Function = ECons_a;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerECons_a;),

                InterpAtPoints(Function = ECons_x;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerECons_x;),


                InterpAtPoints(Function = NCons_e;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerNCons_e;),

                InterpAtPoints(Function = NCons_a;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerNCons_a;),

                InterpAtPoints(Function = NCons_x;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerNCons_x;),

                InterpAtPoints(Function = FCons_e;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerFCons_e;),

                InterpAtPoints(Function = FCons_a;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerFCons_a;),

                InterpAtPoints(Function = FCons_x;
                                      Points = TracerX;
                                      Map = GridToInertialFD::SpatialCoordMap;
                                      TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
                                      TerminateOnPointsOutside = false;
                                      Symmetry = None;
                                      Output = TracerFCons_x;),

               CopyTracerFromChild(Input=TracerX; Output=TracerX;),
EOF1
}

OLD_RUN=$1
NEW_RUN=$2

cd $NEW_RUN

bottomchunk=$(cat HyDataBoxItems.input | wc -l)
cutat=$(cat -n HyDataBoxItems.input | grep "Domain (Items =" | cut -d 'D' -f1)
#rest=$(( $bottomchunk-$cutat ))
rest=`expr $bottomchunk - $cutat`
echo $bottomchunk
echo $cutat
echo $rest

write_tracerdataboxitems_template
cat <(cat HyDataBoxItems.input | head -n$cutat) TracerDataBoxItems1.input <(cat HyDataBoxItems.input | tail -n$rest) > HyDataBoxItems_new.input
rm TracerDataBoxItems1.input
sed -i '/Subdomain(Items =/a      CopyTracerFromParent(Input=TracerV;Output=TracerV;),' HyDataBoxItems_new.input
sed -i 's/ReadFromFile(File = NeutrinoItems.input),/ReadFromFile(File = NeutrinoItems.input),?                   ReadFromFile(File = NeutrinoItems2.input),/g' HyDataBoxItems_new.input
tr '?' '\n' < HyDataBoxItems_new.input > HyDataBoxItems_new_new.input
mv HyDataBoxItems.input HyDataBoxItems_old.input
rm -f HyDataBoxItems_new.input
mv HyDataBoxItems_new_new.input HyDataBoxItems.input

