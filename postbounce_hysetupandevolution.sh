#!/bin/bash

OLD_RUN=$1
NEW_RUN=$2

function write_hysetupandevolution_template {

cat <<EOF > HySetupAndEvolution_new.input

DataBoxItems =
    Subdomain(Items =
              EvaluateScalarFormula(Output=AtmosphereMultiplier;
                              Formula=1.0;
              ),
   ),
    Domain(Items =
           AddHydroSystemItems
           (DomainSymmetry         = None;
            FramePrefix            =InertialFD;
            InversionMethod        = 2D;
            InterpolationVariables = Rho0Phys,Temp,u_i;
           NeutrinoRadiation      = off;
           EvolveComposition      = true;
           FollowTracerParticles = true;
           Atmosphere             = (RhoFloor       =1.e-13;
                                     ApplyEnthalpyLimit=false;
                                     ApplyMaxTemp   =true;
                                     MaxTemp        =100;
                                     AtmosphereTemp =0.5;
                                     ApplyKappaLimit=false;
                                      Center         =0,0,0;
                                      CubicalBoundary=2*($1-0.5*$4),
                                                      2*($2-0.5*$4),
                                                      2*($3-0.5*$4);
                                      RhoCritLowTau  =2.e-12;
                                      RhoCritHighTau =2.e-11;
                                      RhoCritLowS    =2.e-12;
                                      RhoCritHighS   =2.e-11;

                                      MaxUmag            = 0.0001;
                                      AllowNegativeTemps = false;

                                      MultiplyingFactor=AtmosphereMultiplier;);
            FixPoints=(RhoCutoff         = 1.e-6;
                       SSmax             = 0.9999;
                       SqrtDetgPower     = 1.0;
                       Slope             = 0.0001;
                       MultiplyingFactor = AtmosphereMultiplier;
            );
            DualFrameMethod = GridCoords;
                              KRecOrder = 4;
                              KRecMethod = WENO5b;
           ),

           HydroParams(RhoMinInvertAbsOrRel = Absolute;
                       RhoMinInvertAbs      = 1.e-13;
                       CutoffMultiplierName = None;
                       RhoMinDivide         = 1.e-13;
                       EquationOfState      = Tabulated(filename=$5);
                       KreissOligerCoeff    = None;
                       Map=MapBetweenDomains;

                       ReconstructionMethod = WENO(Cell               =Center;
                                                   SmoothnessIndicator=Shu;);
                       Apply3rdOrderFinDif=false;
           ),
    );


EOF
}


cd $NEW_RUN
dxFD=$(cat HySetupAndEvolution.input | grep CubicalBoundary | cut -d '*' -f 3 | cut -d ')' -f1)

cd $OLD_RUN
EOS=$(grep "EquationOfState      =" HySetupAndEvolution.input | cut -d '=' -f3 | cut -d ')' -f1)
echo $EOS

cd $NEW_RUN
X1_lev1="$(cat HyDomain.input | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Y1_lev1="$(cat HyDomain.input | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Z1_lev1="$(cat HyDomain.input | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
write_hysetupandevolution_template $X1_lev1 $X1_lev1 $Z1_lev1 $dxFD $EOS
mv HySetupAndEvolution.input HySetupAndEvolution_old.input
mv HySetupAndEvolution_new.input HySetupAndEvolution.input