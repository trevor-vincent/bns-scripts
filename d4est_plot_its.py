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
import os

run_labels = []
files = []

if len(sys.argv) <= 4:
    print("d4est_plot_norm.py <use_log> <is_it_linear> <its_type> <num_runs> <file(s)> <run(s)>")
    exit

use_log = int(sys.argv[1])
is_it_linear = int(sys.argv[2])
its_type = sys.argv[3]
num_runs = int(sys.argv[4])
total_args = num_runs*2 + 2 + 3
print(num_runs)
if len(sys.argv) != total_args:
    print("len sys = " + str(len(sys.argv)))
    print("total_args = " +  str(total_args))
    print("num_runs = " + str(num_runs))
    print("len(sys.argv) != num_runs*2 + 2 + 1")
    print("d4est_plot_its.py <use_log> <is_it_linear> <its_type> <num_runs> <file(s)> <legend labels(s)>")
    exit

for i in range(0,num_runs):
    files.append(sys.argv[2 + i + 3])
    run_labels.append(sys.argv[2 + num_runs + i + 3])
    print(run_labels[-1])

for j in range(0,num_runs):
    dof = []
    dof_1o3 = []
    amr_it = []
    big_snes = []
    big_ksp = []
    big_time = []
    big_snesksp = []
    i = 0
    file_norms = str(os.path.dirname(files[j]) + "/norms_u.log")
    print(file_norms)
    k = 0 
    with open(file_norms, 'r',encoding='ascii') as f:
        reader = csv.reader(f, delimiter=' ')
        for row in reader:
            if k != 0 and k != 1:
                dof.append(float(row[1]))
                dof_1o3.append(pow(dof[-1], 1./3.))
            k = k + 1

    if is_it_linear == 0:
        print("USING NONLINEAR PLOTTING")
        with open(files[j], 'r',encoding='ascii') as f:
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
    else:
        print("USING LINEAR PLOTTING")
        with open(files[j], 'r',encoding='ascii') as f:
            reader = csv.reader(f, delimiter=' ')
            for row in reader:
                if i == 0 or amr_it[-1] != float(row[4]) :
                    amr_it.append(float(row[4]))
                    big_ksp.append(float(row[5]))
                    big_time.append(float(row[7]))
                    big_snes.append(1)
                    big_snesksp.append(big_ksp[-1])
                else:
                    big_snes[-1] = 1
                    big_ksp[-1] = float(row[5])
                    big_time[-1] = float(row[7])
                    big_snesksp[-1] = big_ksp[-1]
                i = i + 1

                
    print(files[j])
    print(run_labels[j])
    print(amr_it)
    print(big_ksp)
    print(big_time)
    print(dof_1o3)

    if its_type == 'ksp':
        plt.plot(dof_1o3,big_ksp[:-1],label=run_labels[j],linestyle=':', marker='o', markersize =5)
        plt.ylabel(r"KSP iterations")
    elif its_type == 'time' or norm_type == 'linfty_uniform':
        plt.plot(dof_1o3,big_time[:-1],label=run_labels[j],linestyle=':', marker='o', markersize =5)
        plt.ylabel(r"Time (s)")
    elif its_type == 'snesksp':
        plt.plot(dof_1o3,big_snesksp[:-1],label=run_labels[j],linestyle=':', marker='o', markersize =5)
        plt.ylabel(r"SNES*KSP iterations")
    else:
        print("not supported yet")

if use_log == 1:
    plt.yscale('log')

plt.tick_params(axis='both', which='both', labelsize=8)
plt.xlabel(r"DOF$^{1/3}$",fontsize=8)
plt.grid()
plt.legend(loc=0)
plt.savefig("figs.pdf",rasterizes=False)
