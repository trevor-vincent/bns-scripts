#!/bin/bash

function write_ejectaitems_template {
    cat <<EOF1 > EjectaItems_new.input

DataBoxItems=
        Domain(Items =
        ConstDouble(Value=12.; Output=ObserveInnerMaskRadius;)
        ),
        Subdomain(Items =
                Recover3Velocity(u_i=u_i; W=W; Shift=Shift;
                      Invg=Invg; Output=vTransport),
                EulerianVelocity(v=vTransport; Output=vEuler),
                SpatialCoordMap::TransformTensorToDifferentFrame
                (Input=vTransport;Output=vInertial;
                IndexPositions=u;MapPrefixToOutputFrame=GridToInertialFD),
              SphericalMask(
              Output=ObserveInnerMask;
              RadiusName = ObserveInnerMaskRadius;
              Center = 0,0,0;
              Map = GridToInertialFD::SpatialCoordMap;
               ),

              SpatialCoordMap::TransformShiftToDifferentFrame
                     (Input=Shift;Output=InertialShift;MapPrefixToOutputFrame=GridToInertialFD),
              ContractVectorWithTensor
              (
               Vector = u_I;
               Tensor = InertialShift;
               Index = 0;
               Metric = None;
               Output = u_dot_beta;
               ),
               EvaluateScalarFormula
              (
               Formula = -A+B*C;
               A = u_dot_beta;
               B = Lapse;
               C = W;
               Output = Minusu_t;
               ),
               EvaluateScalarFormula
                (
                Formula =A*B;
                Output=Minusu_tH;
                A=Minusu_t;
                B=Enth;
                ),
                EvaluateScalarFormula
                (
                A=Minusu_tH;
                Output=UnboundFlagH;
                Formula=StepFunction(A-1.);
                ),
              FlagUnboundMaterial(
              Output=UnboundFlag;
              W=W; Lapse=Lapse; Shift=InertialShift; u_i=u_I;
              ),
              EvaluateFormula(
              Output=UnboundRho;
              A=Rho; B=UnboundFlag; Formula=A*B;
              ),
              EvaluateFormula(
              Output=UnboundRhoH;
              A=Rho; B=UnboundFlagH; Formula=A*B;
              ),
              BinaryOp(Op=A*B; A=MatterFlux; B=UnboundFlagH; Output=MatterFluxH;),
              BinaryOp(Op=A*B; A=MatterFluxH; B=Ye; Output=MatterFluxHYe;),
              BinaryOp(Op=A*B; A=MatterFluxH; B=Entropy; Output=MatterFluxHS;),
              EvaluateFormula(
               Output=MaskedUnboundRhoH;
               A=UnboundRhoH; B=ObserveInnerMask;
               Formula=A*B;),
               EvaluateFormula(
               Output=MaskedUnboundRho;
               A=UnboundRho; B=ObserveInnerMask;
               Formula=A*B;),
               EvaluateFormula(
               Output=UnboundEnergy;
               A=MaskedUnboundRho; B=Minusu_t;
               Formula=A*(B-1);
               );
              );

Observers=
        Add(ObservationTrigger = EveryDeltaT(DeltaT=0.5);
        Observers =
                ObserveInSubdir
                (Subdir=MatterObservers;
                Observers =
                VolumeIntegral(Input=UnboundRho,MaskedUnboundRho,UnboundEnergy,UnboundRhoH,MaskedUnboundRhoH;
                        FileName=UnboundMass.dat;
                        SqrtDetg=None;
                        ),
                DumpParameters(Input=OutflowOut; GetFromRoot=true;),
                DumpParameters(Input=OutflowOutH; GetFromRoot=true;),
                DumpParameters(Input=OutflowOutHS; GetFromRoot=true;),
                DumpParameters(Input=OutflowOutHYe; GetFromRoot=true;),
                )
                );                                     

EOF1
}

OLD_RUN=$1
NEW_RUN=$2
cd $NEW_RUN
write_ejectaitems_template
mv EjectaItems_new.input EjectaItems.input

