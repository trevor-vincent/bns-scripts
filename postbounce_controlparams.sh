#!/bin/bash

#$1 is the Cpdir
#$2 is the Cptime
function write_controlparams_template {
    cat <<EOF1 > ControlParams_new.input

DataBoxItems=
    Domain
    (Items =
     FunctionVsTime(Output        =PitchAndYawAngles;
                    FunctionVsTime=
                    SettleToConstant(
                    MatchTime = $2;
                    DecayTime = 50;
                      InitialData = FromFnVsTime3rdDeriv(
                        FnVsTime=NthTimeDeriv
                      (DerivOrder      = 2;
                       FileBaseName    = FuncPitchAndYaw;
                       ComponentLabels = Specified(Labels=Pitch,Yaw);
                       ForceReplayMode = true;
                       HistoryFile     = $1/../../Hist-FuncPitchAndYaw.txt;
                       InitialData     = FromCheckpointFile
                       (File=$1/Cp-FuncPitchAndYaw.txt;
                        Time=$2;
                        Eps =1e-10;
                        );
                       );
                     );
                    );
                    ),
     FunctionVsTime(Output        =ExpansionFactor;
                    FunctionVsTime=
                    SettleToConstant(
                    MatchTime = $2;
                    DecayTime = 10;
                      InitialData = FromFnVsTime3rdDeriv(
                        FnVsTime=NthTimeDeriv
		          (DerivOrder     =2;
		           FileBaseName   =FuncExpansionFactor;
		           ComponentLabels=Specified(Labels=a);
                           ForceReplayMode = true;
                           HistoryFile     = $1/../../Hist-FuncExpansionFactor.txt;
		           InitialData    =FromCheckpointFile
		           (File=$1/Cp-FuncExpansionFactor.txt;
		            Time=$2;
		            Eps =1e-10;
		            );
                      );
                     );
                    );
                    ),

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
Cpdir="$OLD_RUN/Run/Checkpoints/$LAST_CHK"

cd $NEW_RUN
OLDTIME=$(cat ControlParams.input | grep " Time=" | head -n1 | cut -d '=' -f2 | cut -d ';' -f1)
write_controlparams_template $Cpdir $Cptime

line1="$(cat -n ControlParams.input | grep Translation | head -n1 | cut -d 'F' -f 1)"
lineEnd="$(wc -l ControlParams.input | cut -d ' ' -f 1)"
#echo $line1
#echo $lineEnd

lineSep=$(echo "$lineEnd - $line1 + 1" | bc -l)
#echo $lineSep
cat ControlParams.input | tail -n ${lineSep} >> ControlParams_new.input

sed -i "s/${OLDTIME}/${Cptime}/g" ControlParams_new.input
sed -i "/Cp-FuncTranslation.txt/c\                     (File=${Cpdir}\/Cp-FuncTranslation.txt;" ControlParams_new.input

mv ControlParams.input ControlParams_old.input
mv ControlParams_new.input ControlParams.input
