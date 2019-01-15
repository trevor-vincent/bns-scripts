find . -name "NueParticles046*" | sort -k2 > folders.txt
linenum=$(cat -n folders.txt | grep $1 | cut -d '.' -f1)
echo "linenumber = $linenum"
head folders.txt -n $linenum > folders_cropped.txt
#for d in $(cat folders_cropped.txt)
#do
#echo $(dirname basename $d)
#done
emacs -nw folders_cropped.txt &&

read -p "Continue (y/n)?" choice
case "$choice" in 
  y|Y ) echo "yes";;
  n|N ) echo "no" && exit;;
  * ) echo "invalid";;
esac

rm ParticlesFromOutFlowCat.dat
touch ParticlesFromOutFlowCat.dat
for f in $(cat folders_cropped.txt);
do
#    echo $(dirname $f)
    folder=$(dirname $f)
#    echo $PWD
    cd $folder
#    echo $PWD
    echo $folder
    find . -name "NueParticles*" -exec cat {} \; >> ../../NueParticlesOutFlowCat.dat
    find . -name "NuaParticles*" -exec cat {} \; >> ../../NuaParticlesOutFlowCat.dat
    find . -name "NuxParticles*" -exec cat {} \; >> ../../NuxParticlesOutFlowCat.dat
    cd ../../
done

echo "Now running sed"
sed -i '/^#/ d' NueParticlesOutFlowCat.dat
sed -i '/^#/ d' NuaParticlesOutFlowCat.dat
sed -i '/^#/ d' NuxParticlesOutFlowCat.dat

