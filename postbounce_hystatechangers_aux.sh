#!/bin/bash                                                                                                     

OLD_RUN=$1
NEW_RUN=$2


function write_hystatechangers1_aux {

cat <<EOF > hystatechangers1_aux.input
    ParticleFluxAtBoundary(DenseTriggerForApply=AhTrigger),
    UnboundParticleFluxAtBoundary(DenseTriggerForApply=AhTrigger),
    ParticlesAtBoundary_nue(DenseTriggerForApply=ParticleFluxTrigger),
    ParticlesAtBoundary_nua(DenseTriggerForApply=ParticleFluxTrigger),
    ParticlesAtBoundary_nux(DenseTriggerForApply=ParticleFluxTrigger),
EOF
}

function write_hystatechangers2_aux {

cat <<EOF > hystatechangers2_aux.input
ParticleFluxTrigger(Trigger=
                Or(DenseTriggers =
                EveryChunk(NoTriggerOnZero=no),
                StepAfterChunkFraction(NoTriggerNearChunkEps=0.001;
                                        TstartIsStartOfChunk =yes;
                                        Frac=.25;);
                );
                ),

EOF

}

function write_hystatechangers3_aux {

cat <<EOF > hystatechangers3_aux.input
         ParticlesAtBoundary_nue(
         StateChanger=
         FluxToParticlesAtBoundary(
         Flux = NeutrinoFluxe;
         GhostZoneMask = GhostZoneMask;
         DistanceDataMesh = DistanceFromBoundaryMask;
         MeasurementDistance = 7;
         AuxiliaryVariables = ENue,Eavg_e,FtGride,NuXi_nue;
         Coords=GridToInertialFD::MappedCoords;
         ParticleMass=1.e-9;
         FilePrefix=NueParticles;
         );
         ),
         ParticlesAtBoundary_nua(
         StateChanger=
         FluxToParticlesAtBoundary(
         Flux = NeutrinoFluxa;
         GhostZoneMask = GhostZoneMask;
         DistanceDataMesh = DistanceFromBoundaryMask;
         MeasurementDistance = 7;
         AuxiliaryVariables = ENua,Eavg_a,FtGrida,NuXi_nua;
         Coords=GridToInertialFD::MappedCoords;
         ParticleMass=1.e-9;
         FilePrefix=NuaParticles;
         );
         ),
         ParticlesAtBoundary_nux(
         StateChanger=
         FluxToParticlesAtBoundary(
         Flux = NeutrinoFluxx;
         GhostZoneMask = GhostZoneMask;
         DistanceDataMesh = DistanceFromBoundaryMask;
         MeasurementDistance = 7;
         AuxiliaryVariables = ENux,Eavg_x,FtGridx,NuXi_nux;
         Coords=GridToInertialFD::MappedCoords;
         ParticleMass=1.e-9;
         FilePrefix=NuxParticles;
         );
         ),


    ParticleFluxAtBoundary(
    StateChanger=
        FluxToParticlesAtBoundary(
        Flux = MatterFlux;
        GhostZoneMask = GhostZoneMask;
        DistanceDataMesh = DistanceFromBoundaryMask;
        MeasurementDistance = 7;
        AuxiliaryVariables=Rho0Phys,Ye,Temp,Minusu_t,Minusu_tH,vInertial;
        Coords=GridToInertialFD::MappedCoords;
        ParticleMass=1.e-8;
        FilePrefix=ParticlesFromOutflow;
        );
    ),
    UnboundParticleFluxAtBoundary(
    StateChanger=
        FluxToParticlesAtBoundary(
        Flux = MatterFluxH;
        GhostZoneMask = GhostZoneMask;
        DistanceDataMesh = DistanceFromBoundaryMask;
        MeasurementDistance = 7;
        AuxiliaryVariables=Rho0Phys,Ye,Temp,Minusu_t,Minusu_tH,vInertial;
        Coords=GridToInertialFD::MappedCoords;
        ParticleMass=1.e-8;
        FilePrefix=UnboundParticlesFromOutflow;
        );
    ),

EOF
}

cd $NEW_RUN

bottomchunk=$(cat HyStateChangers.input | wc -l)
cutat=$(cat -n HyStateChangers.input | grep "NeutrinoSekiFluxx(DenseTriggerForApply=ObsTime;)," | cut -d 'N' -f1)
rest=`expr $bottomchunk - $cutat`

echo $bottomchunk
echo $cutat
echo $rest
write_hystatechangers1_aux
cat <(cat HyStateChangers.input | head -n$cutat) hystatechangers1_aux.input <(cat HyStateChangers.input | tail -n$rest) > HyStateChangers_aux.input

bottomchunk=$(cat HyStateChangers_aux.input | wc -l)
cutat=$(cat -n HyStateChangers_aux.input | grep "StateChangerDenseTriggers =" | cut -d 'S' -f1)
rest=`expr $bottomchunk - $cutat`

echo $bottomchunk
echo $cutat
echo $rest
write_hystatechangers2_aux
cat <(cat HyStateChangers_aux.input | head -n$cutat) hystatechangers2_aux.input <(cat HyStateChangers_aux.input | tail -n$rest) > HyStateChangers_aux_aux.input

bottomchunk=$(cat HyStateChangers_aux_aux.input | wc -l)
cutat=$(cat -n HyStateChangers_aux_aux.input | grep "\*\*\*\*\*\*\*  Regridder \*\*\*\*\*\*\*\*" | cut -d '#' -f1)
echo $cutat
cutat=`expr $cutat - 1`
rest=`expr $bottomchunk - $cutat`

echo $bottomchunk
echo $cutat
echo $rest
write_hystatechangers3_aux
cat <(cat HyStateChangers_aux_aux.input | head -n$cutat) hystatechangers3_aux.input <(cat HyStateChangers_aux_aux.input | tail -n$rest) > HyStateChangers_aux_aux_aux.input

mv HyStateChangers.input HyStateChangers_old.input
mv HyStateChangers_aux_aux_aux.input HyStateChangers.input



