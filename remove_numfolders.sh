for f in $(ls -d */); do
cd $f
for f1 in $(ls -d */ | grep "[0-9]\+"); do
    echo ${PWD}/$f1
done
cd ..
done

echo "Do you wish to remove these?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

for f in $(ls -d */); do
cd $f
for f1 in $(ls -d */ | grep "[0-9]\+"); do
    echo ${PWD}/$f1
    rm -rf ${PWD}/$f1
done
cd ..
done
