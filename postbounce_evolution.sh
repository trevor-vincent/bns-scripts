#!/bin/bash

function write_evolution_template {
    cat <<EOF1 > Evolution_new.input
StartTime=$1;
Restart  =FromLastStep(FilenamePrefix=$2/Run/Checkpoints/;
                GrGlobalVarsCheckpoint=Interpolated(
                Interpolator=Simple(TopologicalInterpolator=CardinalInterpolator;);
                DomainDir=$2;
                DomainFile=GrDomain.input;
                ResolutionChanger=Spectral;
);
 HyGlobalVarsCheckpoint=Remapped
 (
    DomainDir=$2;
    DomainFile=HyDomain.input;
    MapPrefixGridToInertial = ;
    MapPrefixSrcGridToInertial = ;
    InterpolatorScheduler = NonBlocking(
    TopologicalInterpolator=CappedPolynomial();
    DistributePoints = OnSource();
    ChooseSubdomain  = FinestLevel(MinimumDistance=3);
);
                        Extrapolator=SetToConstant(Const=1.e-16);
 );
);


TensorYlmDataBaseDir= /scratch/p/pfeiffer/tvincent/TensorYlmDataBase;
DistributionPolicy = Fraction(Fraction=Hy(Fraction=384),
                                       Gr(Fraction=24));

OdeErrorMeasure = 
    ScaledAbsRel(
      ATol       = 1e-05;
      RTol       = 0.001;
      ScaledVars = Rho,Tau,Sflux
                  ,RhoYe,TracerX
                   ;
      Scales     = 1,1,1
                  ,1,1000000
                   ;
    );

OdeErrorObservers = ;

OdeIntegrator = AdaptiveDense (
  OdeController = ProportionalIntegral(Tolerance      = 1;
                                       InitialDt      = 0.001;
                                       MinimumDt      = 1e-05;
                                       DiagnosticFile = TStepperDiag.dat;
  );
  OdeStepper = RungeKutta3 (
    ExplicitRhsAlgorithm = MultiDomainHydro(
      ExplicitRhsAlgorithmSpectral = Fosh(
        BjorhusCharSpeedCutoff = -1.e-10;
        PenaltyScaleFactor     = 1.0;
        InternalBdryMethod     = MultiPenalty;
        InternalBcFilterHack   = false;
        PostBcFilterHack       = true;
        InterpolatorForMover   = ParallelFromSlicesOnly(
          TopologicalInterpolator=Spectral;
          UseBufferedMpi = true;
        );
        FoshSystem             = DualFrame(FramePrefix    =SpectralInertial;
                                           EvolutionSystem=GeneralizedHarmonic
                                           (SpatialDimension=3; RhsMethod=Pointwise);
        );
        BoundaryInfoMover::UseNonBlockingMpi=true;
      );
      ExplicitRhsAlgorithmFiniteDifference=
      GhostZone (
        GhostZoneMask      = GhostZoneMask;
        CellSymmetry           = VertexCentered;
        DomainSymmetry     = None;
        SyncInRhs          = true;
        FoshSystem         = 
        HydroDualFrame(FramePrefix    =InertialFD;
                       EvolutionSystem=Hydro(SpatialDimension=3;
                                            EvolveComposition=true;
  					    FollowTracerParticles=true;
                                             MagneticEvolutionVariable=None;
                                             UseHydroNoOptions=true;
                                             UseRoeFluxes=false;
                                       );
        );
      );
    );
  );
);

AmrDriverMaxInitIterations = 40;
AmrDriver                  = ReadFromFile(File=AmrDriver.input);
                                
GrCopyFromSetupToEvolution =
    psi( Dim=4; Sym=11; Input=psi;),
    kappa( Dim=4; Sym=122; Input=kappa;),
    InitMovingH(Dim=4; Sym=1; Input=MovingH),
    InitGridHi(Dim=3; Sym=1; Input=InitGridHi),
    InitHhatt(Dim=4; Sym=; Input=InitHhatt),
    ; # END CopyFromSetupToEvolution

HyCopyFromSetupToEvolution=
    Rho(  Dim=3; Sym=;   Input=Rho;),
    Tau(  Dim=3; Sym=;   Input=Tau;),
    Sflux(Dim=3; Sym=1;  Input=Sflux;),
     TracerX(Dim=3; Sym=1; Input=TracerX;),	
      RhoYe(Dim=3; Sym=; Input=RhoYe),
    ; # END CopyFromSetupToEvolution

GrTerminator = 
    (TerminationCriteria =
     FinalTime(FinalTime= 2000000),
     WallClock(Minutes=29; ),
     DataTooBig(TensorInSubdomain=psi;Threshold = 100),
     OnSignal(Signals=USR1),
     #Below is a shortcut for USR1;
     # touch stop.txt for a quick stop for a run, no logging into node needed
     # trigger is so disk is not constantly hammered checking for file
     Add(EventTrigger        =EveryNChunks(NChunks=100.0);
         TerminationCriteria =FileExists(FileName               =stop.txt;
                                         RemoveFileAtTermination=true),
                               WhenFoshRhsIsNotBalanced;
     );

    );
HyTerminator = 
    (TerminationCriteria =
     DataTooBig(TensorInSubdomain=Tau;Threshold = 10);
    );

MinimumNumberOfTimeStepsPerChunk=3;
DeltaTOfEachSubChunk=5/250;
NumSubChunksPerChunk=250;

EvolutionInfo=Add(Trigger=WallClockInterval(Hours=2;);
                  Info   = TimeInfo,ProfilerResults,TimeInfoFile,
                           MemoryInfoFile,CpuUsage;
                  TriggerOnTermination=true),
              Add(Trigger=OnSignal(Signal=USR1);
                  Info   = FlushCachedData;
                  TriggerOnTermination=false),
              Add(Trigger=WallClockInterval(Hours=.1;);
                  Info   = FlushCachedData;
                  TriggerOnTermination=true);

CheckpointController =
    (
     WaitTime                         =5;
     FilenamePrefixForForcedCheckpoint=ForcedCheckpoints/;
     Checkpoints=Add(Trigger=WallClockInterval(Hours=12;);FilenamePrefix=Checkpoints/);
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
Cpdir="$OLD_RUN/Run/Checkpoints/$LAST_CHK"

cd $NEW_RUN

write_evolution_template $Cptime $OLD_RUN

mv Evolution.input Evolution_old.input
mv Evolution_new.input Evolution.input
