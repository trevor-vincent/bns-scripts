
function write_evolve_vars {

cat <<EOF > AddToEvolution.input

HyCopyFromSetupToEvolution=
    Rho(  Dim=3; Sym=;   Input=Rho;),
    Tau(  Dim=3; Sym=;   Input=Tau;),
    Sflux(Dim=3; Sym=1;  Input=Sflux;),
    ECons_nue(Dim=3; Sym=;   Input=ECons_nue),
    FCons_nue(Dim=3; Sym=1;   Input=FCons_nue),
    NCons_nue(Dim=3; Sym=;   Input=NCons_nue),
    ScatteringFraction_nue(Dim=3; Sym=;   Input=ScatteringFraction_nue),
    ClosureXi_nue(Dim=3; Sym=;   Input=ClosureXi_nue),
    ECons_nua(Dim=3; Sym=;   Input=ECons_nua),
    FCons_nua(Dim=3; Sym=1;   Input=FCons_nua),
    NCons_nua(Dim=3; Sym=;   Input=NCons_nua),
    ScatteringFraction_nua(Dim=3; Sym=;   Input=ScatteringFraction_nua),
    ClosureXi_nua(Dim=3; Sym=;   Input=ClosureXi_nua),
    ECons_nux(Dim=3; Sym=;   Input=ECons_nux),
    FCons_nux(Dim=3; Sym=1;   Input=FCons_nux),
    NCons_nux(Dim=3; Sym=;   Input=NCons_nux),
    ScatteringFraction_nux(Dim=3; Sym=;   Input=ScatteringFraction_nux),
    ClosureXi_nux(Dim=3; Sym=;   Input=ClosureXi_nux),
#     TracerX(Dim=3; Sym=1; Input=TracerX;),
      RhoYe(Dim=3; Sym=; Input=RhoYe),
    ; # END CopyFromSetupToEvolution

EOF
    }




function write_nuevolution {

cat <<EOF > NuEvolution.input

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

        LapseF = LapseF;
        ShiftF=ShiftF;
        MetricF=gF;
        DetMetricF=DetgF;
        ReconstructionMethod = MM2;

        ATol = 1.e-3;
        RTol = 1.e-2;
        );

EOF
}


if [ "$#" -ne 3 ]; then
    echo "convert_to_new_m1_scheme.sh OLD_SEGMENT NEW_SEGMENT <sfho,dd2,ls220>"
    echo "if eos is not sfho or dd2 then it defaults to ls220"
    exit
fi


cd $1
cd Run
cd Checkpoints
LAST_CHK="$(ls | grep '[0-9]\+' | sort -n | tail -n1)"
cd $LAST_CHK
Cptime=$(cat Cp-GrDomain.txt | cut -d ';' -f 1 | cut -d '=' -f 2)
changeh5tograynames.sh

cd $2

sed -i '19,22s/^/#/g' HyStateChangers.input
sed -i '25,27s/^/#/g' HyStateChangers.input
sed -i '69,170s/^/#/g' HyStateChangers.input
sed -i "/FollowTracerParticles.*/a  \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ NeutrinoSpecies=nue,nua,nux;" Evolution.input
sed -i '78,84s/^/#/g' Evolution.input
sed -i "/FollowTracerParticles.*;/a \ \ \ \ \ \ \ \ \ \ \ NeutrinoSpecies=nue,nua,nux;" HySetupAndEvolution.input
sed -i '180,184s/^/#/g' HyDataBoxItems.input
sed -i 's/NeutrinoItems.input/NeutrinoMomentsItems.input/g' HyDataBoxItems.input
write_evolve_vars
#sed '90 e sed -n AddToEvolution.input' Evolution.input > Evolution_new.input
cp /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/NeutrinoMomentsItems.input .
#sed '3r '<(sed -n '2,4p;5q' file2) file1
sed -i '85r AddToEvolution.input' Evolution.input
write_nuevolution $Cptime

if [ "$3" == "sfho" ]; then
    sed -i 's/LS220/SFHo/g' NeutrinoMomentsItems.input
fi

if [ "$3" == "dd2" ]; then
    sed -i 's/LS220/HempDD2/g' NeutrinoMomentsItems.input
fi

