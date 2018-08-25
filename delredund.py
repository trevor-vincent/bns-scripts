#!/usr/bin/python

import os, sys, re, h5py

slist = ["NuFCons_nua", "NuFCons_nue", "NuFCons_nux", "NuECons_nua", "NuECons_nue", "NuECons_nux", "NuNCons_nua", "NuNCons_nue", "NuNCons_nux", "NuXi_nua", "NuXi_nue", "NuXi_nux", "ScatFrac_nua", "ScatFrac_nue", "ScatFrac_nux"]

files = [f for f in os.listdir('.') if re.match(r'Cp-Vars_Interval', f)]

for file in files:
   print "Deleting slist in %s" % file
   h = h5py.File(file,'a')
   for s in slist:
      #print s
      try:
         h.__delitem__(s)
      except:
         print "Error deleting in %s" % file
      
