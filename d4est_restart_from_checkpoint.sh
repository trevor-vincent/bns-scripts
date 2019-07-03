cd Checkpoints
if ls $(ls -1 | tail -n1) | grep -q "checkpoint_0.h5"; then
    export CP_DIR=$(ls -1 | tail -n1)
    export NEWTON=0
#    echo "We are using newton checkpoint = $NEWTON";
#    echo "Checkpoint dir = $CP_DIR";
else
    export NEWTON_PREFIX=$(ls $(ls -1 | tail -n1) -1 | grep p4est | sort | tail -n1 | cut -d '.' -f1)
    export NEWTON=1
    export CP_DIR=$(ls -1 | tail -n2 | head -n1)
#    echo "We are using newton checkpoint = $NEWTON";
#    echo "NEWTON_PREFIX = $NEWTON_PREFIX";
#    echo "Checkpoint dir = $CP_DIR";
fi;
cd ..

sed -i "s/load_from_checkpoint =.*/load_from_checkpoint = 1/g" options.input
sed -i "s/load_from_newton_checkpoint =.*/load_from_newton_checkpoint = $NEWTON/g" options.input
sed -i "s/newton_checkpoint_prefix =.*/newton_checkpoint_prefix = $NEWTON_PREFIX/g" options.input
sed -i "s/checkpoint_number =.*/checkpoint_number = $CP_DIR/g" options.input
sed -i "s/initial_checkpoint_number =.*/initial_checkpoint_number = 1/g" options.input
