import visit
import sys

if len(sys.argv) != 3:
    print("rho_visit_with_args.py <filename_to_open> <filename_to_save>")
    print("use absolute paths except you don't need to for filename_to_save")
    exit(1)

print("Opening " + sys.argv[1])
OpenDatabase(sys.argv[1])

DeleteAllPlots()

AddPlot("Volume", "Rho0Phys", 0, 0)
atts = VolumeAttributes()
atts.opacityAttenuation = 0.1
atts.opacityMode = atts.GaussianMode  # FreeformMode, GaussianMode, ColorTableMode
c = GaussianControlPointList()
for i in range(5):
    p1 = GaussianControlPoint()
    p1.x = 0.2*i + 0.2
    p1.height=0.2*i
    p1.width=0.14
    c.AddControlPoints(p1)

atts.SetOpacityControlPoints(c)
atts.useColorVarMin = 1
atts.colorVarMin = 4e-11
atts.smoothData = 1
atts.samplesPerRay = 500
atts.rendererType = atts.RayCasting  # Splatting, Texture3D, RayCasting, RayCastingIntegration, SLIVR, RayCastingSLIVR, Tuvok
atts.gradientType = atts.SobelOperator  # CenteredDifferences, SobelOperator
atts.num3DSlices = 4000
atts.scaling = atts.Log  # Linear, Log, Skew
atts.skewFactor = 1
atts.limitsMode = atts.OriginalData  # OriginalData, CurrentPlot
atts.sampling = atts.Rasterization  # KernelBased, Rasterization, Trilinear
atts.rendererSamples = 4
atts.transferFunctionDim = 1
atts.lowGradientLightingReduction = atts.Lower  # Off, Lowest, Lower, Low, Medium, High, Higher, Highest
atts.lowGradientLightingClampFlag = 0

SetPlotOptions(atts)
SetActivePlots(0)
DrawPlots()

# 30 degrees from along z
view = View3DAttributes()
view.viewNormal = (0.5, 0.0, 0.86602540378)
view.viewNormal = ( 0.35355339,  0.35355339,  0.8660254)

view.focus = (0, 0, 0)
view.viewUp = (0.0991677, -0.103493, 0.989674)
view.viewAngle = 30
view.parallelScale = 2424.87
view.nearPlane = -4849.74
view.farPlane = 4849.74
view.imagePan = (0, 0)
view.imageZoom = 29
view.perspective = 1
view.eyeAngle = 2
view.centerOfRotationSet = 0
view.centerOfRotation = (0, 0, 0)
view.axis3DScaleFlag = 0
view.axis3DScales = (1, 1, 1)
view.shear = (0, 0, 1)
view.windowValid = 1
SetView3D(view)


# Set the annotation attributes
annot = AnnotationAttributes()
annot.axes2D.visible = 0
annot.axes3D.visible = 0
annot.axes3D.triadFlag = 0
annot.axes3D.bboxFlag = 0
annot.userInfoFlag = 0
annot.databaseInfoFlag = 0
annot.legendInfoFlag = 0
#annot.backgroundMode = annot.Image  # Solid, Gradient, Image, ImageSphere
#annot.backgroundImage = "/home/tdietrich/star_field.png"
SetAnnotationAttributes(annot)

print("Saving file " + sys.argv[2] + ".PNG")
SetActiveWindow(GetGlobalAttributes().windows[0])
swatts=SaveWindowAttributes()
swatts.format=swatts.PNG
swatts.width=3840
swatts.height=2160
swatts.resConstraint=swatts.NoConstraint
swatts.quality=100
swatts.progressive=0
swatts.screenCapture=0
swatts.family=0
swatts.fileName=sys.argv[2]
SetSaveWindowAttributes(swatts)
SaveWindow()
visit.CloseComputeEngine('localhost')
exit(0)
