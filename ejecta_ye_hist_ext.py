#!/usr/bin/python

import matplotlib
import matplotlib.pyplot as plt
import csv
import numpy as np
import io
from math import *
import sys
import math

plt.rc('text', usetex=False)
plt.rc('font', family='serif')
plt.rcParams["figure.facecolor"] = "white"
plt.rcParams["axes.facecolor"] = "white"
plt.rcParams["savefig.facecolor"] = "white"
file = 'ParticlesFromOutFlowCat.dat'
log_elems = []
mgfcg_iter = []
fcg_iter = []

# [1] Time 
# [2] Particle mass 
# [3-5] Coords
# [6] Rho0Phys
# [7] ye
# [8] Temp
# [9] Minusu_t
# [10] Minusu_tH
# [11-13] vInertial
ye = []
Minusu_tH = []

ejecta_type = str(sys.argv[1])
theta_type = str(sys.argv[2])
theta_max = float(sys.argv[3])

with io.open(file, mode='r',encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        Minusu_tH.append(float(row[9]))
        if Minusu_tH[-1] > 1.:
#           x = float(row[2])
#           y = float(row[3])
#            z = float(row[4])
#            r = sqrt(x**2 + y**2 + z**2)
#            theta = (acos(z/r))
            if theta_max >= 0:
                if ejecta_type != "left_grid_only":
                    print("if theta_max >= 0, ejecta must be on_grid_only and not " + str(ejecta_type))
                    sys.exit()
                x = float(row[2])
                y = float(row[3])
                z = float(row[4])
                r = sqrt(x**2 + y**2 + z**2)
                theta = acos(z/r)
                if theta_type == "polar" and (theta < math.radians(theta_max) or theta > math.radians(180 - theta_max)):
                    ye.append(float(row[6]))        
                elif theta_type == "equatorial" and (theta > math.radians(theta_max) and theta < math.radians(180 - theta_max)):
                    ye.append(float(row[6]))        
            else:
                ye.append(float(row[6]))



#            if (theta < theta_max || theta > pi - theta):


# [1] = time
# [2] = A[B lt      0.000000]
# [3] = A[B lt   0.027777778]
# [4] = A[B lt   0.055555556]
# [5] = A[B lt   0.083333333]
# [6] = A[B lt    0.11111111]
# [7] = A[B lt    0.13888889]
# [8] = A[B lt    0.16666667]
# [9] = A[B lt    0.19444444]
# [10] = A[B lt    0.22222222]
# [11] = A[B lt    0.25000000]
# [12] = A[B lt    0.27777778]
# [13] = A[B lt    0.30555556]
# [14] = A[B lt    0.33333333]
# [15] = A[B lt    0.36111111]
# [16] = A[B lt    0.38888889]
# [17] = A[B lt    0.41666667]
# [18] = A[B lt    0.44444444]
# [19] = A[B lt    0.47222222]
# [20] = A[B lt    0.50000000]
# [21] = A[B gt   5.0000000000000000e-01]

ye_bins = np.arange(0., 19.5/36., 1./36.)
ye_bin_values = np.zeros(len(ye_bins))
print(ye_bins)
print(ye_bin_values)


for i in range(0,len(ye)):
    for j in range(0,len(ye_bins)):
        if ye[i] <= ye_bins[j]:
            ye_bin_values[j] += 1
            break

rows = []
with io.open("YeBin.agr", mode='r', encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        #print(row)
        rows.append(row)
        #time.append(float(row[0]))

y = []
for i in rows[-1]:
    if str(i) != "":
        y.append(float(i)/1e-8)

y.pop(0)
print(y)

if ejecta_type == "left_grid_only":
    print("ejecta_type = left_grid_only")
elif ejecta_type == "on_grid_only":
    print("ejecta_type = on_grid_only")
else:
    print("ejecta_type = combined")

for j in range(0,len(ye_bins)):
    if ejecta_type == "left_grid_only":
        ye_bin_values[j] *= 1e-8
    elif ejecta_type == "on_grid_only":
        ye_bin_values[j] = y[j]
    else:
        ye_bin_values[j] *= 1e-8                   
        ye_bin_values[j] += y[j]

fig, ax = plt.subplots()
index = np.arange(20)
print(index)
plt.bar(index, ye_bin_values)

ye_bin_strings = []

for i in range(0,len(ye_bins)):
    ye_bin_strings.append('{:.2f}'.format(ye_bins[i]))

print(ye_bin_strings)
ax.set_xticks(index)
ax.set_xticklabels(ye_bin_strings)

for label in  ax.xaxis.get_ticklabels()[::2]:
    label.set_visible(False)

ax.set_yscale('log')

plt.xlabel(r"$ye$",fontsize=15)
plt.ylabel(r'Unbound Mass $(M_\odot)$',fontsize=15)
#plt.savefig("ye_hist.pdf",rasterized=False)
plt.savefig("ye_hist_" + str(ejecta_type) + "_" + str(theta_max) + "_" + sys.argv[2] + ".pdf",rasterized=False)
