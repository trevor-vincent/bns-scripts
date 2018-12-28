find . -name "points*.pdf" | while read line; do
blah=$(echo "$line" | cut -d '/' -f2);
dof=$(echo $line | cut -d '_' -f14)
slope=$(echo $line | cut -d '_' -f15)
error=$(echo $line | cut -d '_' -f16)
echo "$dof $blah $slope $error"
echo "$dof $blah $slope $error" >> slope_error.dat
done
