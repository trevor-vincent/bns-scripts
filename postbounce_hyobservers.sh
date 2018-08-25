function write_hyobservers_template {
    cat <<EOF1 > HyObservers_new.input
     
Observers=
       Add(
#ObservationTrigger = EveryNSteps(NSteps = 1; NoTriggerOnZero = no;);
ObservationTrigger = EveryDeltaT(DeltaT=.5;);
        Observers =

        ObserveInSubdir
        (Subdir = TracerObservers;
         Observers =
         DumpTracerQuantities(Input=TracerX;
                              OutputFile=TracerX.dat;),
         DumpTracerQuantities(Input=TracerV;
                              OutputFile=TracerV.dat;),
         DumpTracerQuantities(Input=Tracerg;
                                 OutputFile=Tracerg.dat;),
         DumpTracerQuantities(Input=TracerLapse;
                                 OutputFile=TracerLapse.dat;),
         DumpTracerQuantities(Input=TracerShift;
                                 OutputFile=TracerShift.dat;),
         DumpTracerQuantities(Input=TracerT;
                              OutputFile=TracerT.dat;),
         DumpTracerQuantities(Input=TracerRho0Phys;
                              OutputFile=TracerRho0Phys.dat;),
         DumpTracerQuantities(Input=TracerRho;
                              OutputFile=TracerRho.dat;),
         DumpTracerQuantities(Input=TracerS;
                              OutputFile=TracerS.dat;),
         DumpTracerQuantities(Input=TracerYe;
                              OutputFile=TracerYe.dat;),
         DumpTracerQuantities(Input=TracerEnergy;
                              OutputFile=TracerEnergy.dat;),
         DumpTracerQuantities(Input=TracerECons_x;
                              OutputFile=TracerECons_x.dat;),
         DumpTracerQuantities(Input=TracerECons_e;
                              OutputFile=TracerECons_e.dat;),
         DumpTracerQuantities(Input=TracerECons_a;
                              OutputFile=TracerECons_a.dat;),
         DumpTracerQuantities(Input=TracerFCons_x;
                              OutputFile=TracerFCons_x.dat;),
         DumpTracerQuantities(Input=TracerFCons_e;
                              OutputFile=TracerFCons_e.dat;),
         DumpTracerQuantities(Input=TracerFCons_a;
                              OutputFile=TracerFCons_a.dat;),
         DumpTracerQuantities(Input=TracerNCons_x;
                              OutputFile=TracerNCons_x.dat;),
         DumpTracerQuantities(Input=TracerNCons_e;
                              OutputFile=TracerNCons_e.dat;),
         DumpTracerQuantities(Input=TracerNCons_a;
                              OutputFile=TracerNCons_a.dat;),
         ),  #END ObserveInSubdir TracerObservers

           ), # END this trigger group

        Add(ObservationTrigger = EveryDeltaT(DeltaT=.1);
              Observers =
              DumpParameters(Input=GridCenterOfMass;GetFromRoot=true),
              DumpParameters(Input=SpectralCenterOfMassA;GetFromRoot=true),
              DumpParameters(Input=SpectralCenterOfMassB;GetFromRoot=true),
              DumpParameters(Input=CoM-NSA-InertialFrame;GetFromRoot=true),
              DumpParameters(Input=CoM-NSB-InertialFrame;GetFromRoot=true),
              DumpParameters(Input=OutflowOut;GetFromRoot=true),
              DumpParameters(Input=OutflowIn;GetFromRoot=true),

              FunctionVsTime(Input=PitchAndYawAngles,ExpansionFactor,
                                   Translation,
                                   RegridScaleFvT,RegridShiftFvT;
              ),

              DumpParameters(Input=DensestPoint;GetFromRoot=true),
              VolumeIntegral(Input=Rho;
                              FileName=RestMass.dat;
                              SqrtDetg=None;
              ),
             VolumeIntegral(Input=RhoYe,RhoTemp,Rho,Entropy;
                      FileName=MassAvgs.dat;
                       SqrtDetg=None;
                     ),

              ),
    Add(
ObservationTrigger = EveryDeltaT(DeltaT=10;);
#ObservationTrigger = EveryNSteps(NSteps = 1; NoTriggerOnZero = no;);
            Observers =
              ObserveInSubdir
              (Subdir=HyVolumeData;
               Observers =
              DumpTensors(Input=Rho0Phys
                                ,vInertial,Temp,Ye
                                ;
                          FileNames=Rho0Phys
                        ,vInertial,Temp,Ye
                                ;
                          XdmfCoords=GridToInertialFD::MappedCoords;
                          Xdmf=yes;
                          XdmfFileName=HyVars;
                          MangleFileNames=yes;
              ),
       ),
       ),
    Add(ObservationTrigger = EveryNSteps(NSteps = 1000000000);
        Observers = DumpDataBox(File=HyDataBoxContent.txt;
                                WriteAllProcs=no;
                                OverwriteFile=yes;
                               );
       );


EOF1
}

OLD_RUN=$1
NEW_RUN=$2

write_hyobservers_template
mv HyObservers.input HyObservers_old.input
mv HyObservers_new.input HyObservers.input
