mass=$(cat ./$1/Run/NeutrinoObservers/NeutrinoFluxaAtBoundary.dat | tail -n 1 | cut -d ' ' -f6) && touch $1_nualum_$mass.dat
mass=$(cat ./$1/Run/NeutrinoObservers/NeutrinoFluxeAtBoundary.dat | tail -n 1 | cut -d ' ' -f6) && touch $1_nuelum_$mass.dat
mass=$(cat ./$1/Run/NeutrinoObservers/NeutrinoFluxxAtBoundary.dat | tail -n 1 | cut -d ' ' -f6) && touch $1_nuxlum_$mass.dat
