rm -rf ParticlesFromOutFlowCat.dat
find . -name "ParticlesFromOutflow*" -exec cat {} \; > ParticlesFromOutFlowCat.dat
sed -i '/^#/ d' ParticlesFromOutFlowCat.dat
echo "DONE CAT"


python /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Scripts/create_particle_hists.py
