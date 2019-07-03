if [ "$#" -ne 5 ]; then
    echo "d4est_sbatch_by_triple.sh <grep_item> <hours> <cores> <jobs_per_core>  <command>"
    echo "e.g. ./d4est_sbatch_by_triple.sh 2pun 24 39 3 \"time mpirun -np 13 ./two_punctures_anares_driver  2>&1 | tee disco4est.out &\""
    echo "don't forget the & at the end of the command"
    exit
fi

function write_submit {
    cat <<EOF > $1
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=0-$2:00           # time (DD-HH:MM) 
#SBATCH --ntasks-per-node=$3
module --force purge;                                               
source /home/p/pfeiffer/tvincent/d4est_intel.env 

EOF
}

file="submit_0.sh";
i=0;
k=0; 
touch $file
for d in $(ls | grep $1); 
do 
    modvar=$(echo "$i % $4" | bc); 
    echo "$i $modvar";
    if [ "$modvar" == 0 ]; then 
	file="submit_$k.sh";
	touch $file
	echo $file; 
	write_submit $file $2 $3; 
	let "k++"; 
    fi
#    echo $file
    echo "cd ${PWD}/$d && $5" >> "$file"
    echo "sleep 1m" >> "$file"
#    echo "sleep 10" >> "$file"
    let "i++"; 
done

for d in $(ls | grep submit_); 
do 
    echo "wait" >> $d
done
