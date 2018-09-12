find . \( -name "Rho0Phys_xy.dat" -or -name "Rho0Phys_hori.dat" \) | sort -k2 > folders.txt
linenum=$(cat -n folders.txt | grep $1 | cut -d '.' -f1)
head folders.txt -n $linenum > folders_cropped.txt

emacs -nw folders_cropped.txt &&

read -p "Continue (y/n)?" choice
case "$choice" in
    y|Y ) echo "yes";;
    n|N ) echo "no" && exit;;
    * ) echo "invalid";;
esac

cat $(cat folders.txt) > Rho0Phys_xy_total.dat
