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

if len(sys.argv) != 2:
    print("d4est_get_plots.py <run_name> <linear? = 0,1>")

run_name = sys.argv[1]
is_it_linear = int(sys.argv[2])
file1 = "iterations.log"
file2 = "points.log"
file3 = "norms_u.log"

amr_it = []
big_snes = []
big_ksp = []
big_time = []
big_snesksp = []
i = 0

if is_it_linear == 0:
    with open(file1, 'r',encoding='ascii') as f:
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
    with open(file1, 'r',encoding='ascii') as f:
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
                big_ksp[-1] = float(row[6])
                big_time[-1] = float(row[8])
                big_snesksp[-1] = big_ksp[-1]
                i = i + 1

for i in range(1, len(big_snesksp)):
    big_snesksp[i] = big_snesksp[i] + big_snesksp[i-1]
    big_time[i] = big_time[i] + big_time[i-1]

its_axes_labels = [r'Amr iteration',r'KSP*SNES its', r'Wall time']

fig, ax = plt.subplots(3, 2, squeeze=False)#, sharex='col', sharey='row')
fig.suptitle(run_name, fontsize=12)
ax[0,0].plot(amr_it,big_snesksp,color='black',linestyle='-', marker='o')
ax[0,0].set_xlabel(its_axes_labels[0],fontsize=8)
ax[0,0].set_title(its_axes_labels[1],fontsize=8)
ax[0,0].tick_params(axis='both', which='both', labelsize=8)
ax[0,1].plot(amr_it,big_time,color='black',linestyle='-', marker='o')
ax[0,1].tick_params(axis='both', which='both', labelsize=8)
ax[0,1].set_xlabel(its_axes_labels[0],fontsize=8)
ax[0,1].set_title(its_axes_labels[2],fontsize=8)

num_points = 4
point_rows = []

for i in range(0,num_points):
    point_rows.append([])

p = 0
with open(file2, 'r',encoding='ascii') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        point_rows[p % num_points].append(row)
        p += 1
                
row_x = 0
row_y = 3

labels = ["(0,0,0)", "(3,0,0)", "(10,0,0)", "(100,0,0)"]
linestyles = ["-", ":", "--", "-."]
axes_labels = [r'DOF^{1/3}',"",r'$|u_i-u_{i+1}|$',r'$|u_i-u_{SpEC}|$']

m = -1
b = -1
low_err = -1
high_dof = -1
for p in range(0,num_points):
    x= []
    y = []
    z = []
    for i in range(0,len(point_rows[2])):
        xi = point_rows[p][i][row_x]
        yi = point_rows[p][i][row_y]
        print(xi,yi)
        x.append(float(xi)**(1./3.))
        y.append(float(yi))
        z.append(float(log(y[-1])))
        if p == 1:
            m,b = np.polyfit(x,z,1)
            low_err = y[-1]
            high_dof = x[-1]
    ax[1,0].plot(x,y,label=labels[p],color='black',linestyle=linestyles[p], marker='o', markersize =1)

l = ax[1,0].legend(loc=0, prop={'size':3},handlelength=5)
#l.get_frame().set_linewidth(5)

l.get_frame().set_edgecolor('black')
ax[1,0].set_yscale('log')
ax[1,0].tick_params(axis='both', which='both', labelsize=8)
ax[1,0].set_title(axes_labels[row_y],fontsize=8)
ax[1,0].set_xlabel(axes_labels[row_x],fontsize=8)
ax[1,0].grid()

dof = []
dof_1o3 = []
avg_deg = []
linfty = []
l2 = []
energy = []
estimator = []
quad = []
i = 0
with open(file3, 'r',encoding='ascii') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        if i != 0 and i != 1:
            dof.append(float(row[1]))
            quad.append(float(row[0]))
            avg_deg.append((pow(dof[-1]/quad[-1],1./3.) - 1))
            l2.append(float(row[3]))
            dof_1o3.append(pow(dof[-1], 1./3.))
            linfty.append(float(row[4]))
            energy.append(float(row[5]))
            estimator.append(float(row[6]))
        i = i + 1

print(dof)
print(quad)
print(avg_deg)
print(l2)

ax[1,1].plot(dof_1o3,avg_deg,color='black',linestyle='-', marker='o', markersize =1)
ax[1,1].tick_params(axis='both', which='both', labelsize=8)
ax[1,1].set_title("average deg",fontsize=8)
ax[1,1].set_xlabel(r"DOF^{1/3}",fontsize=8)
ax[1,1].grid()

ax[2,0].plot(dof_1o3,linfty,label=r'l_\infty',color='black',linestyle='-', marker='o', markersize =1)
ax[2,0].plot(dof_1o3,l2,label=r'l_2',color='black',linestyle=':', marker='o', markersize =1)
ax[2,0].tick_params(axis='both', which='both', labelsize=8)
ax[2,0].set_xlabel(r"DOF^{1/3}",fontsize=8)
ax[2,0].grid()
ax[2,0].legend(loc=0, prop={'size':5})
ax[2,0].set_yscale('log')

ax[2,1].plot(dof_1o3,energy,label=r'energy',color='black',linestyle='-', marker='o', markersize =1)
ax[2,1].plot(dof_1o3,estimator,label=r'eta',color='black',linestyle=':', marker='o', markersize =1)
ax[2,1].tick_params(axis='both', which='both', labelsize=8)
ax[2,1].set_xlabel(r"DOF^{1/3}",fontsize=8)
ax[2,1].grid()
l = ax[2,1].legend(loc=0, prop={'size':5})

ax[2,1].set_yscale('log')

fig.subplots_adjust(wspace=0.4,hspace=.8)#, hspace=None)
fig.savefig("figs.pdf",rasterizes=False)
#fig.tight_layout() 
