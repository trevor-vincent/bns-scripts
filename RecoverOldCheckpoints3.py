#! /usr/bin/env python
import h5py

##this is an EXPERIMENT on how so run BNS simulations. The easy way is to recover
##old checkpoint files from the SerialCheckpoint and start from those files 
##At the moment you have to do this by hand, later this should be done automatically
##notice: Some things here are hardcoded so that it runs, this is not nice, but works
##notice: You also have to change: /InputFiles/NsNs/DoMultipleRunsMerger.input 
##        renaming $StartTime to $CpTime 
## good luck!

fh = h5py.File('SerialCheckpoint.h5', "r")
#f1 = 
print(fh)

for group in fh:
  #print(group)
  outfh = open(group,'w')
  name = str(group)
  if name == 'Cp-FuncRegridScaleL.txt' or name == 'Cp-FuncRegridScaleR.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time': 
          tistr='%s' %fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'Tsaved':
          tsstr=fh[group][dset][0]
        if string == 'Nc':
          Ncstr=fh[group][dset][0]
        if string == 'DerivOrder':
          DOstr=fh[group][dset][0]
        if string == 'phi[0]':
          axstr=fh[group][dset][0]
          aystr=fh[group][dset][1]
          azstr=fh[group][dset][2]
    outfh.write('Time=  %s; Version=%s;Tsaved=  %s;Nc=%s;DerivOrder=%s;ax=  %s;ay=  %s;az=  %s; \n' %(tistr,vstr,tsstr,Ncstr,DOstr,axstr,aystr,azstr))
  elif name == 'Cp-FuncRegridShiftL.txt' or name == 'Cp-FuncRegridShiftR.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'Tsaved':
          tsstr=fh[group][dset][0]
        if string == 'Nc':
          Ncstr=fh[group][dset][0]
        if string == 'DerivOrder':
          DOstr=fh[group][dset][0]
        if string == 'phi[0]':
          axstr=fh[group][dset][0]
          aystr=fh[group][dset][1]
          azstr=fh[group][dset][2]
    outfh.write('Time=  %s; Version=%s;Tsaved=  %s;Nc=%s;DerivOrder=%s;ax=  %s;ay=  %s;az=  %s;\n' %(tistr,vstr,tsstr,Ncstr,DOstr,axstr,aystr,azstr))
  elif name == 'Cp-AvgExpansionFactor.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Tsaved':
          tsstr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'InitState':
          ISstr=fh[group][dset][0]
        if string == 'ScalarAvgData':
          s1str=fh[group][dset][0]
          s2str=fh[group][dset][1]
        if string == 'RawQ.size':
          mrsstr=fh[group][dset][0]
        if string == 'RawQ[0]':
          mrstr=fh[group][dset][0]
        if string == 'IntData':
          IDstr=fh[group][dset][0]
        if string == 'DerivOrder':
          DOstr=fh[group][dset][0]
        if string == 'AvgData[0]':
          a1str=fh[group][dset][0]
        if string == 'AvgData[1]':
          a2str=fh[group][dset][0]
        if string == 'AvgData[2]':
          a3str=fh[group][dset][0]
    outfh.write('Time = %s; ClassID=Exp;InitState=%s;CheckpointFileVersion=%s;NumComponentsQ=%s;Tsaved=  %s;Scalars=  %s,  %s;mRawQ[0][0]= %s;mAvgData[0][0]= %s;mAvgData[1][0]= %s;mAvgData[2][0]=  %s;mIntData[0]= %s;\n' %(tistr,ISstr,vstr,mrsstr,tsstr,s1str,s2str,mrstr,a1str,a2str,a3str,IDstr))
  elif name == 'Cp-AvgPitchAndYawAngles.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        #print(string)
        string2 = fh[group][dset][:]
        #print(string2)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'ScalarAvgData':
          s1str=fh[group][dset][0]
          s2str=fh[group][dset][1]
        if string == 'RawQ[0]':
          mr1str=fh[group][dset][0]
          mr2str=fh[group][dset][1]
        if string == 'IntData':
          ID1str=fh[group][dset][0]
          ID2str=fh[group][dset][1]
        if string == 'AvgData[0]':
          a11str=fh[group][dset][0]
          a12str=fh[group][dset][1]
        if string == 'AvgData[1]':
          a21str=fh[group][dset][0]
          a22str=fh[group][dset][1]
        if string == 'AvgData[2]':
          a31str=fh[group][dset][0]
          a32str=fh[group][dset][1]
        if string == 'InitState':
          Isstr=fh[group][dset][0]
        if string == 'Tsaved':
          tsstr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0] 
          vstr='0'
        if string == 'RawQ.size':
          mrsstr=fh[group][dset][0]
          mrsstr='2'
    outfh.write('Time=  %s;ClassID=Exp;InitState=%s;CheckpointFileVersion=%s;NumComponentsQ=%s;Tsaved=  %s;Scalars=  %s,  %s;mRawQ[0][0]= %s;mRawQ[0][1]=  %s;mAvgData[0][0]=  %s;mAvgData[0][1]=  %s;mAvgData[1][0]=  %s;mAvgData[1][1]=  %s;mAvgData[2][0]=  %s;mAvgData[2][1]= %s;mIntData[0]=  %s;mIntData[1]=  %s;\n' %(tistr,Isstr,vstr,mrsstr,tsstr,s1str,s2str,mr1str,mr2str,a11str,a12str,a21str,a22str,a31str,a32str,ID1str,ID2str))
  elif name == 'Cp-AvgTranslation.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        string2 = fh[group][dset][:]
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'ScalarAvgData':
          s1str=fh[group][dset][0]
          s2str=fh[group][dset][1]
        if string == 'RawQ[0]':
          mr1str=fh[group][dset][0]
          mr2str=fh[group][dset][1]
          mr3str=fh[group][dset][2]
        if string == 'IntData':
          ID1str=fh[group][dset][0]
          ID2str=fh[group][dset][1]
          ID3str=fh[group][dset][1]
        if string == 'AvgData[0]':
          a11str=fh[group][dset][0]
          a12str=fh[group][dset][1]
          a13str=fh[group][dset][1]
        if string == 'AvgData[1]':
          a21str=fh[group][dset][0]
          a22str=fh[group][dset][1]
          a23str=fh[group][dset][1]
        if string == 'AvgData[2]':
          a31str=fh[group][dset][0]
          a32str=fh[group][dset][1]
          a33str=fh[group][dset][2]
        if string == 'InitState':
          Isstr=fh[group][dset][0]
        if string == 'Tsaved':
          tsstr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'RawQ.size':
          mrsstr=fh[group][dset][0]
          mrsstr='3'
    outfh.write('Time=  %s;ClassID=Exp;InitState=%s;CheckpointFileVersion=%s;NumComponentsQ=%s;Tsaved=  %s;Scalars=  %s,  %s;mRawQ[0][0]= %s;mRawQ[0][1]=  %s; mRawQ[0][2]=  %s;mAvgData[0][0]=  %s;mAvgData[0][1]=  %s;mAvgData[0][2]=  %s;mAvgData[1][0]=  %s;mAvgData[1][1]=  %s;mAvgData[1][2]=  %s;mAvgData[2][0]=  %s;mAvgData[2][1]= %s;mAvgData[2][2]=  %s;mIntData[0]=  %s;mIntData[1]=  %s;mIntData[2]=  %s;\n' %(tistr,Isstr,vstr,mrsstr,tsstr,s1str,s2str,mr1str,mr2str,mr3str,a11str,a12str,a13str,a21str,a22str,a23str,a31str,a32str,a33str,ID1str,ID2str,ID3str))
  elif name == 'Cp-CpuUsage.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'CpuHoursTotal':
          totstr=fh[group][dset][0]
        if string == 'CpuHoursStartup':
          sustr=fh[group][dset][0]
        if string == 'CpuHoursFirstStep':
          fsstr=fh[group][dset][0]
    outfh.write('%s    %s    %s    %s;\n' %(tistr,totstr,sustr,fsstr))
  elif name == 'Cp-FuncExpansionFactor.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'DerivOrder':
          DOstr=fh[group][dset][0]
        if string == 'Tsaves':
          tsstr=fh[group][dset][0]
        if string == 'phi[0]':
          a1str=fh[group][dset][0]
        if string == 'phi[1]':
          a2str=fh[group][dset][0]
        if string == 'phi[2]':
          a3str=fh[group][dset][0]
        if string == 'Nc':
          Ncstr=fh[group][dset][0]
    outfh.write('Time=  %s;Version=%s;Tsaved=  %s;Nc=%s;DerivOrder=%s;a=  %s;da= %s;d2a= %s;\n' %(tistr, vstr, tsstr, Ncstr, DOstr, a1str, a2str, a3str))
  elif name == 'Cp-TdampExpansion.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]    
          vstr='0'    
        if string == 'Timescale':
          tsstr=fh[group][dset][0]
    outfh.write('Time=  %s;ClassID=Simple;CheckpointFileVersion=%s;Timescale=(  %s);\n' %(tistr,vstr,tsstr))
  elif name == 'Cp-TdampQuatRotMatrix.txt':
    print('read file')
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'Timescale':
          t1str=fh[group][dset][0]
          t2str=fh[group][dset][1]
    outfh.write('Time=  %s;ClassID=Simple;CheckpointFileVersion=%s;Timescale=(  %s,  %s);\n' %(tistr,vstr,t1str,t2str))
  elif name == 'Cp-TdampTrans.txt':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
        if string == 'Timescale':
          t1str=fh[group][dset][0]
          t2str=fh[group][dset][1]
          t3str=fh[group][dset][2]
    outfh.write('Time=  %s;ClassID=Simple;CheckpointFileVersion=%s;Timescale=(  %s,  %s,  %s);\n' %(tistr,vstr,t1str,t2str,t3str))
  elif name == 'Cp-TerminateCommonHorizon.txt':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'CheckpointVersion':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'NumSuccesses':
          nsstr=fh[group][dset][0]
    outfh.write('Time=  %s;CheckpointVersion=%s;NumSuccesses=%s;\n' %(tistr,vstr,nsstr))
  elif name == 'Cp-TimeInfoFile.txt':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'CpuhAtRestart':
          crstr=fh[group][dset][0]
        if string == 'WallClockAtRestart':
          wcstr=fh[group][dset][0]
        if string == 'StartTime':
          ststr=fh[group][dset][0]
    outfh.write('Time=  %s;Version=%s;CpuhAtRestart=  %s;WallClockhAtRestart=  %s;FilesizeAtRestart=  0.;StartTime=  %s;\n' %(tistr,vstr,crstr,wcstr,ststr))
  elif name == 'Cp-FuncTranslation.txt':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'Tsaved':
          tsstr=fh[group][dset][0]
        if string == 'Nc':
          Ncstr=fh[group][dset][0]
        if string == 'DerivOrder':
          DOstr=fh[group][dset][0]
        if string == 'phi[0]':
          Txstr=fh[group][dset][0]
          Tystr=fh[group][dset][1]
          Tzstr=fh[group][dset][2]
        if string == 'phi[1]':
          T1xstr=fh[group][dset][0]
          T1ystr=fh[group][dset][1]
          T1zstr=fh[group][dset][2]
        if string == 'phi[2]':
          T2xstr=fh[group][dset][0]
          T2ystr=fh[group][dset][1]
          T2zstr=fh[group][dset][2]
    outfh.write('Time=  %s;Version=%s;Tsaved=  %s;Nc=%s;DerivOrder=%s;Tx= %s;dTx=  %s;d2Tx=  %s;Ty= %s;dTy= %s;d2Ty=  %s;Tz=  %s;dTz=  %s;d2Tz=  %s;\n' %(tistr,vstr,tsstr,Ncstr,DOstr,Txstr,Tystr,Tzstr,T1xstr,T1ystr,T1zstr,T2xstr,T2ystr,T2zstr))
  elif name == 'Cp-TimeStepperPI.dat':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'GoodSteps':
          gsstr=fh[group][dset][0]
        if string == 'FailedSteps':
          fsstr=fh[group][dset][0]
        if string == 'ThisIsTheInitialStep':
          Isstr=fh[group][dset][0]
        if string == 'NextDt':
          Ntstr=fh[group][dset][0]
        if string == 'LastError':
          Lestr=fh[group][dset][0]
    outfh.write('Time=  %s;GoodSteps=%s;FailedSteps=%s;ThisIsTheInitialStep=%s;NextDt=  %s;LastError=  %s;\n' %(tistr,gsstr,fsstr,Isstr,Ntstr,Lestr))
  elif name == 'VerificatorOutflowL.txt' or name == 'VerificatorOutflowR.txt':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'ClassID':
          CIDstr=fh[group][dset][0]
        if string == 'CheckpointFileVersion':
          CFstr=fh[group][dset][0]
        if string == 'LastT':
          LTstr=fh[group][dset][0]
        if string == 'LastObsT':
          LOTstr=fh[group][dset][0]
    outfh.write('Time=  %s;ClassID=%s;CheckpointFileVersion=%s;LastT=%s;LastObsT=  %s;\n' %(tistr,CIDstr,CFstr,LTstr,LOTstr))
  elif name == 'Cp-FuncPitchAndYaw.txt':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'Tsaved':
          Tstr=fh[group][dset][0]
        if string == 'Nc':
          Ncstr=fh[group][dset][0]
        if string == 'DerivOrder':
          DOstr=fh[group][dset][0]
        if string == 'phi[0]':
          Pstr=fh[group][dset][0]
          Ystr=fh[group][dset][1]
        if string == 'phi[1]':
          dPstr=fh[group][dset][0]
          dYstr=fh[group][dset][1]          
        if string == 'phi[2]':
          d2Pstr=fh[group][dset][0]
          d2Ystr=fh[group][dset][1] 
    outfh.write('Time = %s;Version=%s;Tsaved=  %s;Nc=%s;DerivOrder=%s;Pitch=  %s;dPitch=  %s;d2Pitch=  %s;Yaw=  %s;dYaw=  %s;d2Yaw=  %s;\n' %(tistr,vstr,Tstr,Ncstr,DOstr,Pstr,dPstr,d2Pstr,Ystr,dYstr,d2Ystr))
  elif name == 'Cp-FuncRegridSwitch.txt':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Version':
          vstr=fh[group][dset][0]
          vstr='0'
        if string == 'Tsaved':
          Tstr=fh[group][dset][0]
        if string == 'Nc':
          Ncstr=fh[group][dset][0]
        if string == 'DerivOrder':
          DOstr=fh[group][dset][0]
        if string == 'phi[0]':
          Swstr=fh[group][dset][0] 
    outfh.write('Time = %s;Version=%s;Tsaved=  %s;Nc=%s;DerivOrder=%s;Switch= %s;\n' %(tistr,vstr,Tstr,Ncstr,DOstr,Swstr))
  elif name == 'Cp-EvolutionLoop::MaxDeltaT-GrEvolution':
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr=fh[group][dset][0]
        if string == 'Data':
          dstr=fh[group][dset][0]
    outfh.write('  %s      %s\n' %(tistr,dstr))
  elif name == 'Cp-ChangeSpectralGrid.txt':
    MinSizelength=0
    for dset in fh[group]:
        string = str(dset)
        if string == 'Checkpointer::Time':
          tistr='Time = '
          tistr+='%s;' %fh[group][dset][0]
        if string == 'Version':
          vstr='Version='
          #vstr+='%s;' %fh[group][dset][0]
          vstr+='0'
        if string == 'NTotalCalls':
          NTstr='NTotalCalls='    
          NTstr+='%s;' %fh[group][dset][0]
        if string == 'TOfLastGridChange':
          TOLstr='TOfLastGridChange='
          TOLstr+='%s;' %fh[group][dset][0]
        if string == 'SubdomainNames':
          SDstr='SubdomainNames= ('
          length=len(fh[group][dset][:])
          for i in range(0, length-2):
            SDstr+=('%s,' %fh[group][dset][i])
          SDstr+=('%s);' %fh[group][dset][length-1])
        if string == 'NCallOfLastTopChange':
          NLTstr='NCallOfLastTopologyChange= ('
          length=len(fh[group][dset][:])
          for i in range(0, length-2):
            NLTstr+=('%s,' %fh[group][dset][i])
          NLTstr+=('%s);' %fh[group][dset][length-1])
        if (string== 'MinExtents.size'):
          MinSizelength=int(fh[group][dset][0])
          MEstr='MinExtents=('
          for i in range(0, MinSizelength-2):
            cstring =('MinExtents[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                MEstr+='('
                for j in range(0,(length2-1)):
                  MEstr+=('%s, ' %fh[group][dset2][j])
                MEstr+=('%s' %fh[group][dset2][length2-1])
                MEstr+='),'
          MEstr = MEstr[:-1]
          MEstr+=');'
        if (string== 'SuggestedExtents.size'):
          SElength=int(fh[group][dset][0])
          SEstr='SuggestedExtents=('
          for i in range(0, SElength-2):
            cstring =('SuggestedExtents[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                SEstr+='('
                for j in range(0,(length2-1)):
                  SEstr+=('%s, ' %fh[group][dset2][j])
                SEstr+=('%s' %fh[group][dset2][length2-1])
                SEstr+='),'
          SEstr = SEstr[:-1]
          SEstr+=');'
        if (string== 'MaxExtents.size'):
          MAElength=int(fh[group][dset][0])
          MAEstr='MaxExtents=('
          for i in range(0, MAElength-2):
            cstring =('MaxExtents[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                MAEstr+='('
                for j in range(0,(length2-1)):
                  MAEstr+=('%s,' %fh[group][dset2][j])
                MAEstr+=('%s' %fh[group][dset2][length2-1])
                MAEstr+='),'
          MAEstr = MAEstr[:-1]
          MAEstr+=');'
        if (string== 'NCallOfLastExtentChange.size'):
          NLElength=int(fh[group][dset][0])
          NLEstr='NCallOfLastExtentChange=('
          for i in range(0, NLElength-2):
            cstring =('NCallOfLastExtentChange[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                NLEstr+='('
                for j in range(0,(length2-1)):
                  NLEstr+=('%s,' %fh[group][dset2][j])
                NLEstr+=('%s' %fh[group][dset2][length2-1])
                NLEstr+='),'
          NLEstr = NLEstr[:-1]
          NLEstr+=');'
        if (string== 'NCallOfLastFilterChange.size'):
          NLFlength=int(fh[group][dset][0])
          NLFstr='NCallOfLastFilterChange=('
          for i in range(0, NLFlength-2):
            cstring =('NCallOfLastFilterChange[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                NLFstr+='('
                for j in range(0,(length2-1)):
                  NLFstr+=('%s,' %fh[group][dset2][j])
                NLFstr+=('%s' %fh[group][dset2][length2-1])
                NLFstr+='),'
          NLFstr = NLFstr[:-1]
          NLFstr+=');'
        if (string== 'Log10TruncErrorShift.size'):
          LTElength=int(fh[group][dset][0])
          LTEstr='Log10TruncErrorShift=('
          for i in range(0, LTElength-2):
            cstring =('Log10TruncErrorShift[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                LTEstr+='('
                for j in range(0,(length2-1)):
                  LTEstr+=('%s,' %fh[group][dset2][j])
                LTEstr+=('%s' %fh[group][dset2][length2-1])
                LTEstr+='),'
          LTEstr = LTEstr[:-1]
          LTEstr+=');'
        if (string== 'DoNotChangeBeforeTime.size'):
          NCTlength=int(fh[group][dset][0])
          NCTstr='DoNotChangeSubdomainBeforeTime=('
          for i in range(0, NCTlength-2):
            cstring =('DoNotChangeBeforeTime[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                NCTstr+='('
                for j in range(0,(length2-1)):
                  NCTstr+=('%s,' %fh[group][dset2][j])
                NCTstr+=('%s' %fh[group][dset2][length2-1])
                NCTstr+='),'
          NCTstr = NCTstr[:-1]
          NCTstr+=');'      
        if (string== 'PrevNormOfTopError.size'):
          PNTlength=int(fh[group][dset][0])
          PNTstr='PrevNormOfTopError=('
          for i in range(0, PNTlength-2):
            cstring =('PrevNormOfTopError[%s]' %i)
            for dset2 in fh[group]:
              string2=str(dset2)
              if string2==cstring:
                length2=len(fh[group][dset2][:])
                PNTstr+='('
                for j in range(0,(length2-1)):
                  PNTstr+=('%s,' %fh[group][dset2][j])
                PNTstr+=('%s' %fh[group][dset2][length2-1])
                PNTstr+='),'
          PNTstr+=');'  
          PNTstr = PNTstr[:-1]

    outfh.write('%s %s %s %s %s %s %s %s %s %s %s %s %s %s\n' %(tistr,vstr,NTstr,TOLstr,SDstr,SEstr,MEstr,MAEstr,NLEstr,NLTstr,NLFstr,LTEstr,PNTstr,NCTstr))


  else: 
    print('skip this file %s',group)
