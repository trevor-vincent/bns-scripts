export LASTRES_DIR_TEMP=$3
export LASTPARAMS_DIR_TEMP=$2
export NSNS_ID=$1
export NSNS_DIR='/scratch/p/pfeiffer/tvincent/BNS_Disks_project/'
cd $NSNS_DIR
cd InitialData
cd $NSNS_ID
LASTRES_DIR="$(ls | grep ${LASTRES_DIR_TEMP})"
LASTPARAMS_DIR="$(ls | grep ${LASTPARAMS_DIR_TEMP})"

mkdir EvID
cd EvID
cp ../$LASTRES_DIR/Run/BNSID_output/* .
cp ../$LASTRES_DIR/Run/Omega.dat ../$LASTRES_DIR/Run/Domain.input ../$LASTRES_DIR/Run/EvolutionParameters.perl ../$LASTRES_DIR/Run/ResolutionChangesMetric.input .
cp ../$LASTPARAMS_DIR/Run/SurfB_*Coefs.dat .
export replace_string="\/exec5\/GROUP\/tvincent\/tvincent\/BNS_Disks_project\/InitialData\/$NSNS_ID\/$LASTRES_DIR\/Run\/\/"
sed -i "s/${replace_string}\///g" Domain.input
export replace="\/exec5\/GROUP\/tvincent\/tvincent\/"
sed -i "s/${replace}\///g" Domain.input
ls
