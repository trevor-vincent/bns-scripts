#find ./ -type l -print0 | xargs -0 ls -plah | grep "Run ->" | cut -d '.' -f2 | cut -d '-' -f2 | cut -d '>' -f2 | while read fname
find ${PWD} -type l -print0 | xargs -0 ls -plah | grep "Run ->" | while read fstring; do

    sym_folder=$(echo $fstring | cut -d ' ' -f9)
    num_folder=$(echo $fstring | cut -d ' ' -f11)
#    cd $sym_folder
#    echo $PWD
#    DIR=$(dirname "${PWD}")
#    BLAH=$(basename "${num_folder}")
 #   touch "$DIR/${BLAH}-is-run.txt"
 #   rm $DIR/Run
 #   mv $DIR/$BLAH $DIR/Run
  #  rm $sym_folder
 #   touch "run_is_${num_folder}"
#    mv ./$num_folder Run
#    cd ..
#    exit
    #sym_folder=$(echo $fstring | cut -d '.' -f2 | cut -d '-' -f1)
    #num_folder=$(echo $fstring | cut -d '.' -f2 | cut -d '-' -f2 | cut -d '>' -f2)
    
    #sym_folder_2=$(echo ".${sym_folder}")
    echo "$sym_folder"
    echo "$num_folder"    
    #echo "$sym_folder_2"
    #cd $sym_folder_2
    #echo $pwd
    #cd ..
    #echo $sym_folder
#echo ".${SYM}"
done

echo "Do you wish to rename these?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done


find ${PWD} -type l -print0 | xargs -0 ls -plah | grep "Run ->" | while read fstring; do

    sym_folder=$(echo $fstring | cut -d ' ' -f9)
    num_folder=$(echo $fstring | cut -d ' ' -f11)
    cd $sym_folder
#    echo $PWD
    DIR=$(dirname "${PWD}")
    BLAH=$(basename "${num_folder}")
    touch "$DIR/${BLAH}-is-run.txt"
    rm $DIR/Run
    mv $DIR/$BLAH $DIR/Run
  #  rm $sym_folder
 #   touch "run_is_${num_folder}"
#    mv ./$num_folder Run
    cd ..
#    exit
    #sym_folder=$(echo $fstring | cut -d '.' -f2 | cut -d '-' -f1)
    #num_folder=$(echo $fstring | cut -d '.' -f2 | cut -d '-' -f2 | cut -d '>' -f2)
    #sym_folder_2=$(echo ".${sym_folder}")
    #echo "$num_folder"    
    #echo "$sym_folder_2"
    #cd $sym_folder_2
    #echo $pwd
    #cd ..
    #echo $sym_folder
#echo ".${SYM}"
done
