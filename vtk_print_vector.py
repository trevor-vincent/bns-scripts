import numpy
from vtk import vtkXMLStructuredGridReader
from vtk.util import numpy_support as VN
import math
import os
import sys
total = len(sys.argv)
firstdirectory = '/home/tvincent/Dropbox/Research/Notes/BNS-Project/M1_Compare/NEW/FInertiala0'
seconddirectory = '/home/tvincent/Dropbox/Research/Notes/BNS-Project/M1_Compare/OLD/FInertiala0'

def errdiff(firstfile, secondfile, vector):
    reader0 = vtkXMLStructuredGridReader()
    reader0.SetFileName(firstfile)
    reader0.Update()
    data0 = reader0.GetOutput()
    u0 = VN.vtk_to_numpy(data0.GetPointData().GetArray(vector))
    errmax = -1
    errmax_x = -1
    errmax_y = -1
    errmax_z = -1
    errmax_i = -1
    reader1 = vtkXMLStructuredGridReader()
    reader1.SetFileName(secondfile)
    reader1.Update()
    data1 = reader1.GetOutput()
    u1 = VN.vtk_to_numpy(data1.GetPointData().GetArray(vector))
    # print "Points = ", data0.GetNumberOfPoints(), data1.GetNumberOfPoints()
    for i in range(data1.GetNumberOfPoints()):
        x,y,z = data0.GetPoint(i)
        u0x,u0y,u0z = u0[i]
        u1x,u1y,u1z = u1[i]
        err = max(abs(u0x - u1x),abs(u0y - u1y),abs(u0z - u1z))
        if err > errmax:
            errmax = err
            errmax_x = x
            errmax_y = y
            errmax_z = z
            errmax_i = i
            # print x,y,z,u0x,u0y,u0z,u1x,u1y,u1z,err

    print os.path.basename(firstfile), errmax_x, errmax_y, errmax_z, u0[errmax_i], u1[errmax_i], errmax


for filename in os.listdir(firstdirectory):
    if filename.endswith("vts"):
        firstfile = os.path.join(firstdirectory, filename)
        secondfile = os.path.join(seconddirectory, filename)
        # print firstfile, secondfile
        errdiff(firstfile,secondfile,'FInertiala')
    else:
        continue


