find . -name "ParticlesFromOutflow046*" | sort -k2 > folders.txt
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
    find . -name "ParticlesFromOutflow*" -exec cat {} \; >> ../../ParticlesFromOutFlowCat.dat
    cd ../../
done
sed -i '/^#/ d' ParticlesFromOutFlowCat.dat
