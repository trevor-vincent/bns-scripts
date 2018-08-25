#!/bin/bash

function write_grstatechangers2_template {

    cat <<EOF1 > GrStateChangers_new.input
                                                                                                                                          
StateChangers =
    Translation(EventTriggerForApply=EveryChunk;
                DenseTriggerForUpdate=ChunkFraction;
                ApplyGoesAfter=RegridUpdateGrSources;
                UpdateDependsOn=CenterOfMassIA,CenterOfMassIB,
                                CenterOfMassSA,CenterOfMassSB;),
    ControlChunks(EventTriggerForApply= EveryChunk;
                  ApplyDependsOn      = Translation);

StateChangerEventTriggers =
    EveryChunk(Trigger=EveryNChunks(NChunks=1;NoTriggerOnZero=yes)),
    EveryStep(Trigger=EveryNSteps(NSteps = 1; NoTriggerOnZero = no;));

StateChangerDenseTriggers =
    AhTrigger(Trigger=
              Or(DenseTriggers =
                 EveryChunk(NoTriggerOnZero=no),
                 StepAfterChunkFraction(NoTriggerNearChunkEps=0.001;
                                        TstartIsStartOfChunk =yes;
                                        Frac=0.25;),
                 EveryDeltaT(DeltaT=0.1);
             );
    ),
    EveryStep(Trigger=EveryNSteps(NSteps = 1; NoTriggerOnZero = no;)),
    ChunkFraction(Trigger=StepAfterChunkFraction(Frac=0.25;
                                                 TstartIsStartOfChunk=yes;
                                                 NoTriggerNearChunkEps=0.001;)),
    ObserveTrigger(Trigger=EveryDeltaT(DeltaT=0.1));

StateChangerTags =
    Translation(
      StateChanger=
      ControlNthDeriv(
       FunctionVsTime=Translation;
       MeasureControlParam=
       Translate3dTwoAH(PointA=CoM-NSA-SpectralFrame;
                        PointB=CoM-NSB-SpectralFrame;
                        $1 #CenterA=14.9277,0,0;
                        $2 #CenterB=-17.9216,0,0;
                        ExpansionFactor=ExpansionFactor;
                        PitchAndYaw=PitchAndYawAngles;
       );
       TimescaleTuner =
       Simple(MaxThreshold      = 0.001;
              IncreaseFactor = 1.01;
              DecreaseFactor = 0.99;
              MinDampTime = 0.1;
              MaxDampTime = 30;
              InitialState   =
              $3 #Specified(Tdamping = 12.9973484223/10.;);
              # we cannot use the checkpointed timescales since we discretly
              # changed the system so the tuners need to be tightened
              #FromCheckpointFile(File=${4}/Cp-TdampTrans.txt;
              #                   Time=${5};
              #                   Eps=1e-6;
              #);
              CheckpointFile =
               Cp-TdampTrans.txt;
       );
       Averager=Exp(
                    Taverage = Fraction(Value = 0.2);
                    CheckpointFile=Cp-AvgTranslation.txt;
                    InitialState =
                    FromCheckpointFile(File=${4}/Cp-AvgTranslation.txt;
                                       Time=${5};
                                       Eps=1e-6;
                                       );
       );
       Controller = PNd();
      );
    ),
    ################  Time step and chunk size ##################
    ControlChunks(
      StateChanger=
      #=========================================================================
      # chunk size control
      #=========================================================================
      AdjustSubChunksToDampingTimes
      (TstateOverTdamp = 0.3;
       DiagnosticFile  = AdjustSubChunksToDampingTimes.dat;
      );
      );

EOF1

}


OLD_RUN=$1
NEW_RUN=$2

cd $OLD_RUN
cd Run
cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | sort -n | tail -n1)" 
cd $LAST_CHK
Cptime=$(cat Cp-GrDomain.txt | cut -d ';' -f 1 | cut -d '=' -f 2)
Cpdir="${OLD_RUN}/Run/Checkpoints/$LAST_CHK"

cd $NEW_RUN

centerAline="$(cat GrStateChangers.input | grep CenterA | head -n1)"
centerBline="$(cat GrStateChangers.input | grep CenterB | head -n1)"
tdampingline="$(cat GrStateChangers.input | grep Tdamping | head -n1)"

echo "centerAline = $centerAline"
echo "centerBline = $centerBline"
echo "tdampingline = $tdampingline"
echo "Cpdir = $Cpdir"
echo "Cptime = $Cptime"

write_grstatechangers2_template "$centerAline" "$centerBline" "$tdampingline" "$Cpdir" "$Cptime"
mv GrStateChangers.input GrStateChangers_old.input
mv GrStateChangers_new.input GrStateChangers.input
sed -i 's/\/exec5\/GROUP\/tvincent\/tvincent/\/scratch/p/pfeiffer\/tvincent/g' *.input