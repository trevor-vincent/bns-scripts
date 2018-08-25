X1_lev1="$(cat HyDomain.input | grep Bounds | head -n1 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Y1_lev1="$(cat HyDomain.input | grep Bounds | head -n2 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"
Z1_lev1="$(cat HyDomain.input | grep Bounds | head -n3 | tail -n1 | cut -d '=' -f 2 | cut -d ',' -f 2 | cut -d ';' -f 1)"

Extents_x_lev1="$(cat HyDomain.input | grep Extents | head -n1 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"
Extents_y_lev1="$(cat HyDomain.input | grep Extents | head -n2 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"
Extents_z_lev1="$(cat HyDomain.input | grep Extents | head -n3 | tail -n1 | cut -d '(' -f 2 | cut -d '=' -f 2 | cut -d ';' -f 1)"

dx=$(echo "2*$X1_lev1/($Extents_x_lev1-1)" | bc -l )
dy=$(echo "2*$Y1_lev1/($Extents_y_lev1-1)" | bc -l )
dz=$(echo "2*$Z1_lev1/($Extents_z_lev1-1)" | bc -l )
#echo "dx = $dx"
#echo "dy = $dy"
#echo "dz = $dz"

res=$(echo "$dx > $dz" | bc -l)
dmax=$dz
if [ "$res" -eq "1" ]; then
    dmax=$dx
fi

res=$(echo "$dmax > $dy" | bc -l)
dmax2=$dy
if [ "$res" -eq "1" ]; then
    dmax2=$dmax
fi

echo "$dmax2"