perl -i -p0e 's/ReflectZ=true/ReflectZ=false/g' ./*.input
perl -i -p0e 's/Symmetry=ReflectZ/Symmetry=None/g' ./*.input
perl -i -p0e 's/DomainSymmetry         = ReflectZ/DomainSymmetry         = None/g' ./*.input
perl -i -p0e 's/Symmetry = Equatorial/Symmetry = None/g' ./*.input
perl -i -p0e 's/DomainSymmetry     = ReflectZ/DomainSymmetry     = None/g' ./*.input

# Also set -z0, z0 in HyDomain.input otherwise you will only see half the mass evolving
