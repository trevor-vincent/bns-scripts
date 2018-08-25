# arg 1: NsNs dir suffix
# arg 2: Full Run dir
# [[./average-temp.png]]
# [[./average-entropy.png]]
# [[./rest-mass.png]]
# [[./unbound-mass.png]]
# [[./constraints.png]]
# [[./com-nsa.png]]
# [[./com-nsb.png]]

function write_org_inspiral_leakage_template {
    cat <<EOF1 > $1.org
#+OPTIONS: ^:nil
#+TITLE: $1 Inspiral
#+AUTHOR: Trevor Vincent

Run dir: $2
SpEC.out: [[./SpEC.out]]

* Time Info
[[./timeinfo.png]]

* Neutrino Luminosity
[[./neutrino-luminosity.png]]

* Densest Point
[[./densest-point.png]]

* Rest Mass
[[./restmass.png]]

* Constraints
[[./constraints.png]]

* Unbound Mass
[[./unbound-mass.png]]

* Average Temp
[[./average-temp.png]]

* Average Entropy
[[./average-entropy.png]]

* CoM NSA
[[./com-nsa-xy.png]]
[[./com-nsa-xt.png]]

* CoM NSB
[[./com-nsb-xy.png]]
[[./com-nsb-xt.png]]

EOF1
}

function write_org_inspiral_M1_template {
    cat <<EOF1 > $1.org
#+OPTIONS: ^:nil
#+TITLE: $1 
#+AUTHOR: Trevor Vincent

Run dir: $2
SpEC.out: [[./SpEC.out]]

* Time Info
[[./timeinfo.png]]

* CoM NSA
[[./com-nsa-xy.png]]
|[[./com-nsa-tx.png]]|[[./com-nsa-ty.png]]|[[./com-nsa-tz.png]]|

* CoM NSB
[[./com-nsb-xy.png]]
|[[./com-nsb-tx.png]]|[[./com-nsb-ty.png]]|[[./com-nsb-tz.png]]|

* Neutrino Luminosity
[[./neutrino-fluxe.png]]
|[[./neutrino-fluxeL.png]]|[[./neutrino-fluxeR.png]]|

* Densest Point
[[./densest-point.png]]

* Rest Mass
[[./restmass.png]]

* Constraints
[[./constraints.png]]

* Unbound Mass
[[./unbound-mass.png]]

* OutflowOut
[[./outflowout.png]]

* OutflowOutH
[[./outflowouth.png]]

* Average Temp
[[./average-temp.png]]

* Average Entropy
[[./average-entropy.png]]

* Memory Info
[[./memory-info.png]]

EOF1
}

function write_org_inspiral_hydro_only_template {
    cat <<EOF1 > $1.org
#+OPTIONS: ^:nil
#+TITLE: $1 
#+AUTHOR: Trevor Vincent

Run dir: $2
SpEC.out: [[./SpEC.out]]

* Time Info
[[./timeinfo.png]]

* CoM NSA
[[./com-nsa-xy.png]]
|[[./com-nsa-tx.png]]|[[./com-nsa-ty.png]]|[[./com-nsa-tz.png]]|

* CoM NSB
[[./com-nsb-xy.png]]
|[[./com-nsb-tx.png]]|[[./com-nsb-ty.png]]|[[./com-nsb-tz.png]]|

* Densest Point
[[./densest-point.png]]

* Rest Mass
[[./restmass.png]]

* Constraints
[[./constraints.png]]

* Unbound Mass
[[./unbound-mass.png]]

* Average Temp
[[./average-temp.png]]

* Average Entropy
[[./average-entropy.png]]

* Memory Info
[[./memory-info.png]]

EOF1
}


# arg 1: config file
# arg 2: output file
# arg 3: input file
function write_gnuplot_png {

gnuplot -persist <<-EOFMarker
load "$1";
set term png;
set output "$2";
plot "$3" u (\$1)*time_geo_mks:(@col2) w l ls 1
EOFMarker

}


function write_gnuplot_xy_png {

gnuplot -persist <<-EOFMarker
load "$1";
set term png;
set output "$2";
plot "$3" u (@col1):(@col2) w l ls 1
EOFMarker

}


NSNS_DIR='/scratch/p/pfeiffer/tvincent/BNS_Disks_project'
NSNS_DIR_EV="$NSNS_DIR/Evolutions"
NSNS_DIR_ID="$NSNS_DIR/InitialData"
NSNS_DIR_SCRIPTS="$NSNS_DIR/Scripts"
NSNS_DIR_INPUTS="$NSNS_DIR/InputFiles"
NSNS_DIR_CFGS="${NSNS_DIR_SCRIPTS}/Plotting"
NSNS_DIR_DEBUG="${NSNS_DIR}/Debug"

# module load emacs
module load gnuplot

