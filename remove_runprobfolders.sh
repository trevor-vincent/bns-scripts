find ${PWD} -type l -print0 | xargs -0 ls -plah | grep "Run_prob" | grep -v "SpEC" | while read fstring; do
folder=$(echo $fstring | cut -d ' ' -f9)
echo $folder
unlink $folder
done

find ${PWD} -type l -print0 | xargs -0 ls -plah | grep "Run_fine" | grep -v "SpEC" | while read fstring; do
folder=$(echo $fstring | cut -d ' ' -f9)
echo $folder
unlink $folder
done

find ${PWD} -type l -print0 | xargs -0 ls -plah | grep "Run_weird" | grep -v "SpEC" | while read fstring; do
folder=$(echo $fstring | cut -d ' ' -f9)
echo $folder
unlink $folder
done
