#!/bin/bash

if [ "$#" -gt 2 ]; then
    echo "bns_eccred.sh <nsns_id_folder_name> <nsns_ev_folder_name>"
    echo "<nsns_ev_folder_name> is optional, it will be given the same name as id if not provided" 
    exit
fi

NSNS_ID=$1

if [ "$#" -eq 1 ]; then
    NSNS_EV=$NSNS_ID
fi

if [ "$#" -eq 2 ]; then
    NSNS_EV=$2
fi

NSNS_DIR='/scratch/p/pfeiffer/tvincent/BNS_Disks_project'
NSNS_DIR_EV="$NSNS_DIR/Evolutions"
NSNS_DIR_ID="$NSNS_DIR/InitialData"
NSNS_DIR_SCRIPTS="$NSNS_DIR/Scripts"

#check for errors
cd $NSNS_DIR_ID

if [ ! -d "$NSNS_ID" ]; then
    echo "directory $NSNS_DIR_ID/$NSNS_ID does not exist, please try again"
    exit
fi

cd $NSNS_DIR_EV


if [ ! -d "$NSNS_EV" ]; then
    echo "directory $NSNS_DIR_EV/$NSNS_EV does not exist, please try again"
    exit
fi

#defaults
tmin=200
tmax=1500

PS3='Please enter your choice: '
options=("Set tmin" "Set tmax" "Display summary" "EccRed Fit" "Run ID again with EccRed Omega" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Set tmin")
            echo "Type tmin: "; read tmin; echo "Tmin is now set to $tmin"
            ;;
        "Set tmax")
            echo "Type tmax"; read tmax; echo "Tmax is now set to $tmax"
            ;;
	"Display summary")
	    cd "$NSNS_DIR_EV/$NSNS_EV";
	    if [ ! -d "EccRed" ]; then
		echo "You have not ran a eccentricity reduction fit yet"
		exit
	    fi
	    cd EccRed;
	    cat summary.txt
            ;;
	
        "EccRed Fit")
            echo "Running OmegaDotEccRemoval ...";
	    cd "$NSNS_DIR_EV/$NSNS_EV";
	    mkdir EccRed;
	    cd EccRed;
	    echo "What subfolder to use (e.g. Lev0_AA)?"
	    read SUBFOLDER
	    OmegaDotEccRemoval.py -t nsns -d $NSNS_DIR/Evolutions/$NSNS_EV/Ev/$SUBFOLDER/Run/ --idperl $NSNS_DIR/Evolutions/$NSNS_EV/ID/EvID/EvolutionParameters.perl --tmin $tmin --tmax $tmax --improved_Omega0_update;
	    display *.pdf;
            ;;
        "Run ID again with EccRed Omega")
	    cd "$NSNS_DIR_EV/$NSNS_EV";
	    if [ ! -d "EccRed" ]; then
		echo "You have not ran a eccentricity reduction fit yet"
		exit
	    fi
	    cd EccRed;
	    # cd $NSNS_EV; mkdir EccRed; cd EccRed;
	    dOMEGA0="$(cat summary.txt | grep F2cos2: | cut -d ':' -f 2 | cut -d' ' -f3)";
	    dadot0="$(cat summary.txt | grep F2cos2: | cut -d ':' -f 2 | cut -d' ' -f7)";
	    OMEGA0="$(cat $NSNS_DIR_EV/${NSNS_EV}/ID/EvID/EvolutionParameters.perl | grep "ID_Omega0" | cut -d '=' -f 2 | cut -d ';' -f1)";
	    adot0="$(cat $NSNS_DIR_EV/${NSNS_EV}/ID/EvID/EvolutionParameters.perl | grep "ID_adot0" | cut -d '=' -f 2 | cut -d ';' -f1)";
	    d0="$(cat $NSNS_DIR_EV/${NSNS_EV}/ID/EvID/EvolutionParameters.perl | grep "ID_d" | cut -d '=' -f 2 | cut -d ';' -f1)";
	    dd0="$(cat summary.txt | grep F2cos2: | cut -d ':' -f 2 | cut -d' ' -f12)";
	    # NEW_OMEGA0=$(awk "BEGIN {print $OMEGA0+$dOMEGA0; exit}");
	    # NEW_adot0=$(awk "BEGIN {print $dadot0 + $adot0; exit}");

	    # NEW_OMEGA0="$(($OMEGA0 + $dOMEGA0))"
	    NEW_OMEGA0="$(perl -e "print $OMEGA0 + $dOMEGA0")"
	    NEW_adot0="$(perl -e "print $adot0 + $dadot0")"
	    echo "OMEGA0 = $OMEGA0"
	    echo "dOMEGA = $dOMEGA0"
	    echo "NEW_OMEGA0 = $NEW_OMEGA0"
	    echo "adot0 = $adot0"
	    echo "dadot0 = $dadot0"
	    echo "NEW_adot0 = $NEW_adot0"
	    echo "d0 = $d0"
	    echo "dd0 = $dd0"

	    echo "Type the suffix for the new ecc-red ID run"
	    read NSNS_DIR_NEW_ECC_SUFFIX
	    NSNS_DIR_NEW_ECC="$NSNS_DIR_ID/$NSNS_ID$NSNS_DIR_NEW_ECC_SUFFIX"
	    echo "New directory is $NSNS_DIR_NEW_ECC"

	    echo "What separation do you want to use for the initial data run? d0 (ans:d0), d0 + dd0 (ans:dd0), or other (specify number)"
	    read sep_ans

	    
	    if [ $sep_ans = "d0" ]; then
		export sep=$d0
	    elif [ $sep_ans = "dd0" ]; then
		# export sep=$(awk "BEGIN {print $dd0 + $d0; exit}");
		export sep="$(perl -e "print $dd0 + $d0")"
		# export sep="$(($d0 + $dd0))"
	    else
		export sep=$sep_ans;
	    fi

	    echo "Do you want to change dta as well? (yes = 1, no = anything else)";
	    read ans;
	    
	    export NSNS_DIR_NEW_ECC_SHORT=$NSNS_ID$NSNS_DIR_NEW_ECC_SUFFIX

	    echo "Is the directory of the form /nsns_id_(.*)_m(.*)_m(\d)\.(\d+).* (1/0)?"
	    read dirans

	    if [ $dirans -eq 1 ]; then
		id_cmd="$(echo $NSNS_ID | perl -lne '/nsns_id_(.*)_m(.*)_m(\d)\.(\d+).*/ && print "./bns_create_id_nosubmit.sh $ENV{sep} $2 $3.$4 $1 96 10 4 $ENV{NSNS_DIR_NEW_ECC_SHORT}"')"
	    else
		echo "Assuming of form /nsns_id_(.*)_(.*)_m(.*)_m(\d)\.(\d+).* "
		id_cmd="$(echo $NSNS_ID | perl -lne '/nsns_id_(.*)_(.*)_m(.*)_m(\d)\.(\d+).*/ && print "./bns_create_id_nosubmit.sh $ENV{sep} $3 $4.$5 $1 96 10 4 $ENV{NSNS_DIR_NEW_ECC_SHORT}"')"		
	    fi

	    echo $id_cmd
	    cd $NSNS_DIR_SCRIPTS && eval $id_cmd
	    
	    sed -i 's/$SolveForOmega="true";/$SolveForOmega="false";/g' $NSNS_DIR_NEW_ECC/DoMultipleRuns.input
	    sed -i "s/FixOmegaTo = undef;/FixOmegaTo = $NEW_OMEGA0;/g" $NSNS_DIR_NEW_ECC/DoMultipleRuns.input

	    if [ $ans -eq 1 ]; then
	    	sed -i "s/dta = 0.0;/dta = $NEW_adot0;/g" $NSNS_DIR_NEW_ECC/DoMultipleRuns.input
	    fi
	    
	    cd $NSNS_DIR_NEW_ECC;
	    # rm -rf *res*
	    # rm -rf EvID
	    ./StartJob.sh
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

