# ~/Biblepix/prog/src/setup/setupRotate.tcl
# Creates Rotate toplevel window with scale & meter
# Sourced by "Bild drehen" button
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 16nov20

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
button $T.previewBtn -textvar computePreview -activebackground beige -command {vorschau $im $::v $C}
button $T.cancelBtn -textvar cancel -activebackground red -command {catch {destroy $T} ; return 0}
button $T.90°Btn -textvar preview90 -activebackground beige -command {vorschau $im 90 $C ; set ::v 90}
button $T.180°Btn -textvar preview180 -activebackground beige -command {vorschau $im 180 $C ; set ::v 180}

#TODO Move to doRotateOrigPic
button $T.saveBtn -textvar save -activebackground lightgreen -command {
#  namespace eval addpicture {
#    set rotateStatus 0
#  }
  photosCanvPic blank
  photosCanvPic copy rotateCanvPic -shrink
  
  #TODO geht nicht
$T.msgL conf -bg beige 
set ::rotateMsg "Bitte warten Sie einen LANGEN Augenblick..."

  after idle {
  doRotateOrig photosOrigPic $::v
  destroy $T
  }
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

pack $T.90°Btn -pady 5
pack $T.180°Btn
pack [makeMeter] -pady 10

#Pack Scale
pack $scale
trace add variable v write updateMeter
updateMeterTimer

#Create message field
label $T.msgL -textvar ::rotateMsg -background grey -foreground red -font {TkHeadingFont 16 bold} -anchor n -pady 20 

pack $T.previewBtn -pady 10
pack $T.msgL -fill x
pack $T.cancelBtn $T.saveBtn -side right

bind $T <Escape> {destroy $T}
bind $T <Return> "imageRotate photosCanvPic $v; return 0 "

