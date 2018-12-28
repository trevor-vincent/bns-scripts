#!/usr/bin/python

import matplotlib
from matplotlib import ticker
import numpy as np
import matplotlib.pyplot as plt
import pylab as py
import os
import sys
from math import *
import math

import matplotlib.lines as mlines

def abline(slope, intercept):
    """Plot a line from slope and intercept"""
    axes = plt.gca()
    x_vals = np.array(axes.get_xlim())
    y_vals = intercept + slope * x_vals
    plt.plot(x_vals, y_vals, '--', color='white')

def newline(p1, p2):
    ax = plt.gca()
    xmin, xmax = ax.get_xbound()

    if(p2[0] == p1[0]):
        xmin = xmax = p1[0]
        ymin, ymax = ax.get_ybound()
    else:
        ymax = p1[1]+(p2[1]-p1[1])/(p2[0]-p1[0])*(xmax-p1[0])
        ymin = p1[1]+(p2[1]-p1[1])/(p2[0]-p1[0])*(xmin-p1[0])

    l = mlines.Line2D([xmin,xmax], [ymin,ymax])
    ax.add_line(l)
    return l


pgf_with_rc_fonts = {"pgf.texsystem": "pdflatex"}
matplotlib.rcParams.update(pgf_with_rc_fonts)


from pylab import zeros,log10,linspace
from pylab import figure,clf,rcParams,FixedLocator,subplot,contourf,contour,axis

# File options
filedir = "./"
outputdir = filedir
filepath = filedir+str(sys.argv[1])
filepath2 = filedir+str(sys.argv[2])
filepath3 = filedir+str(sys.argv[3])
SkipToStep = 0
FilePrefix = str(sys.argv[1])
Fscale = 1.
F0 = 0
colouraxis = zeros([100])
for i in range(0, 100):
    colouraxis[i] = 0 + i*0.5/99.
#LegendTag = [0,10,20,30,40,50,60,70,80]
LegendTag = [0,0.1,0.2,0.3,0.4,0.5]
LegendName = "Ye"
#LegendName = "$Y_e$"
cmapname = 'RdBu'
useLog = 0

# Plotting options
XMin = -220.
XMax = 220
YMin = -220
YMax = 220
bgcolor = 'black'

RMAX = (XMax - XMin)**2 + (YMax - YMin)**2
#THETA = float(sys.argv[5])


                                  
# Function calibrated for SliceData in SpEC                                                                                                                                   
def GetSliceDims(filename):
    f = open(filename,'r')
    Nx = 0
    Ny = 0
    ReadHeader = 0
    while True:
        line = f.readline()
        #print(line[0])
        if line[0]=='#':
            if ReadHeader > 0:
                Ny = Ny+1
                break
            ReadHeader = 1
        else:
            str_input = line.split()
            if len(str_input)==4:
                Nx = Nx+1
            else:
                Ny = Ny+1
                Nx = 0
    f.close()
    f = open(filename,'r')
    Nt = 0
    Nc = 0
    for line in f:
        Nc = Nc+1
        if Nc == (Nx+1)*Ny :
            Nc = 0
            Nt = Nt+1
    return [Nt,Nx,Ny]

def GetNextSlice(f,Nx,Ny):
    mOutput = zeros([Ny,Nx,4])
    line = f.readline()
    try: 
        while line[0]=='#':
            line = f.readline()
    except:
        return mOutput,-1
    for j in range(0,Ny):
        for i in range(0,Nx):
            str_input = line.split()
            if len(str_input)!=4:
                print("Bad format in GetNextSlice",line,j,i)
                break
            else:
                for k in range(0,4):
                    mOutput[j,i,k] = float(str_input[k])
            line = f.readline()
        # SpEC skips one line when indexing non-leading index
        if j<Ny-1:
            line = f.readline()
    if(len(line)>0):
        str_input = line.split()
        NextTime = float(str_input[1])
    else:
        NextTime = -1.
    return mOutput,NextTime


print("Get file dimensions")
Nt,Nx,Ny = GetSliceDims(filepath)
print(Nt,Nx,Ny)