cd $NSNS_DIR_DEBUG
mkdir $1
cd $1
mkdir $4
cd $4
cp -f $2/SpEC.out .


if [ $3 = "leakage" ]
then
    write_org_inspiral_leakage_template $1 $2
    write_gnuplot_png ${NSNS_DIR_CFGS}/neutrino-luminosity.cfg neutrino-luminosity.png $2/NeutrinoLuminosity.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/densest-point.cfg densest-point.png $2/DensestPoint.dat
    write_gnuplot_xy_png ${NSNS_DIR_CFGS}/com-xy.cfg com-nsa-xy.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tx.cfg com-nsa-tx.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-ty.cfg com-nsa-ty.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tz.cfg com-nsa-tz.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_xy_png ${NSNS_DIR_CFGS}/com-xy.cfg com-nsb-xy.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tx.cfg com-nsb-tx.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-ty.cfg com-nsb-ty.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tz.cfg com-nsb-tz.png $2/CoM-NSB-InertialFrame.dat    
    write_gnuplot_png ${NSNS_DIR_CFGS}/restmass.cfg restmass.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/unbound-mass.cfg unbound-mass.png $2/MatterObservers/UnboundMass.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/constraints.cfg constraints.png $2/ConstraintNorms/GhCe.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/timeinfo.cfg timeinfo.png $2/TimeInfo.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/average-entropy.cfg average-entropy.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/average-temp.cfg average-temp.png $2/MassAvgs.dat
elif [ $3 = "M1" ]
then
    write_org_inspiral_M1_template $1 $2
    write_gnuplot_png ${NSNS_DIR_CFGS}/neutrinofluxe.cfg neutrino-fluxe.png $2/NeutrinoObservers/NeutrinoFluxeAtBoundary.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/neutrinofluxe.cfg neutrino-fluxeL.png $2/NeutrinoObservers/NeutrinoSekiFluxeL.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/neutrinofluxe.cfg neutrino-fluxeR.png $2/NeutrinoObservers/NeutrinoSekiFluxeR.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/densest-point.cfg densest-point.png $2/DensestPoint.dat
    write_gnuplot_xy_png ${NSNS_DIR_CFGS}/com-xy.cfg com-nsa-xy.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tx.cfg com-nsa-tx.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-ty.cfg com-nsa-ty.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tz.cfg com-nsa-tz.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_xy_png ${NSNS_DIR_CFGS}/com-xy.cfg com-nsb-xy.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tx.cfg com-nsb-tx.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-ty.cfg com-nsb-ty.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tz.cfg com-nsb-tz.png $2/CoM-NSB-InertialFrame.dat    
    write_gnuplot_png ${NSNS_DIR_CFGS}/restmass.cfg restmass.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/unbound-mass.cfg unbound-mass.png $2/MatterObservers/UnboundMass.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/unbound-mass.cfg outflowout.png $2/MatterObservers/OutflowOut.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/unbound-mass.cfg outflowouth.png $2/MatterObservers/OutflowOutH.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/constraints.cfg constraints.png $2/ConstraintNorms/GhCe.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/timeinfo.cfg timeinfo.png $2/TimeInfo.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/average-entropy.cfg average-entropy.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/average-temp.cfg average-temp.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/memory-info.cfg memory-info.png $2/MemoryInfo.dat
elif [ $3 = "hydro_only" ]
then
    write_org_inspiral_hydro_only_template $1 $2
    write_gnuplot_png ${NSNS_DIR_CFGS}/densest-point.cfg densest-point.png $2/DensestPoint.dat
    write_gnuplot_xy_png ${NSNS_DIR_CFGS}/com-xy.cfg com-nsa-xy.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tx.cfg com-nsa-tx.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-ty.cfg com-nsa-ty.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tz.cfg com-nsa-tz.png $2/CoM-NSA-InertialFrame.dat
    write_gnuplot_xy_png ${NSNS_DIR_CFGS}/com-xy.cfg com-nsb-xy.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tx.cfg com-nsb-tx.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-ty.cfg com-nsb-ty.png $2/CoM-NSB-InertialFrame.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/com-tz.cfg com-nsb-tz.png $2/CoM-NSB-InertialFrame.dat    
    write_gnuplot_png ${NSNS_DIR_CFGS}/restmass.cfg restmass.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/unbound-mass.cfg unbound-mass.png $2/MatterObservers/UnboundMass.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/constraints.cfg constraints.png $2/ConstraintNorms/GhCe.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/timeinfo.cfg timeinfo.png $2/TimeInfo.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/average-entropy.cfg average-entropy.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/average-temp.cfg average-temp.png $2/MassAvgs.dat
    write_gnuplot_png ${NSNS_DIR_CFGS}/memory-info.cfg memory-info.png $2/MemoryInfo.dat

else
    echo "Must be leakage atm"
    exit
fi

emacs $1.org --batch -f org-export-as-html --kill
    
