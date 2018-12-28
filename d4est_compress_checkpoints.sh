find $PWD -name "Checkpoints" -type d | while read line; do

cd $line && cd ..
echo $line

if [ ! -f checkpoints_backup.tar.gz ]; then
    echo "tar does not exist"
    tar -czf checkpoints_backup.tar.gz Checkpoints
fi

rm -rf Checkpoints

done
