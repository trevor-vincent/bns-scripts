mass=$(cat ./$1/Run/MatterObservers/UnboundMass.dat | tail -n 1 | cut -d ' ' -f21) && touch $1_disk_mass_$mass.dat
