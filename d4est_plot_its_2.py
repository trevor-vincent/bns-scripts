#!/scinet/niagara/software/2018a/opt/base/anaconda3/5.1.0/bin/python3
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.ticker import FormatStrFormatter
plt.gca().xaxis.set_major_formatter(FormatStrFormatter('%g'))
import csv
import sys
import numpy as np
from math import *
from scipy import stats

file1 = sys.argv[1]
file2 = sys.argv[2]
num_points = 4
point_rows = []

labels = ["(0,0,0)", "(3,0,0)", "(10,0,0)", "(100,0,0)"]
linestyles = ["-", ":", "--", "-."]
axes_labels = [r'Amr iteration',"",r'Max Krylov Iterations \cross Newton Iterations',r'$|u_i-u_{SpEC}|$']

def plot_function (file12):
    amr_it = []
    big_snes = []
    big_ksp = []
    big_time = []
    big_snesksp = []
    i = 0
    with open(file12, 'r',encoding='ascii') as f:
        reader = csv.reader(f, delimiter=' ')
        for row in reader:
            if i == 0 or amr_it[-1] != float(row[4]) :
                amr_it.append(float(row[4]))
                big_ksp.append(float(row[6]))
                big_time.append(float(row[8]))
                big_snes.append(float(row[5]))
                big_snesksp.append(big_ksp[-1]*big_snes[-1])
            else:
                big_snes[-1] = float(row[5])
                big_ksp[-1] = float(row[6])
                big_time[-1] = float(row[8])
                big_snesksp[-1] = big_ksp[-1]*big_snes[-1]
                i = i + 1

    plt.plot(amr_it,big_snesksp,color='black',linestyle=linestyles[0], marker='o')

plot_function(file1)
plot_function(file2)

l = plt.legend(loc=0, prop={'size':13})
l.get_frame().set_edgecolor('black')
plt.tick_params(axis='both', which='major', labelsize=15)
plt.tick_params(axis='both', which='minor', labelsize=8)

plt.ylabel(axes_labels[1],fontsize=15)
plt.xlabel(axes_labels[0],fontsize=15)
plt.grid()
plt.tight_layout()
plt.savefig("its_" + str(max(amr_it)) + "_" + str(max(big_snesksp)) + "_.pdf",rasterized=False)
