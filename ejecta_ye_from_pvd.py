#!/usr/bin/python

import numpy as np
from vtk import vtkXMLStructuredGridReader
from vtk.util import numpy_support as VN
import math
import os
import sys

ye_bins = np.arange(0., 19.5/36., 1./36.)
ye_bin_values = np.zeros(len(ye_bins))
print(ye_bins)
print(ye_bin_values)

reader0 = vtkXMLStructuredGridReader()
reader0.SetFileName("UnboundRhoYe.pvd")
reader0.Update()
data0 = reader0.GetOutput()

Ye = VN.vtk_to_numpy(data0.GetPointData().GetArray("Ye"))
Minusu_tH = VN.vtk_to_numpy(data0.GetPointData().GetArray("Minusu_tH"))
Rho = VN.vtk_to_numpy(data0.GetPointData().GetArray("Rho"))

def get_dV(x,y,z,xbounds,ybounds,zbounds,xextents,yextents,zextents):

    dx = 2*xbounds/(xextents-1)
    dy = 2*ybounds/(yextents-1)
    dz = 2*zbounds/(zextents-1) 

    if x >= -xbounds and x <= xbounds:
        return dx*dy*dz
    elif x >= -2*xbounds and x <= 2*xbounds:
        return 2*dx*2*dy*2*dz
    else:
        return 4*dx*4*dy*4*dz


for i in range(data1.GetNumberOfPoints()):
    x,y,z = data0.GetPoint(i)
    if Minusu_tH[i] > 1.:
        for j in range(0,len(ye_bins)):
            if ye[i] <= ye_bins[j]:
                get_dV(x,y,z,xbounds,ybounds,zbounds,xextents,yextents,zextents)
                if theta_max >= 0:
                    r = sqrt(x**2 + y**2 + z**2)
                    theta = acos(z/r)
                    if theta_type == "polar" and (theta < math.radians(theta_max) or theta > math.radians(180 - theta_max)):
                        ye_bin_values[j] += dV*Rho[i]
                    elif theta_type == "equatorial" and (theta > math.radians(theta_max) and theta < math.radians(180 - theta_max)):
                        ye_bin_values[j] += dV*Rho[i]
                else:
                    ye_bin_values[j] += dV*Rho[i]



f = open("Yebins_on_grid_theta" + str(theta_max) + ".dat")
for i in range(0,len(ye_bin_values)):
    f.write(str(ye_bins[j]) + " " + str(ye_bin_values[j]))
