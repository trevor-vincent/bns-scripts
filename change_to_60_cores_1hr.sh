#!/bin/bash

sed -i 's/Cores = .*/Cores = 60/g' MakeSubmit.input
sed -i 's/ForceCores = .*/ForceCores = True/g' MakeSubmit.input
sed -i 's/AllowUnusedCores = .*/AllowUnusedCores = False/g' MakeSubmit.input
sed -i 's/Hours = .*/Hours = 1/g' MakeSubmit.input
sed -i 's/Hy(Fraction=.*)/Hy(Fraction=48)/g' Evolution.input
sed -i 's/Gr(Fraction=.*)/Gr(Fraction=12))/g' Evolution.input