# ~/Biblepix/prog/src/setup/setupRotate.tcl
# Creates Rotate toplevel window with scale & meter
# Sourced by "Bild drehen" button
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 24oct20

source $RotateTools

#Toplevel main window
set T .rotateW
set scale $T.scale
toplevel $T -width 600 -height 400
set C $T.rotateC
set mC $T.meterC
canvas $mC -width 200 -height 110 -borderwidth 2 -relief sunken -bg lightblue

image create photo rotateCanvPic
rotateCanvPic copy photosCanvPic
set im rotateCanvPic
set ::v 0

#Picture & buttons
button $T.previewBtn -textvar computePreview -bg orange -activebackground yellow -command {vorschau $im $::v $C}
button $T.cancelBtn -textvar cancel -activebackground red -command {catch {destroy $T} ; return 0}
button $T.180Btn -text "180° Bild auf Kopf" -pady 10 -command {vorschau $im 180 $C ; set ::v 180}

#TODO Move to doRotateOrigPic
button $T.saveBtn -textvar save -activebackground lightgreen -command {
  #TODO erscheint nicht!
#  NewsHandler::QueryNews "Rotating original picture; this could take some time..." orange

#  set rotatedImg [doRotateOrig photosOrigPic $::v]
  photosCanvPic blank
  photosCanvPic copy rotateCanvPic -shrink
  #TODO: set addpicture::origPic here???? (cf. addPic)
  destroy $T
#  addPic $rotatedImg $::picPath
  }

catch { canvas $C }
$C create image 20 20 -image $im -anchor nw -tags img
$C conf -width [image width $im] -height [image height $im]
pack $C

#Create Meter
set mC .rotateW.meterC
set ::pi 3.1415927 ;# Good enough accuracy for gfx...
scale .rotateW.scale -orient h -length 300 -from -90 -to 90 -variable v
set from [$scale cget -from]
set to [$scale cget -to]

pack $T.180Btn
pack [makeMeter] -pady 20

#Pack Scale
pack $scale
trace add variable v write updateMeter
updateMeterTimer


pack $T.previewBtn -pady 30
pack $T.cancelBtn $T.saveBtn -side right

bind $T <Escape> {destroy $T}
bind $T <Return> "imageRotate photosCanvPic $v; return 0 "

