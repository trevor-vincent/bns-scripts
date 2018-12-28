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

#run_name = sys.argv[1]
#is_it_linear = int(sys.argv[2])
#file1 = "iterations.log"
#file2 = "points.log"
#file3 = "norms_u.log"

run_labels = []
files = []
num_runs = int(sys.argv[1])
total_args = num_runs*2 + 2

if len(sys.argv) != total_args:
    print(len(sys.argv))
    print(total_args)
    print("len(sys.argv) != num_runs*2 + 2")
    print("d4est_get_plots.py <file(s)> <run(s)>")
    exit


for i in range(0,num_runs):
    files.append(sys.argv[2 + i])
    run_labels.append(sys.argv[2 + num_runs + i])

for i in range(0,num_runs):

    dof = []
    dof_1o3 = []
    avg_deg = []
    linfty = []
    l2 = []
    energy = []
    estimator = []
    quad = []
    j = 0 
    print(files[i])
    with open(files[i], 'r',encoding='ascii') as f:
        reader = csv.reader(f, delimiter=' ')
        for row in reader:
  #          print(row)
            if j != 0 and j != 1:
                dof.append(float(row[1]))
                quad.append(float(row[0]))
                avg_deg.append((pow(dof[-1]/quad[-1],1./3.) - 1))
                l2.append(float(row[3]))
                dof_1o3.append(pow(dof[-1], 1./3.))
                linfty.append(float(row[4]))
                energy.append(float(row[5]))
                estimator.append(float(row[6]))
            j = j + 1

 #   print(dof)
#    print(linfty)
    plt.plot(dof_1o3,l2,label=run_labels[i],color='black',linestyle=':', marker='o', markersize =1)


plt.tick_params(axis='both', which='both', labelsize=8)
plt.xlabel(r"DOF^{1/3}",fontsize=8)
plt.grid()
plt.legend(loc=0, prop={'size':5})
plt.yscale('log')
plt.savefig("figs.pdf",rasterizes=False)

