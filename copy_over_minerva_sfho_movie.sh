

function rsync_bns_no_vtk {
    rsync --links -alxuH --progress --exclude '*Tracer*' --include '*/' --include '*/Run' --include '*.dat' --include '*.txt' --include '*.out' --include '*.input' --exclude '*' --stats $1/ $2/
}

rsync_bns_no_vtk "minerva01.aei.mpg.de:/scratch/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.32_eccred0_eccred1_movie" "/scratch/p/pfeiffer/tvincent/BNS_Disks_project/Evolutions/nsns_id_sfho_m1.2_m1.32_MOVIE_MINERVA"



