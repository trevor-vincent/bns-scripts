#!/bin/bash

function write_neutrinoitems2_template {
    cat <<EOF1 > NeutrinoItems2_new.input
    
DataBoxItems =
Domain (Items =

              SpatialCoordMapItems
              (Map=ReadFromFile(FileName=OldFDGridToSpectralGridMap.input;);
               Prefix=OldFDGridToSpectralGrid;
               InputCoords=<<Grid>>;
               MapIsVolatile=false;
               ),
             ReadTensorsFromDiskWithMap
             (
                                 Input =
                                 NuECons_nua(Dim=3;Sym=;Input=NuECons_nua0),
                                 NuECons_nue(Dim=3;Sym=;Input=NuECons_nue0),
                                 NuECons_nux(Dim=3;Sym=;Input=NuECons_nux0),
                                 NuFCons_nua(Dim=3;Sym=1;Input=NuFCons_nua0),
                                 NuFCons_nue(Dim=3;Sym=1;Input=NuFCons_nue0),
                                 NuFCons_nux(Dim=3;Sym=1;Input=NuFCons_nux0),
                                 NuNCons_nua(Dim=3;Sym=;Input=NuNCons_nua0),
                                 NuNCons_nue(Dim=3;Sym=;Input=NuNCons_nue0),
                                 NuNCons_nux(Dim=3;Sym=;Input=NuNCons_nux0),
                                 ScatFrac_nua(Dim=3;Sym=;Input=ScatFrac_nua0),
                                 ScatFrac_nue(Dim=3;Sym=;Input=ScatFrac_nue0),
                                 ScatFrac_nux(Dim=3;Sym=;Input=ScatFrac_nux0),
                                 NuXi_nua(Dim=3;Sym=;Input=NuXi_nua0),
                                 NuXi_nue(Dim=3;Sym=;Input=NuXi_nue0),
                                 NuXi_nux(Dim=3;Sym=;Input=NuXi_nux0);
                                 InterpolatorScheduler=
                                 NonBlocking(TopologicalInterpolator= CappedPolynomial();
                                      DistributePoints = OnTarget;
                                      ChooseSubdomain = FirstFound;
                                 );
                                 Dir = $1;
                                 DomainDir  = $2;
                                 DomainFile = HyDomain.input;
                                 Time = $3;
                                 DeltaT = 1e-10;
                                 Extrapolator=SetToConstant(Const=0);
                                 H5FilePrefix=Cp-Vars;
                                 SpatialCoordMapDir = .;
                                 SpatialCoordMapFile = OldFDGridToSpectralGridSpatialCoordMap.input;
                                 MapPrefixGridToInertial = ;
                                 MapPrefixSrcGridToInertial = ;
                                 )
,
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
domaindir="$OLD_RUN/Run"
write_neutrinoitems2_template $Cpdir $domaindir $Cptime
mv NeutrinoItems2_new.input NeutrinoItems2.input
