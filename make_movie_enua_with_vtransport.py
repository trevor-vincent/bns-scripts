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

if len(sys.argv) != 9:
    print("make_movie... E Fx Fy A Bx By <xz/xy> theta")
    sys.exit(0)

pgf_with_rc_fonts = {"pgf.texsystem": "pdflatex"}
matplotlib.rcParams.update(pgf_with_rc_fonts)

from pylab import zeros,log10,linspace
from pylab import figure,clf,rcParams,FixedLocator,subplot,contourf,contour,axis

# File options
FilePrefix = "ENu"
filedir = "./"
outputdir = filedir
filepath1 = filedir+str(sys.argv[1])
filepath2 = filedir+str(sys.argv[2])
filepath3 = filedir+str(sys.argv[3])
filepath4 = filedir+str(sys.argv[4])
filepath5 = filedir+str(sys.argv[5])
filepath6 = filedir+str(sys.argv[6])
SkipToStep = 0
Fscale = 1.
E0 = 1e-70
colouraxis = zeros([100])
for i in range(0, 100):
    colouraxis[i] = -13 + i*7/99.

LegendTag = [-20,-18,-16,-14,-12,-10,-8,-6,-4,-2,0,2,4,6,8,10,12,14]
#LegendTag = [0,0.1,0.2,0.3,0.4,0.5]
LegendName = "$\\log_{10}(E)$"

#LegendName = "$Y_e$"
cmapname = 'inferno'
useLog = 1

# Plotting options
XMin = -220.
XMax = 220
YMin = -220
YMax = 220
bgcolor = 'black'

RMAX = (XMax - XMin)**2 + (YMax - YMin)**2
THETA = float(sys.argv[8])
                                  
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
Nt,Nx,Ny = GetSliceDims(filepath1)
print(Nt,Nx,Ny)

# Plotting...
figure(figsize=(12,24))
clf()
# Set plot parameters to make beautiful plots
minorLocatorX   = FixedLocator(linspace(XMin,XMax,21))
minorLocatorY   = FixedLocator(linspace(YMin,YMax,21))
majorLocatorX   = FixedLocator(linspace(XMin,XMax,5))
majorLocatorY   = FixedLocator(linspace(XMin,XMax,5))
dX = (XMax-XMin)/4.
Xlab = ["%.0f"%XMin,"%.0f"%(XMin+dX),"%.0f"%(XMin+2*dX),"%.0f"%(XMin+3*dX),"%.0f"%XMax]
dY = (YMax-YMin)/4.
Ylab = ["%.0f"%YMin,"%.0f"%(YMin+dY),"%.0f"%(YMin+2*dY),"%.0f"%(YMin+3*dY),"%.0f"%YMax]
rcParams['xtick.labelsize']  = 'medium'
rcParams['ytick.labelsize']  = 'medium'

f = open(filepath1,'r')
f2 = open(filepath2,'r')
line = f2.readline()
str_input = line.split()
f3 = open(filepath3,'r')
line = f3.readline()
str_input = line.split()
f4 = open(filepath4,'r')
line = f4.readline()
str_input = line.split()
f5 = open(filepath5,'r')
line = f5.readline()
str_input = line.split()
f6 = open(filepath6,'r')
line = f6.readline()
str_input = line.split()

if SkipToStep>0:
    Nskip = SkipToStep*(Nx+1)*Ny
    Buff = [next(f) for x in range(Nskip)]

line = f.readline()
str_input = line.split()
NextTime = float(str_input[1])
for t in range(SkipToStep,Nt-1):

    LastTime = NextTime
    print("Stamp ",t," at time ",LastTime)
    mData,NextTime = GetNextSlice(f,Nx,Ny)
    skipping = 0
    while(NextTime <= LastTime):
        print("Skipping stamp ",t," at time ",NextTime)
        if NextTime==-1:
            break
        mDummy,NextTime = GetNextSlice(f,Nx,Ny)       
        t = t+1
        skipping = 1

    if NextTime == -1:
        break

    if skipping == 1:
        continue

    mData2,dummyTime = GetNextSlice(f2,Nx,Ny)
    while(NextTime <= LastTime and NextTime >= 0.):
        mDummy,NextTime = GetNextSlice(f,Nx,Ny)

    mData3,dummyTime = GetNextSlice(f3,Nx,Ny)
    while(NextTime <= LastTime and NextTime >= 0.):
        mDummy,NextTime = GetNextSlice(f,Nx,Ny)

    mData4,dummyTime = GetNextSlice(f4,Nx,Ny)
    while(NextTime <= LastTime and NextTime >= 0.):
        mDummy,NextTime = GetNextSlice(f,Nx,Ny)

    mData5,dummyTime = GetNextSlice(f5,Nx,Ny)
    while(NextTime <= LastTime and NextTime >= 0.):
        mDummy,NextTime = GetNextSlice(f,Nx,Ny)

    mData6,dummyTime = GetNextSlice(f6,Nx,Ny)
    while(NextTime <= LastTime and NextTime >= 0.):
        mDummy,NextTime = GetNextSlice(f,Nx,Ny)

    X = mData[:,:,0]*1.475
    Y = []

    if str(sys.argv[7]) == "xz":
        Y = mData[:,:,2]*1.475
    elif str(sys.argv[7]) == "xy":    
        Y = mData[:,:,1]*1.475
    else:
        print("only xz and xy slices supported")
        exit

    E = mData[:,:,3]*Fscale
    Fx = mData2[:,:,3]*Fscale
    Fy = mData3[:,:,3]*Fscale
    a = mData4[:,:,3]*Fscale #lapse
    Bx = mData5[:,:,3]*Fscale #shiftx
    By = mData6[:,:,3]*Fscale #shifty
    vx = a[:,:]*Fx[:,:]/(E[:,:]+E0)-Bx[:,:]
    vy = a[:,:]*Fy[:,:]/(E[:,:]+E0)-By[:,:]
    # for i in range(0,len(a)):
    #     print(E[i,i])
    #     vxi = a[i]*Fx[i]/(E[i]+E0) - Bx[i]
    #     vyi = a[i]*Fy[i]/(E[i]+E0) - By[i]
    #     #print(vxi, vyi)
    #     vx.append(vxi)
    #     vy.append(vyi)
    fig, axes = plt.subplots(nrows=1, ncols=1)
    fig.set_size_inches((24,12))
    sp=subplot(111)
    im2 = contourf(X, Y, log10(E+E0), colouraxis,cmap=cmapname)

    skip=(slice(None,None,4),slice(None,None,4))
    im3 = plt.quiver(X[skip], Y[skip], vx[skip], vy[skip], color='black', headwidth=3)# scale = 1)# headlength=2)

#    im3 = plt.quiver(X,Y,vx,vy,linewidths=20)
    plt.xlabel("$X [km]$",fontsize=20,color=bgcolor)
    plt.ylabel("$Y [km]$",fontsize=20,color=bgcolor)

    dt = 2.*t*0.00496
    ax = plt.gca()

    axis([XMin, XMax, YMin, YMax])

    cbar2 = fig.colorbar(im2, ticks=LegendTag)
    outputname = outputdir+"/"+FilePrefix+"%04d"%t+".jpg"
    cbar2.ax.tick_params(labelsize=15) 
    cbar2.set_label('E', labelpad=-20, y=1.075, rotation=0)
    plt.savefig(outputname)
    plt.close(fig)

cmd = "ffmpeg -f image2 -i "+outputdir+FilePrefix+"%04d.jpg -vf scale=720:720 -framerate 20 "+outputdir+FilePrefix+".mpg"
os.system(cmd)
