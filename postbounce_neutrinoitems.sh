#!/bin/bash

function write_neutrinoitems_template {
    cat <<EOF1 > NeutrinoItems_new.input
                                                      
DataBoxItems=
        Domain
        (
        Items =
        SyncGhostZones
        (
        Inputs=dJ_nu,dTau_nu,dRhoYe_nu,dSflux_nu;
        Dims = 3,3,3,3;
        Syms = Scalar,Scalar,Scalar,1;
        GhostZoneMover=GhostZoneMover;
        Densitize=false;
        Output=NuHCouplingGV;
        ),
        ),
        Subdomain
        (Items =
        TensorFromVars
        (
        Output=dJSync;
        NameOfTensor=dJ_nu;
        GlobalVarsInRootDataBox=NuHCouplingGV;
        ),
        TensorFromVars
        (
        Output=dSSync;
        NameOfTensor=dSflux_nu;
        GlobalVarsInRootDataBox=NuHCouplingGV;
        ),
        BinaryOp(A=dJSync; B=sDetg; Op =A/B; Output=dJnu),
        BinaryOp(A=dSSync; B=sDetg; Op =A/B; Output=dSnuGl),
        ContractVectorWithTensor(Output=dSnuGu; Vector=dSnuGl; Tensor=Invg; Index=0; Metric=None;),
        SpatialCoordMap::TransformTensorToDifferentFrame
        (Input=dSnuGu;Output=dSnu;IndexPositions=u;MapPrefixToOutputFrame=GridToInertialFD),
        ContractVectorWithTensor(Output=FaUp; Vector=FNua; Tensor=Invg; Index=0; Metric=None;),
        ContractVectorWithTensor(Output=FeUp; Vector=FNue; Tensor=Invg; Index=0; Metric=None;),
        ContractVectorWithTensor(Output=FxUp; Vector=FNux; Tensor=Invg; Index=0; Metric=None;),
        BinaryOp(A=FaUp; B=ENua; Op=A/B; Output=FoEa;),
        BinaryOp(A=FeUp; B=ENue; Op=A/B; Output=FoEe;),
        BinaryOp(A=FxUp; B=ENux; Op=A/B; Output=FoEx;),
        BinaryOp(A=FoEa; B=Lapse; Op=A*B; Output=Ftempa;),
        BinaryOp(A=FoEe; B=Lapse; Op=A*B; Output=Ftempe;),
        BinaryOp(A=FoEx; B=Lapse; Op=A*B; Output=Ftempx;),
        BinaryOp(A=Ftempa; B=Shift; Op=A-B; Output=FtGrida;),
        BinaryOp(A=Ftempe; B=Shift; Op=A-B; Output=FtGride;),
        BinaryOp(A=Ftempx; B=Shift; Op=A-B; Output=FtGridx;),

        BinaryOp(A=FtGrida; B=ECons_a;Op=A*B; Output=NeutrinoFluxa;),
        BinaryOp(A=FtGride; B=ECons_e;Op=A*B; Output=NeutrinoFluxe;),
        BinaryOp(A=FtGridx; B=ECons_x;Op=A*B; Output=NeutrinoFluxx;),


        # Average energy (inertial frame)
        EvaluateScalarFormula(E=ECons_e; N=NCons_e; Formula=(E)/(N+1.e-70); Output=Eavg_e;),
        EvaluateScalarFormula(E=ECons_a; N=NCons_a; Formula=(E)/(N+1.e-70); Output=Eavg_a;),
        EvaluateScalarFormula(E=ECons_x; N=NCons_x; Formula=(E)/(N+1.e-70); Output=Eavg_x;),

        SpatialCoordMap::TransformTensorToDifferentFrame
        (Input=FtGrida;Output=FInertiala;IndexPositions=u;MapPrefixToOutputFrame=GridToInertialFD),
        SpatialCoordMap::TransformTensorToDifferentFrame
        (Input=FtGride;Output=FInertiale;IndexPositions=u;MapPrefixToOutputFrame=GridToInertialFD),
        SpatialCoordMap::TransformTensorToDifferentFrame
        (Input=FtGridx;Output=FInertialx;IndexPositions=u;MapPrefixToOutputFrame=GridToInertialFD),
        ),
        Subdomain
        (Items =
        EvaluateScalarFormula(Formula=1.e-25; Output=IG-Enu;),
        EvaluateFormula(Output=IG-Fnu; A=u_i; Formula=1.e-26*A;),
        #Note we actually want d_i g_{kl} from d_i g^{kl} here... so invert g <-> Invg in the opts
        SpatialDerivOfInvg(
        dg = dInvg;
        Invg = g;
        Output = dg;
        ),
        ExtractNeutrinoComponent(
        Input=ECons;
        EnergyBin=0;
        Species=nux;
        Output=ECons_x;
        ),
        ExtractNeutrinoComponent(
        Input=ECons;
        EnergyBin=0;
        Species=nue;
        Output=ECons_e;
        ),
        ExtractNeutrinoComponent(
        Input=ECons;
        EnergyBin=0;
        Species=nua;
        Output=ECons_a;
        ),
        ExtractNeutrinoComponent(
        Input=NCons;
        EnergyBin=0;
        Species=nux;
        Output=NCons_x;
        ),
        ExtractNeutrinoComponent(
        Input=NCons;
        EnergyBin=0;
        Species=nue;
        Output=NCons_e;
        ),
        ExtractNeutrinoComponent(
        Input=NCons;
        EnergyBin=0;
        Species=nua;
        Output=NCons_a;
        ),
        ExtractNeutrinoComponent(
        Input=FCons;
        EnergyBin=0;
        Species=nux;
        Output=FCons_x;
        ),
        ExtractNeutrinoComponent(
        Input=FCons;
        EnergyBin=0;
        Species=nue;
        Output=FCons_e;
        ),
        ExtractNeutrinoComponent(
        Input=FCons;
        EnergyBin=0;
        Species=nua;
        Output=FCons_a;
        ),
        EvaluateScalarFormula(A=ECons_x; B=sDetg; Formula=A/B; Output=ENux),
        EvaluateScalarFormula(A=ECons_a; B=sDetg; Formula=A/B; Output=ENua),
        EvaluateScalarFormula(A=ECons_e; B=sDetg; Formula=A/B; Output=ENue),
        EvaluateScalarFormula(A=Detg; Output=sDetg; Formula=sqrt(A);),
        BinaryOp(A=FCons_x; B=sDetg; Op =A/B; Output=FNux),
        BinaryOp(A=FCons_a; B=sDetg; Op =A/B; Output=FNua),
        BinaryOp(A=FCons_e; B=sDetg; Op =A/B; Output=FNue),
        );

Observers=
        Add (
        ObservationTrigger = EveryDeltaT(DeltaT=.5;);
        Observers =
        ObserveInSubdir
        (Subdir=NeutrinoObservers;
        Observers =
        DumpParameters(Input=NeutrinoSekiFluxe; GetFromRoot=true;),
        DumpParameters(Input=NeutrinoSekiFluxa; GetFromRoot=true;),
        DumpParameters(Input=NeutrinoSekiFluxx; GetFromRoot=true;);
        );
        ),
        Add (
        ObservationTrigger = EveryDeltaT(DeltaT=10;);

        Observers =
       ObserveInSubdir
        (Subdir=NeutrinoVolumeData;
        Observers =
        DumpTensors(Input=ENux,ENua,ENue,Temp,Rho0Phys,Ye,FInertialx,FInertiala,FInertiale,vInertial,Eavg_e,Eavg_a,Eavg_x;)
        ;
        );
        );

EOF1
}

OLD_RUN=$1
NEW_RUN=$2

cd $NEW_RUN
write_neutrinoitems_template
mv NeutrinoItems_new.input NeutrinoItems.input
