#!/bin/bash

sed -i 's/Cores = .*/Cores = 408/g' MakeSubmit.input
sed -i 's/ForceCores = .*/ForceCores = True/g' MakeSubmit.input
sed -i 's/AllowUnusedCores = .*/AllowUnusedCores = False/g' MakeSubmit.input
sed -i 's/Hours = .*/Hours = 168/g' MakeSubmit.input
sed -i 's/Hy(Fraction=.*)/Hy(Fraction=384)/g' Evolution.input
sed -i 's/Gr(Fraction=.*)/Gr(Fraction=24))/g' Evolution.input