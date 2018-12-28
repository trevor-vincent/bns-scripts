find $PWD -name "VTK" -type d | while read line; do

cd $line && cd ..
echo $line

tar -czf vtk_backup.tar.gz VTK
rm -rf VTK


done
