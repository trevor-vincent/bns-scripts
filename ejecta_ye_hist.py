#!/usr/bin/python

import matplotlib
import matplotlib.pyplot as plt
import csv
import numpy as np
import io
from math import *

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
# [7] Ye
# [8] Temp
# [9] Minusu_t
# [10] Minusu_tH
# [11-13] vInertial
Ye = []
Minusu_tH = []

with io.open(file, mode='r',encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        Minusu_tH.append(float(row[9]))
        if Minusu_tH[-1] > 1.:
            Ye.append(float(row[6]))        
        
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


for i in range(0,len(Ye)):
    for j in range(0,len(ye_bins)):
        if Ye[i] <= ye_bins[j]:
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

for j in range(0,len(ye_bins)):
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

plt.xlabel(r"$Ye$",fontsize=15)
plt.ylabel(r'Unbound Particles',fontsize=15)
plt.savefig("ye_hist.pdf",rasterized=False)
