rm -rf ../JoinedMovies
mkdir ../JoinedMovies
touch ../JoinedMovies/Rho0Phys_vert.dat
touch ../JoinedMovies/Rho0Phys_hori.dat
find . -type f -name 'Rho0Phys_vert.dat' | sort -k2 | while read fstring; do
echo $fstring
cat $fstring >> ../JoinedMovies/Rho0Phys_vert.dat
done

find . -type f -name 'Rho0Phys_hori.dat' | sort -k2 | while read fstring; do
echo $fstring
cat $fstring >> ../JoinedMovies/Rho0Phys_hori.dat
done

cd ../JoinedMovies

#tr -d '\n' < Rho0Phys_vert.dat;5~
#tr -d '\n' < Rho0Phys_hori.dat


#grep '[^[:blank:]]' < Rho0Phys_vert1.dat > Rho0Phys_vert.dat
#grep '[^[:blank:]]' < Rho0Phys_hori1.dat > Rho0Phys_hori.dat

python /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/make_movie_rho0.py Rho0Phys_hori.dat
python /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/make_movie_rho0.py Rho0Phys_vert.dat
