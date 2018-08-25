sed -i 's/DomainSymmetry/#DomainSymmetry/g' *.input
sed -i 's/Symmetry=None/#Symmetry=None/g' *.input
sed -i 's/MapPrefixFromGridToOutputFrame=;/MapPrefixFromGridToOutputFrame=<<Identity>>;/g' *.input
