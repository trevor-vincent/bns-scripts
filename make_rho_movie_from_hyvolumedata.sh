#!/bin/bash

function write_ao_input {
    cat <<EOF1 > ApplyObservers.input
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
           OrigCenter = 0,0,0;
           OrigSize = $1, $2, $3;
           HiResCenter = 0,0,0;
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
           ),
    ;

 Observers =
    ObserveInSubdir
    (Subdir=DataForMovies;
    Observers =
    InterpolateToRectangularGrid(
    Input = Rho0Phys;
    Output = Rho0Phys_vert.dat;
    Lower = -180,0,-90;
    Upper = 180,0,90;
    Extents = 201,1,101;
    TerminateOnPointsOutside = no;
    Precision = 16;
    TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
    SpatialCoordMap = GridToInertialFD::SpatialCoordMap;
    Format = AsciiCoords;
    OutputTime = yes;
    ),
    InterpolateToRectangularGrid(
    Input = Rho0Phys;
    Output = Rho0Phys_hori.dat;
    Lower = -180,-180,0;
    Upper = 180,180,0;
    Extents = 201,201,1;
    TerminateOnPointsOutside = no;
    Precision = 16;
    TopologicalInterpolator = CappedPolynomial(PolyOrder=4;);
    SpatialCoordMap = GridToInertialFD::SpatialCoordMap;
    Format = AsciiCoords;
    OutputTime = yes;
    );
    );

EOF1

}

XBOUND=$1 #x bound of coarsest level domain
YBOUND=$2
ZBOUND=$3

if [ "$#" -ne 3 ]; then
    echo "Must have 3 options"
    echo "make_rho_movie_from_hyvolumedata.sh XBOUND YBOUND ZBOUND"
    exit
fi

#cd "${CHECKPOINT_DIR}_withtracers"
#echo "Currently at ${PWD}"
cp ../*Spatial* .
cp ../*.input .
cp ../*Hist* .
cp ../*Regrid* .

if [ ! -f Hist-FuncRegridShift.txt ]; then
    if [ -f Hist-FuncRegridScale.txt ]; then
    cp Hist-FuncRegridScale.txt Hist-FuncRegridShift.txt && sed -i 's/ax=.*;ay=.*;az=.*;/dx=0;dy=0.;dz=0.;/g' Hist-FuncRegridShift.txt
    else
	echo "No Hist-FuncRegridScale.txt"
	exit
    fi
fi

write_ao_input $XBOUND $YBOUND $ZBOUND

ApplyObservers -NoDomainHistory -domaininput ../HyDomain.input -t Rho0Phys -r Scalar ./ApplyObservers.input

cd DataForMovies 
make_movie_rho0.py Rho0Phys_hori.dat 220
make_movie_rho0.py Rho0Phys_vert.dat 220
