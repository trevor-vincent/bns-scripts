import matplotlib.pyplot as plt
import matplotlib
import csv
import numpy as np
from math import *
import os
import io
import sys
#%matplotlib inline

#plt.rc('text', usetex=True)
plt.rc('font', family='serif')

file = sys.argv[1]
rows = []

bmin = float(sys.argv[2])
bmax = float(sys.argv[3])
nb = int(sys.argv[4])
    
if len(sys.argv) != 7:
    print("<>.py file bmin bmax nb log/nolog=1/0")
    exit

spacing = float((bmax - bmin)/nb)
                                  
with io.open(file, mode='r', encoding='utf-8') as f:
    reader = csv.reader(f, delimiter=' ')
    for row in reader:
        #print(row)
        rows.append(row)
        #time.append(float(row[0]))

#print("DONE")
#print(rows[-1])
#f1 = plt.figure(1)

y = []
for i in rows[-1]:
    if str(i) != "":
        y.append(float(i))
    
y.pop(0)
x = []
xticks = []
for i in range(0,nb):
    x.append(bmin + spacing*i - spacing/2)

print(spacing)
print(bmin)
print(bmax)
print(nb)
 #   if i % 4 == 0:
  #      xticks.append(x[-1] - spacing/2)
#print(x)
#print(y)
#print(binss)
#print(len(binss))
#plt.hist([x,y])
mpl_fig = plt.figure()
ax = mpl_fig.add_subplot(111)

if int(sys.argv[5]) == 1:
    ax.set_yscale('log')

ax.bar(x, y, align='center', alpha=0.5,width=-spacing)
#ax.set_xticks(xticks)
ax.tick_params(axis = 'both', which = 'major', labelsize = 10)
ax.tick_params(axis = 'both', which = 'minor', labelsize = 10)
ax.locator_params(axis='x', nbins=20)
plt.xlabel(sys.argv[6],fontsize=15)
plt.ylabel(r'UnboundRhoH',fontsize=15)
plt.savefig(str(sys.argv[1] + ".pdf"),rasterized=False)
