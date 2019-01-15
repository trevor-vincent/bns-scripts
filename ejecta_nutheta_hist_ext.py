# [1] Time 
# [2] Particle mass 
# [3-5] Coords
# [6] ENue
# [7] Eavg_e
# [8-10] FtGride
# [11] ClosureXi_nue

import matplotlib
import matplotlib as mpl
import matplotlib.pyplot as plt
import csv
import numpy as np
import io
from math import *
import math
import sys

pgf_with_rc_fonts = {"pgf.texsystem": "pdflatex"}
matplotlib.rcParams.update(pgf_with_rc_fonts)

#plt.rc('text', usetex=False)
#plt.rc('font', family='serif')
plt.rcParams["figure.facecolor"] = "white"
plt.rcParams["axes.facecolor"] = "white"
plt.rcParams["savefig.facecolor"] = "white"
file = sys.argv[1]
plot_option = sys.argv[2]
print("file = " + file)

if len(sys.argv) != 2:
    print("..._hist_ext.py <file> <plot_option=flux,avg>")
    exit(1)

 
ENu = []
Eavg = []
theta = []

with io.open(file, mode='r',encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        ENu.append(float(row[5]))
        Eavg.append(float(row[6]))
        x = float(row[2])
        y = float(row[3])
        z = float(row[4])
        r = sqrt(x**2 + y**2 + z**2)
        theta.append(180*acos(z/r)/math.pi)
        
# [2] = A[B lt   0.050000000]
# [3] = A[B lt    0.10000000]
# [4] = A[B lt    0.15000000]
# [5] = A[B lt    0.20000000]
# [6] = A[B lt    0.25000000]
# [7] = A[B lt    0.30000000]
# [8] = A[B lt    0.35000000]
# [9] = A[B lt    0.40000000]
# [10] = A[B lt    0.45000000]
# [11] = A[B lt    0.50000000]
# [12] = A[B lt    0.55000000]
# [13] = A[B lt    0.60000000]
# [14] = A[B lt    0.65000000]
# [15] = A[B lt    0.70000000]
# [16] = A[B lt    0.75000000]
# [17] = A[B lt    0.80000000]
# [18] = A[B lt    0.85000000]
# [19] = A[B lt    0.90000000]
# [20] = A[B lt    0.95000000]
# [21] = A[B gt   9.4999999999999996e-01]

theta_bins = np.arange(10,190,10)
theta_bin_values = np.zeros(len(theta_bins))
print(theta_bin_values)

for i in range(0,len(theta)):
    for j in range(0,len(theta_bins)):
        if theta[i] <= theta_bins[j]:
            if plot_option = "flux":
                theta_bin_values[j] += ENu[i]
            elif plot_option = "avg":
                theta_bin_values[j] += Eavg[i]
            else:
                print("plot option must be flux or avg")
                sys.exit(1)
            break

fig, ax = plt.subplots()
index = np.arange(20)
print(index)
plt.bar(index, theta_bin_values)

theta_bin_strings = []

for i in range(0,len(theta_bins)):
    theta_bin_strings.append('{:.2f}'.format(theta_bins[i]))

print(theta_bin_strings)
ax.set_xticks(index)
ax.set_xticklabels(theta_bin_strings)

for label in  ax.xaxis.get_ticklabels()[::2]:
    label.set_visible(False)

plt.xlabel(r"$\theta$",fontsize=15)
if plot_option = "flux":
    plt.ylabel(r'$\int F_\nu dS$',fontsize=15)
elif plot_option = "avg":
    plt.ylabel(r'$<\nu> (MeV)$',fontsize=15)
else:
    print("plot option must be flux or avg")
    sys.exit(1)

plt.savefig("theta_hist_" + str(plot_option) + ".pdf",rasterized=False)
