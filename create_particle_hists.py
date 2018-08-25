import matplotlib
matplotlib.use('pdf')
import matplotlib.pyplot as plt

import csv
import numpy as np
from math import *
import os
import io

plt.rc('text', usetex=False)
plt.rc('font', family='serif')

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
time = []
m = []
x = []
y = []
z =[]
Rho = []
Ye = []
Temp = []
Minusu_t = []
Minusu_tH = []
v_x = []
v_y = []
v_z = []
v_mag = []
unb_E = []
v_inf = []

with io.open(file, mode='r', encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        Minusu_tH.append(float(row[9]))
        if Minusu_tH[-1] > 1.:
            time.append(float(row[0]))
            m.append(float(row[1]))
            x.append(float(row[2]))
            y.append(float(row[3]))
            z.append(float(row[4]))
            Rho.append(float(row[5]))
            Ye.append(float(row[6]))
            Temp.append(float(row[7]))
            Minusu_t.append(float(row[8]))
            unb_E.append(Rho[-1]*(Minusu_tH[-1] - 1))
            A = unb_E[-1]
            B = Rho[-1]
            v_inf.append(sqrt(1-1/(1+A/B)/(1+A/B)))
            v_x.append(float(row[10]))
            v_y.append(float(row[11]))
            v_z.append(float(row[12]))
            v_mag.append(sqrt(v_x[-1]**2 + v_y[-1]**2 + v_z[-1]**2))
        
                
f1 = plt.figure(1)
plt.hist(Ye, bins=30)
plt.xlabel(r'Ye',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('Ye_hist.pdf',rasterized=False)

f2 = plt.figure(2)
plt.hist(Temp, bins=30)
plt.xlabel(r'Temp',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('Temp_hist.pdf',rasterized=False)

f3 = plt.figure(3)
plt.hist(Rho, bins=30)
plt.xlabel(r'Rho',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('Rho_hist.pdf',rasterized=False)

f4 = plt.figure(4)
plt.hist(Minusu_t, bins=30)
plt.xlabel(r'$-u_t$',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('Minusu_t_hist.pdf',rasterized=False)

f5 = plt.figure(5)
plt.hist(v_mag, bins=30)
plt.xlabel(r'$|v_{inertial}|$',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('v_mag_hist.pdf',rasterized=False)

f6 = plt.figure(6)
plt.hist(x, bins=30)
plt.xlabel(r'x',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('x_hist.pdf',rasterized=False)

f7 = plt.figure(7)
plt.hist(y, bins=30)
plt.xlabel(r'y',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('y_hist.pdf',rasterized=False)

f8 = plt.figure(8)
plt.hist(z, bins=30)
plt.xlabel(r'z',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('z_hist.pdf',rasterized=False)

f9 = plt.figure(9)
plt.hist(v_x, bins=30)
plt.xlabel(r'$v_x$',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('v_x_hist.pdf',rasterized=False)

f10 = plt.figure(10)
plt.hist(v_y, bins=30)
plt.xlabel(r'$v_y$',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('v_y_hist.pdf',rasterized=False)

f11 = plt.figure(11)
plt.hist(v_z, bins=30)
plt.xlabel(r'$v_z$',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('v_z_hist.pdf',rasterized=False)

f12 = plt.figure(12)
plt.hist(Minusu_tH, bins=30)
plt.xlabel(r'$-u_{tH}$',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
plt.savefig('Minus_uth_hist.pdf',rasterized=False)

f13 = plt.figure(13)
ax = f13.add_subplot(111)
plt.hist(v_inf, bins=30)
plt.xlabel(r'$v_\infty$',fontsize=15)
plt.ylabel(r'Number of Ejected Particles',fontsize=15)
ax.set_yscale('log')
plt.savefig('vInf.pdf',rasterized=False)
