import h5py
import sys

if len(sys.argv) != 5:
    print("There needs to be 5 arguments")
    print("h5read filepath dx dy dz")
    exit

dx = sys.argv[2]
dy = sys.argv[3]
dz = sys.argv[4]
fileName = sys.argv[1]

print "fileName, dx, dy, dz = %s %s %s %s" % (fileName, dx, dy, dz)

f = h5py.File(fileName,  "a")
tx = f['/TracerX/Step000000/x']
ty = f['/TracerX/Step000000/y']
tz = f['/TracerX/Step000000/y']
Rho = f['/Rho/Step000000/scalar']

exists = "Mass" in f
if exists:
    f.close()
    print "Mass exists in %s" % (fileName)
    exit
    
grp = f.create_group('Mass')
grp1 = grp.create_group('Step000000')
grp1.create_dataset("scalar",(len(Rho),),dtype='f')
Mass = f['/Mass/Step000000/scalar']
for i in range(len(Mass)):
    Mass[i]=Rho[i]*float(dx)*float(dy)*float(dz)
f.close()



