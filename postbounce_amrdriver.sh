#!/bin/bash

OLD_RUN=$1
NEW_RUN=$2

cd $NEW_RUN
#sed -i 's/TruncationErrorMax =/TruncationErrorMax = .0001;/g' AmrDriver.input
sed -i '24,38d' AmrDriver.input
sed -i '/# value_C/a\        TruncationErrorMax = Add(Center=0,0,0;Value = 0.0005;RadialProfile = Constant(Value=1););' AmrDriver.input




