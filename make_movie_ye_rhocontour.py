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

if str(sys.argv[4]) == "xz":
    Nx = 201
    Ny = 101
elif str(sys.argv[4]) == "xy":    
    Nx = 201
    Ny = 201
elif str(sys.argv[4]) == "yz":
    Nx = 201
    Ny = 101
else:
    print("only xz,yz,xy slices")

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

##rcParams['figure.figsize']  = 12, 12
#rcParams['lines.linewidth'] = 1.5
#rcParams['font.family']     = 'serif'
#rcParams['font.weight']     = 'bold'
rcParams['font.size']       = 30
#rcParams['font.sans-serif'] = 'serif'
##rcParams['text.usetex']     = True
#rcParams['axes.linewidth']  = 1.5
#rcParams['axes.titlesize']  = 'medium'
#rcParams['axes.labelsize']  = 'medium'
#rcParams['xtick.major.size'] = 8
#rcParams['xtick.minor.size'] = 4
#rcParams['xtick.major.pad']  = 8
#rcParams['xtick.minor.pad']  = 8
#rcParams['xtick.color']      = bgcolor
rcParams['xtick.labelsize']  = 'medium'
#rcParams['xtick.direction']  = 'in'
#rcParams['ytick.major.size'] = 8
#rcParams['ytick.minor.size'] = 4
#rcParams['ytick.major.pad']  = 8
#rcParams['ytick.minor.pad']  = 8
#rcParams['ytick.color']      = bgcolor
rcParams['ytick.labelsize']  = 'medium'
#rcParams['ytick.direction']  = 'in'
#rcParams['axes.linewidth'] = 3

f = open(filepath,'r')
#line = f.readline()
#str_input = line.split()
f2 = open(filepath2,'r')
line = f2.readline()
str_input = line.split()
f3 = open(filepath3,'r')
line = f3.readline()
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

    if str(sys.argv[4]) == "xz":
        X = mData[:,:,0]*1.475
        Y = mData[:,:,2]*1.475
    elif str(sys.argv[4]) == "xy":    
        X = mData[:,:,0]*1.475
        Y = mData[:,:,1]*1.475
    elif str(sys.argv[4]) == "yz":
        X = mData[:,:,1]*1.475
        Y = mData[:,:,2]*1.475        
    else:
        print("only xz and xy slices supported")
        exit

    F = mData[:,:,3]*Fscale
    F2 = mData2[:,:,3]*Fscale
    F3 = mData3[:,:,3]*Fscale
    #print((F))
    #print((X))
    #print((Y))
    fig, axes = plt.subplots(nrows=1, ncols=1)
    fig.set_size_inches((24,12))
    sp=subplot(111)
    if useLog == 1:
        im2 = contourf(X, Y, log10(F+F0), colouraxis,cmap=cmapname)
    else:
        im2 = contourf(X, Y, F+F0, colouraxis,cmap=cmapname)

    im3 = contour(X,Y,F2,6,linewidths=5,locator=ticker.LogLocator())
    contour(X,Y,F3,1,colors='black',linewidths=5)
    plt.xlabel("$X [km]$",fontsize=20,color=bgcolor)
    plt.ylabel("$Y [km]$",fontsize=20,color=bgcolor)
    dt = 2.*t*0.00496
    ax = plt.gca()
    axis([XMin, XMax, YMin, YMax])
    cbar2 = fig.colorbar(im2, ticks=LegendTag)
    cbar3 = fig.colorbar(im3,drawedges=False)#, orientation="horizontal")
    outputname = outputdir+"/"+FilePrefix+"%04d"%t+".jpg"
    cbar3.ax.tick_params(labelsize=15) 
    cbar2.ax.tick_params(labelsize=15) 
    cbar3.outline.set_visible(False)
    cbar3.set_label('Rho', labelpad=-20, y=1.075, rotation=0)
    cbar2.set_label('Ye', labelpad=-20, y=1.075, rotation=0)
    plt.savefig(outputname)
    plt.close(fig)

cmd = "ffmpeg -f image2 -i "+outputdir+FilePrefix+"%04d.jpg -vf scale=720:720 -framerate 20 "+outputdir+FilePrefix+".mpg"
os.system(cmd)
