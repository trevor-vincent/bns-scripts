
function rsync_bns {
    rsync --links -alxuH --progress  --include '*/' --include '*/Run' --include '*Profiler.h5' --include '*.dat' --include '*.txt' --include '*.out' --include '*RhoTempENua/*' --include '*.agr' --include '*RhoTempENua*' --include '*.input' --exclude '*' --stats $1/ $2/
}

function rsync_bns_no_vtk {
    rsync --links -alxuH --progress --exclude '*Tracer*' --include '*/' --include '*/Run' --include '*.dat' --include '*.txt' --include '*.out' --include '*.input' --include '*.agr' --exclude '*' --stats $1/ $2/
}

if [ "$#" -ne 1 ]; then
    echo "copy_over_niagara.sh <copy over vtk files = 0/1>"
    echo "e.g.copy_over_niagara.sh 0 ---> will not copy over vtk files"
    exit
fi

if [ $1 -eq 1 ]; then
rsync_bns "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.32_eccred0_eccred1" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.32_MINERVA"
#rsync_bns "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.56_eccred0_eccred1_eccred2" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.56_MINERVA"
#rsync_bns "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.44_eccred0_eccred1_eccred2" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.44_MINERVA"
#rsync_bns "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.44_m1.44_eccred0_eccred1_eccred2" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.44_m1.44_MINERVA"
else
rsync_bns_no_vtk "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.32_eccred0_eccred1" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.32_MINERVA"
#rsync_bns_no_vtk "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.56_eccred0_eccred1_eccred2" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.56_MINERVA"
#rsync_bns_no_vtk "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.44_eccred0_eccred1_eccred2" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.44_MINERVA"
#rsync_bns_no_vtk "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.44_m1.44_eccred0_eccred1_eccred2" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.44_m1.44_MINERVA"
fi



