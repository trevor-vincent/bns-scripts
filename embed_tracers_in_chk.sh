#!/bin/bash

function write_ao_input {
    cat <<EOF1 > ApplyObservers-Tracer.input
DataBoxItems =
   ReadFromFile(File=SpatialCoordMap.input),   
    Domain(Items =
            EvaluateScalarFormula(Formula=0.0*A+1.0;A=Rho;Output=ExcisionMask),
    	      AddString(Output=ExcisionMaskName; Value=ExcisionMask),	    

          #******************************************
           #****  Regridder and maps *****************
           #******************************************
           FunctionVsTime(
           Output = RegridSwitchFvT;
           FunctionVsTime =
           NthTimeDeriv(
           DerivOrder=0;
           ComponentLabels = Specified(Labels=Switch;);
           InitialData=Values(Tstart=0.;f=0.;);
           FileBaseName=FuncRegridSwitch;
           );
           ),
           FunctionVsTime(
           Output = RegridShiftFvT;
           FunctionVsTime =
           NthTimeDeriv(
           DerivOrder=0;
           ComponentLabels = Specified(Labels=dx,dy,dz;);
           InitialData=Values(Tstart=0.;f=0.,0.,0.;);
           FileBaseName=FuncRegridShift;
           );
           ),
           FunctionVsTime(
           Output = RegridScaleFvT;
           FunctionVsTime =
           NthTimeDeriv(
           DerivOrder=0;
           ComponentLabels = Specified(Labels=ax,ay,az;);
           InitialData=Values(Tstart=0.;f=1.,1.,1.;);
           FileBaseName=FuncRegridScale;
           );
           ),
           RegridderMapBhNsComputeItem(
           Output = MapBetweenDomainsString;
           OrigCenter = 0.,0.,0.;
           OrigSize = $4, $5, $6;
           HiResCenter = 0.,0.,0.;
           HiResRadius = 100000.;
           HiResFraction = 0.125;
           RelGridSize = RegridScaleFvT;
           RelGridShift = RegridShiftFvT;
           ),
           RegridderGetMapFromString(
           Output     = MapBetweenDomains::SpatialCoordMap;
           StringName = MapBetweenDomainsString;
           InvertMap  = false;
           ),
           RegridderGetMapFromString(
           Output     = InverseMapBetweenDomains::SpatialCoordMap;
           StringName = MapBetweenDomainsString;
           InvertMap  = true;
           ),
           ComposeMapsFromDataBoxComputeItem
           (
           Output = GridToInertialFD::SpatialCoordMap;
           InitialMap = MapBetweenDomains::SpatialCoordMap;
           FinalMap   = GridToSpectralInertial::SpatialCoordMap;
           ),
           SpatialCoordMapItems
           (
           MapIsInDataBox = yes;
           Prefix=GridToInertialFD;
           InputCoords=<<Grid>>;
           ),
           SpatialCoordMapItems
           (
           MapIsInDataBox = yes;
           Prefix=MapBetweenDomains;
           InputCoords=<<Grid>>;
           ),
           TracerGrid(
                      Extents = $1,$2,$3;
                      Xbounds =  -$4,$4;
                      Ybounds = -$5,$5; 
                      Zbounds = -$6,$6;
                      MinDensity = 1e-12;
                      MaxDensity = 1.;
                      MapForGrid = GridToInertialFD::SpatialCoordMap;
                      MapForFunctions = None;
                      Interpolator = NonBlocking
                      (
                       TopologicalInterpolator = ExcisionCappedPolynomial(StrictCapNearExcision=true;);
                       DistributePoints = AdaptiveNoWeight();
                       ChooseSubdomain  = FarthestFromBoundary(TerminateOnPointsOutside=true;);
                       );
                      Output=TracerX;
                      ), # End TracerGrid
           ),
    Subdomain(Items =
            EvaluateScalarFormula(Formula=0.0*A+1.0;A=Rho;Output=ExcisionMask),
    	      AddString(Output=ExcisionMaskName; Value=ExcisionMask),
              CopyTracerFromParent(Input=TracerX; Output=TracerX;),
              ),

    ;


Observers =
    ObserveInSubdir
    (
     Subdir = TracerData;
     Observers =
     (
      DumpTensors(Input=TracerX;),
      ); # END Observers
     ), # END ObserveInSubdir
    ; # END Observers

EOF1

}

CHECKPOINT_PARENT_DIR=$1
CHECKPOINT_DIR=$2
NX=$3 #number of tracer boxes in the x-direction
NY=$4
NZ=$5
XBOUND=$6 #x bound of coarsest level domain
YBOUND=$7
ZBOUND=$8
RUN_DIR=$9


if [ "$#" -ne 9 ]; then
    echo "Must have 9 options"
    echo "embed_tracers_in_chk.sh /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_ls220_d30_m1.32_m1.2_paramfromlev4_nosym_M1/Ev/Lev0_AE-Merger/Lev0_BH/Run/Checkpoints/OTHER 17921_orig 135 135 135 2*29.125811440143 2*12.3939623149545 2*11.154566083459 /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_ls220_d30_m1.32_m1.2_paramfromlev4_nosym_M1/Ev/Lev0_AE-Merger/Lev0_BH/Run/"

echo $CHECKPOINT_PARENT_DIR
echo $CHECKPOINT_DIR
echo $NX #number of tracer boxes in the x-direction
echo $NY
echo $NZ
echo $XBOUND #x bound of coarsest level domain
echo $YBOUND
echo $ZBOUND
echo $RUN_DIR
    
    exit
fi

echo $CHECKPOINT_PARENT_DIR
echo $CHECKPOINT_DIR
echo $NX #number of tracer boxes in the x-direction
echo $NY
echo $NZ
echo $XBOUND #x bound of coarsest level domain
echo $YBOUND
echo $ZBOUND
echo $RUN_DIR
#exit

cd $CHECKPOINT_PARENT_DIR

if [ ! -d ${CHECKPOINT_DIR}_withtracers ]; then
   cd $CHECKPOINT_DIR
   rsync -ah --progress * ../${CHECKPOINT_DIR}_withtracers
fi

#echo $CHECKPOINT_PARENT_DIR
#exit

cd "${CHECKPOINT_DIR}_withtracers"
echo "Currently at ${PWD}"
#cp $RUN_DIR/*Spatial* .
cp $RUN_DIR/*.input .
cp $RUN_DIR/*Hist* .
cp $RUN_DIR/*Regrid* .

if [ ! -f Hist-FuncRegridShift.txt ]; then
    cp Hist-FuncRegridScale.txt Hist-FuncRegridShift.txt && sed -i 's/ax=.*;ay=.*;az=.*;/dx=0;dy=0.;dz=0.;/g' Hist-FuncRegridShift.txt
fi

write_ao_input $NX $NY $NZ $XBOUND $YBOUND $ZBOUND

if [ ! -d ./TracerData ]; then
    ApplyObservers -NoDomainHistory -h5prefix='Cp-Vars' -domaininput ./HyDomain.input -t Rho -r Scalar ./ApplyObservers-Tracer.input
fi

cd TracerData
for filename in Vars_Interval*.h5; do h5copy -v -i ./$filename -o ../Cp-$filename -s TracerX -d TracerX; done;
