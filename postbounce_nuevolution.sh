#!/bin/bash

function write_nuevolution_template {
    cat <<EOF1 > NuEvolution_new.input

RestartTime=$1;

ComputeRhsNeutrinoMoments =
        (
        Lapse = Lapse;
        Shift = Shift;
        Metric = g;
        InvMetric = Invg;
        DetMetric = Detg;
        ExtrinsicCurvature = K;
        dLapse = dLapse;
        dShift = dShift;
        dMetric = dg;

        OpacityTable = FromNumberEvolution;
        ScatteringCoefficient=6.;
        UseFreeEmissionAtLowTau = false;

        LapseF = LapseF;
        ShiftF=ShiftF;
        MetricF=gF;
        DetMetricF=DetgF;
        ReconstructionMethod = MM2;
        DoRedshift= false;

        ATol = 1.e-3;
        RTol = 1.e-2;
        );

EOF1
}

OLD_RUN=$1
NEW_RUN=$2

cd $NEW_RUN
Cptime="$(cat Evolution.input | grep StartTime | cut -d '=' -f 2 | cut -d ';' -f 1)"

write_nuevolution_template $Cptime
mv NuEvolution.input NuEvolution_old.input
mv NuEvolution_new.input NuEvolution.input
