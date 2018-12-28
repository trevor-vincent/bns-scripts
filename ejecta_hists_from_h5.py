#!/usr/bin/python

import numpy as np
import h5py
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

def get_hist(x,
             y,
             z,
             ye,
             Rho,
             Minusu_tH,
             xbounds,
             ybounds,
             zbounds,
             theta_max,
             ye_bin_values,
             ye_polar_bin_values,
             ye_equa_bin_values,
             vinf_bin_values,
             vinf_polar_bin_values,
             vinf_equa_bin_values):

    for i in range(0,len(ye)):
        # print(i)
        xi = x[i]
        yi = y[i]
        zi = z[i]
        if Minusu_tH[i] > 1.:
            A = Rho[i]*(Minusu_tH[i] - 1)
            B = Rho[i]
            vinf = sqrt(1-1/(1+A/B)/(1+A/B))
            dV = get_dV(xi,yi,zi,xbounds,ybounds,zbounds,201,201,101)
            r = sqrt(xi**2 + yi**2 + zi**2)
            theta = acos(zi/r)

            for j in range(0,len(ye_bins)):
                if ye[i] <= ye_bins[j]:
                    ye_bin_values[j] += dV*Rho[i]

                    if theta < math.radians(theta_max) or theta > math.radians(180 - theta_max):
                        ye_polar_bin_values[j] += dV*Rho[i]
                    elif theta > math.radians(theta_max) and theta < math.radians(180 - theta_max):
                        ye_equa_bin_values[j] += dV*Rho[i]

                if vinf <= vinf_bins[j]:
                    vinf_bin_values[j] += dV*Rho[i]                    
                    if theta < math.radians(theta_max) or theta > math.radians(180 - theta_max):
                        vinf_polar_bin_values[j] += dV*Rho[i]
                    elif theta > math.radians(theta_max) and theta < math.radians(180 - theta_max):
                        vinf_equa_bin_values[j] += dV*Rho[i]

if len(sys.argv) != 5:
    print("ejecta_ye_from_pvd.py xbounds ybounds zbounds theta_max")
    sys.exit(0)

h5_files = []
source = os.getcwd()
for root, dirs, filenames in os.walk(source):
    for f in filenames:
        fullpath = os.path.join(source, f)
        h5_files.append(fullpath)

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

len_h5_files = len(h5_files)
for i in range(0,len_h5_files):
    
    print("Parsing file " + str(h5_files[i]))
    print("Done " + str(i) + " / " + str(len(h5_files)))
    
    f = h5py.File(h5_files[i],  "a")
    Rho = f['/Rho/Step000000/scalar']
    Ye = f['/Ye/Step000000/scalar']
    Minusu_tH = f['/Minusu_tH/Step000000/scalar']
    x = f['/GridToInertialFD--MappedCoords/Step000000/x']
    y = f['/GridToInertialFD--MappedCoords/Step000000/y']
    z = f['/GridToInertialFD--MappedCoords/Step000000/z']

    get_hist(x,y,z,Ye, Rho, Minusu_tH, xbounds, ybounds, zbounds, theta_max, ye_bin_values, ye_polar_bin_values, ye_equa_bin_values, vinf_bin_values, vinf_polar_bin_values, vinf_equa_bin_values)

    # if i == 1:
        # break

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
