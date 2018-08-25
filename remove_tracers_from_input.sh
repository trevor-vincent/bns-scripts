#!/bin/bash

sed -i 's/FollowTracerParticles=true;/FollowTracerParticles=false;/g' Evolution.input
sed -i 's/TracerX(/#TracerX(/g' Evolution.input
sed -i 's/,RhoYe,TracerX/,RhoYe/g' Evolution.input
sed -i 's/,1,1000000/,1/g' Evolution.input
sed -i 's/FollowTracerParticles = true/FollowTracerParticles = false/g' HySetupAndEvolution.input
sed -i '3,53s/^/#/' HyObservers.input
sed -i '10,157s/^/#/' HyDataBoxItems.input
sed -i 's/CopyTracerFromParent/#CopyTracerFromParent/g' HyDataBoxItems.input
