#!/usr/bin/python

import numpy as np
from vtk import vtkXMLStructuredGridReader
from vtk.util import numpy_support as VN
import math
from math import *
import os
import sys

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

def get_ye_hist(ye, Minusu_tH, xbounds, ybounds, zbounds, theta_max, ye_bin_values, ye_polar_bin_values, ye_equa_bin_values):

    for i in range(0,len(ye)):
        x,y,z = data0.GetPoint(i)
        if Minusu_tH[i] > 1.:
            for j in range(0,len(ye_bins)):
                if ye[i] <= ye_bins[j]:
                    dV = get_dV(x,y,z,xbounds,ybounds,zbounds,201,201,101)
                    r = sqrt(x**2 + y**2 + z**2)
                    theta = acos(z/r)
                    ye_bin_values[j] += dV*Rho[i]

                    if theta < math.radians(theta_max) or theta > math.radians(180 - theta_max):
                        ye_polar_bin_values[j] += dV*Rho[i]
                    elif theta > math.radians(theta_max) and theta < math.radians(180 - theta_max):
                        ye_equa_bin_values[j] += dV*Rho[i]


def get_vinf_hist(Rho, Minusu_tH, xbounds, ybounds, zbounds, theta_max, vinf_bin_values, vinf_polar_bin_values, vinf_equa_bin_values):

    for i in range(0,len(Rho)):
        x,y,z = data0.GetPoint(i)
        if Minusu_tH[i] > 1.:
            A = Rho[i]*(Minusu_tH[i] - 1)
            B = Rho[i]
            vinf = sqrt(1-1/(1+A/B)/(1+A/B))
            for j in range(0,len(vinf_bins)):
                if vinf <= vinf_bins[j]:
                    dV = get_dV(x,y,z,xbounds,ybounds,zbounds,201,201,101)
                    r = sqrt(x**2 + y**2 + z**2)
                    theta = acos(z/r)
                    vinf_bin_values[j] += dV*Rho[i]
                    
                    if theta < math.radians(theta_max) or theta > math.radians(180 - theta_max):
                        vinf_polar_bin_values[j] += dV*Rho[i]
                    elif theta > math.radians(theta_max) and theta < math.radians(180 - theta_max):
                        vinf_equa_bin_values[j] += dV*Rho[i]

if len(sys.argv) != 5:
    print("ejecta_ye_from_pvd.py xbounds ybounds zbounds theta_max")
    sys.exit(0)

vtk_files = []
source = os.getcwd()
for root, dirs, filenames in os.walk(source):
    for f in filenames:
        fullpath = os.path.join(source, f)
        vtk_files.append(fullpath)

ye_bins = np.arange(0., 19.5/36., 1./36.)
ye_bin_values = np.zeros(len(ye_bins))
ye_polar_bin_values = np.zeros(len(ye_bins))
ye_equa_bin_values = np.zeros(len(ye_bins))

vinf_bins = np.arange(0.05,1.05,0.05)
vinf_bin_values = np.zeros(len(vinf_bins))
vinf_polar_bin_values = np.zeros(len(vinf_bins))
vinf_equa_bin_values = np.zeros(len(vinf_bins))

xbounds = float(sys.argv[1])
ybounds = float(sys.argv[2])
zbounds = float(sys.argv[3])
theta_max = float(sys.argv[4])

reader0 = vtkXMLStructuredGridReader()
len_vtk_files = len(vtk_files)
for i in range(0,len_vtk_files):
    reader0.SetFileName(vtk_files[i])
    reader0.Update()
    print("Parsing file " + str(vtk_files[i]))
    print("Done " + str(i) + " / " + str(len(vtk_files)))
    data0 = reader0.GetOutput()
    Ye = VN.vtk_to_numpy(data0.GetPointData().GetArray("Ye"))
    Minusu_tH = VN.vtk_to_numpy(data0.GetPointData().GetArray("Minusu_tH"))
    Rho = VN.vtk_to_numpy(data0.GetPointData().GetArray("Rho"))
    get_ye_hist(Ye, Minusu_tH, xbounds, ybounds, zbounds, theta_max, ye_bin_values, ye_polar_bin_values, ye_equa_bin_values)
    get_vinf_hist(Rho, Minusu_tH, xbounds, ybounds, zbounds, theta_max, vinf_bin_values, vinf_polar_bin_values, vinf_equa_bin_values)

f = open("ye_on_grid_hyvolumedata_theta_" + str(theta_max) + "_all.dat","w+")
for j in range(0,len(ye_bin_values)):
    f.write(str(ye_bins[j]) + " " + str(ye_bin_values[j]) + "\n")

f = open("ye_on_grid_hyvolumedata_theta_" + str(theta_max) + "_polar.dat","w+")
for j in range(0,len(ye_bin_values)):
    f.write(str(ye_bins[j]) + " " + str(ye_polar_bin_values[j]) + "\n")

f = open("ye_on_grid_hyvolumedata_theta_" + str(theta_max) + "_equa.dat","w+")
for j in range(0,len(ye_bin_values)):
    f.write(str(ye_bins[j]) + " " + str(ye_equa_bin_values[j]) + "\n")

f = open("vinf_on_grid_hyvolumedata_theta_" + str(theta_max) + "_all.dat","w+")
for j in range(0,len(vinf_bin_values)):
    f.write(str(vinf_bins[j]) + " " + str(vinf_bin_values[j]) + "\n")

f = open("vinf_on_grid_hyvolumedata_theta_" + str(theta_max) + "_polar.dat","w+")
for j in range(0,len(vinf_bin_values)):
    f.write(str(vinf_bins[j]) + " " + str(vinf_polar_bin_values[j]) + "\n")

f = open("vinf_on_grid_hyvolumedata_theta_" + str(theta_max) + "_equa.dat","w+")
for j in range(0,len(vinf_bin_values)):
    f.write(str(vinf_bins[j]) + " " + str(vinf_equa_bin_values[j]) + "\n")
