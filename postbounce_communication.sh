#!/bin/bash


OLD_RUN=$1
NEW_RUN=$2

function write_communication {

cat <<EOF > Communication_new.input

InterpolatorForSource1   =  NonBlocking(
                TopologicalInterpolator=Polynomial(MaxPointsPerDim=60;PolyOrder=4);
                # only some GR subdomains contribute to interpolation,
                # interpolation might be cheap however
                DistributePoints = AdaptiveNoWeight();
                ChooseSubdomain  = ClosestPoint();
                );
InterpolatorForSource2   =  NonBlocking(
                TopologicalInterpolator=CappedPolynomial(PolyOrder=4;);
                # All hydro points need interpolation and interpolation is
                # cheap, so we do not want to move data around
                DistributePoints = OnSource();
                ChooseSubdomain = FinestLevel(MinimumDistance=3);
                );

HydroMapStringName = MapBetweenDomainsString;

#Always use this and set to true
AddSyncHydroConsvStateChanger = true;

EpsilonForInterpolator  = 1.e-6;
HySystem=Hydro(MetricDimension=3;
    MetricPrefix=trueMoving;
    DerivPrefix=Spectrald;
               );
GrSystem=GeneralizedHarmonic(SpatialDimension=3; SourceType=Primitives;);


ItemsToLinkFromBox1ToBox2 =
  PitchAndYawAngles,ExpansionFactor,Translation,ExpansionFactorOuterBdry,
  GridToSpectralInertial::SpatialCoordMap;
ItemsToLinkFromBox2ToBox1 =
  CoM-NSA-SpectralFrame,CoM-NSB-SpectralFrame,DenseMaxOverDenseMax0,
  RegridSwitchFvT, RegridScaleFvT, RegridShiftFvT,
  InverseMapBetweenDomains::SpatialCoordMap;

EvolutionType=Together;
CommunicationMethod = TimeInterp;
GhostZoneMaskName = None; # there is a bug otherwise where outer boundaries get the wrong metric
IgnoreCheckpointFileAtRestart=UseInitialData(Time=$1; Eps=1e-10);

EOF
}


cd $OLD_RUN
cd Run
cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | sort -n | tail -n1)" 
cd $LAST_CHK
Cptime=$(cat Cp-GrDomain.txt | cut -d ';' -f 1 | cut -d '=' -f 2)
Cpdir="$OLD_RUN/Run/Checkpoints/$LAST_CHK"

cd $NEW_RUN
write_communication $Cptime
mv Communication.input Communication_old.input
mv Communication_new.input Communication.input