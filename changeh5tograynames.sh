function run_h5copy {

for filename in Cp-Vars_Interval*.h5;
do
h5copy -v -i ./$filename -o ./$filename -s $1 -d $2;
done;
}

run_h5copy NuECons_nue0 ECons_nue
run_h5copy NuFCons_nue0 FCons_nue
run_h5copy NuNCons_nue0 NCons_nue
run_h5copy NuXi_nue0 ClosureXi_nue
run_h5copy ScatFrac_nue0 ScatteringFraction_nue

echo "Done nue"
run_h5copy NuECons_nua0 ECons_nua
run_h5copy NuFCons_nua0 FCons_nua
run_h5copy NuNCons_nua0 NCons_nua
run_h5copy NuXi_nua0 ClosureXi_nua
run_h5copy ScatFrac_nua0 ScatteringFraction_nua

echo "Done nua"
run_h5copy NuECons_nux0 ECons_nux
run_h5copy NuFCons_nux0 FCons_nux
run_h5copy NuNCons_nux0 NCons_nux
run_h5copy NuXi_nux0 ClosureXi_nux
run_h5copy ScatFrac_nux0 ScatteringFraction_nux
