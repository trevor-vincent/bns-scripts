#### import the simple module from the paraview
from paraview.simple import *
# import string
import argparse

# def compute_slice

def slicer(pvdfile, pngfileprefix, time, thingtoslice, nx, ny, nz, ox, oy, oz):

    paraview.simple._DisableFirstRenderCameraReset()
    volumepvd = PVDReader(FileName=pvdfile)
    
    renderView1 = GetActiveViewOrCreate('RenderView')
    print "Writing png for timestep" + str(time)
    renderView1.ViewTime = time
    renderView1.ViewSize = [800, 800]

    # show data in view
    volumepvdDisplay = Show(volumepvd, renderView1)

    # reset view to fit data
    renderView1.ResetCamera()

    # change representation type
    volumepvdDisplay.SetRepresentationType('Surface With Edges')

    # set scalar coloring
    ColorBy(volumepvdDisplay, ('POINTS', thingtoslice))

    # create a new 'Slice'
    slice1 = Slice(Input=volumepvd)
    slice1.SliceType = 'Plane'
    slice1.Crinkleslice = 0
    slice1.Triangulatetheslice = 1
    slice1.SliceOffsetValues = [0.0]
    
    # init the 'Plane' selected for 'SliceType'
    # slice1.SliceType.Origin = [-1.407350000000001, 0.0, 4.0468375]
    # slice1.SliceType.Origin = [-1.407350000000001, 0.0, 4.0468375]

    if nx is not None:
        if ny is not None:
            if nz is not None:
                slice1.SliceType.Normal = [nx, ny, nz]
    else:
        slice1.SliceType.Normal = [0.0, 0.0, 1.0]

    if ox is not None:
        if oy is not None:
            if oz is not None:
                slice1.SliceType.Origin = [ox, oy, oz]
        
    # 
    slice1.SliceType.Offset = 0.0

    # show data in view
    slice1Display = Show(slice1, renderView1)
    slice1Display.CubeAxesVisibility = 0
    slice1Display.Representation = 'Surface'
    slice1Display.ColorArrayName = ['POINTS', thingtoslice]
    
    slice1Display.RescaleTransferFunctionToDataRange(True)

    #w = FindSource(thingtoslice)
    #pd = w.PointData

    #for n in range(pd.GetNumberOfArrays()):
    #    print "Range for array ", pd.GetArray(n).GetName(), " ", pd.GetArray(n).GetRange()

    #info = slice1Display.GetDataInformation().DataInformation
    #arrayInfo = info.GetArrayInformation(thingtoslice, vtk.vtkDataObject.FIELD_ASSOCIATION_POINTS)
    #range = arrayInfo.GetComponentRange(0)

    tf = GetColorTransferFunction(thingtoslice)
    #tf.RescaleTransferFunction(1e-12, pd.GetArray(0).GetRange()[1])
    #op = GetOpacityTransferFunction(thingtoslice)
    #op.RescaleTransferFunction(1e-12, pd.GetArray(0).GetRange()[1])
    tf.MapControlPointsToLogSpace()
    tf.UseLogScale = 1

    # hide data in view
    Hide(volumepvd, renderView1)

    # show color bar/color legend
    slice1Display.SetScalarBarVisibility(renderView1, True)
    
    SaveScreenshot(pngfileprefix + str(time) + ".png", magnification=1, quality=100, view=renderView1)
    # WriteImage('/home/tvincent/Dropbox/Research/Notes/BNS-Project/temp/testscr.jpg')


def main():
    parser = argparse.ArgumentParser(description="Set normal and origin with -nx -ox etc.")
    parser.add_argument('-png', '--pngfile', type=str, required=False)
    parser.add_argument('-obj', '--field', type=str, required=True)
    parser.add_argument('-pvd', '--pvdfile', type=str, required=True)
    parser.add_argument('-nx', '--normal-x', type=float, required=False)
    parser.add_argument('-ny', '--normal-y', type=float, required=False)
    parser.add_argument('-nz', '--normal-z', type=float, required=False)
    parser.add_argument('-ox', '--origin-x', type=float, required=False)
    parser.add_argument('-oy', '--origin-y', type=float, required=False)
    parser.add_argument('-oz', '--origin-z', type=float, required=False)
    parser.add_argument('values', type=float, nargs='*')
    args = parser.parse_args()
    
    volumepvd = PVDReader(FileName=args.pvdfile)
    NSTimes = volumepvd.TimestepValues
    temp = NSTimes.GetData()
    for i,v in enumerate(temp):
        slicer(args.pvdfile, args.pngfile, v, args.field, args.normal_x, args.normal_y, args.normal_z, args.origin_x, args.origin_y, args.origin_z)
        
if __name__ == '__main__':
    main()

