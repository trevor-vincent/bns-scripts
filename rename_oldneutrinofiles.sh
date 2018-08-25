
find ${PWD} -name "NeutrinoSekiFluxa.dat" -type f | while read fstring; do
    echo "renaming $fstring"
    DIR=$(echo "$(dirname $fstring)")
    NEWFILE="$DIR/NeutrinoFluxaAtBoundary.dat"
    mv $fstring $NEWFILE
done


find ${PWD} -name "NeutrinoSekiFluxe.dat" -type f | while read fstring; do
    echo "renaming $fstring"
    DIR=$(echo "$(dirname $fstring)")
    NEWFILE="$DIR/NeutrinoFluxeAtBoundary.dat"
    mv $fstring $NEWFILE
done


find ${PWD} -name "NeutrinoSekiFluxx.dat" -type f | while read fstring; do
    echo "renaming $fstring"
    DIR=$(echo "$(dirname $fstring)")
    NEWFILE="$DIR/NeutrinoFluxxAtBoundary.dat"
    mv $fstring $NEWFILE
done


#NeutrinoFluxeAtBoundary.dat
#NeutrinoSekiFluxa.dat  NeutrinoSekiFluxe.dat  NeutrinoSekiFluxx.dat
