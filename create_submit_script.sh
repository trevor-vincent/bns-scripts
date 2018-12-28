
function write_submit_niagara {
    cat <<EOF1 > submit.sh
#!/bin/bash
#SBATCH --nodes=${3}
#SBATCH --time=0-${4}:00           # time (DD-HH:MM)

cd ${1}
${2}  2>&1 | tee submit.out

EOF1
}

if [ "$#" -ne 3 ]; then
    echo "arguments = $#"
    echo "create_submit_script.sh <command> <nodes> <hours>"
fi 

command="$1"
nodes="$2"
hours="$3"
path="${PWD}"

echo "command = $command"
echo "nodes = $nodes"
echo "hours = $hours"
echo "path = $path"

write_submit_niagara "$path" "$command" "$nodes" "$hours"
