rm -rf /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Debug/*
NUM=$RANDOM
#ssh -fNML "$NUM":trinity.cita.utoronto.ca:22 gw.cita.utoronto.ca
#ssh localhost 'rm -rf /cita/d/www/home/tvincent/Debug/*'

ssh -fNML "$NUM":trinity.cita.utoronto.ca:22 gw.cita.utoronto.ca
ssh localhost -p "$NUM" "rm -rf /cita/d/www/home/tvincent/Debug/*"
#scp -r -P "$NUM" /scratch/p/pfeiffer/tvincent/BNS_Disks_project/Debug localhost:/cita/d/www/home/tvincent/

killall -u tvincent ssh