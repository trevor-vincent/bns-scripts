#!/bin/bash

OLD_RUN=$1
NEW_RUN=$2
OLDTIME=$3
Cptime=$4

sed -i 's/EvolveOnlyThisEnergyGroup = -1;/EvolveOnlyThisEnergyGroup = -1;? SetOpticallyThickEquilibrium=false;/g' HyStateChangers.input 
tr '?' '\n' < HyStateChangers.input > HyStateChangers_new.input
mv HyStateChangers_new.input HyStateChangers.input

sed -i "s/${OLDTIME}/${Cptime}/g" HyStateChangers.input