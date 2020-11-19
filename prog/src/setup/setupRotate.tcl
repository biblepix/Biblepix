# ~/Biblepix/prog/src/setup/setupRotate.tcl
# Creates Rotate toplevel window with scale & meter
# Sourced by "Bild drehen" button
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 19nov20 pv

source $RotateTools
namespace eval addpicture {}

#Toplevel main window
set T .rotateW
set scale $T.scale
set mC $T.meterC
toplevel $T -width 600 -height 400
set C $T.rotateC
set mC $T.meterC
canvas $mC -width 200 -height 110 -borderwidth 2 -relief sunken -bg lightblue

image create photo rotateCanvPic
rotateCanvPic copy photosCanvPic
set im rotateCanvPic
set ::v 0

#Picture & buttons
button $T.previewBtn -textvar computePreview -activebackground beige -command {vorschau $im $::v $C;pack $mC $scale}
button $T.90°Btn -textvar preview90 -activebackground beige -command {pack forget $mC $scale;vorschau $im 90 $C ; set ::v 90}
button $T.180°Btn -textvar preview180 -activebackground beige -command {pack forget $mC $scale;vorschau $im 180 $C ; set ::v 180}

photosCanvPic blank
photosCanvPic copy rotateCanvPic -shrink

#TODO getting there...
set cancelBtnAction {
  set ::Modal.Result "Cancelled"
  destroy $T
}

#Create message field
label $T.msgL -textvar rotateWait -bg silver -fg silver -font {TkHeadingFont 16 bold} -anchor n -pady 20 

set confirmBtnAction {
  #Initiate rotation in background, close window when finished 
  after 500 "
    doRotateOrig photosOrigPic $v
    destroy $T
  "
  #Run foreground actions
  $T.msgL conf -fg red -bg beige
  photosCanvPic blank
  photosCanvPic copy rotateCanvPic -shrink
  set ::Modal.Result "Success"  
}

button $T.saveBtn -textvar save -activebackground lightgreen -command $confirmBtnAction
button $T.cancelBtn -textvar cancel -activebackground red -command $cancelBtnAction

catch { canvas $C }
$C create image 20 20 -image $im -anchor nw -tags img
$C conf -width [image width $im] -height [image height $im]
pack $C

#Create Meter
#set mC .rotateW.meterC
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

pack $T.previewBtn -pady 10
pack $T.msgL -fill x
pack $T.cancelBtn $T.saveBtn -side right

bind $T <Escape> {destroy $T}
bind $T <Return> "imageRotate photosCanvPic $v; return 0 "

Show.Modal $T -destroy 0 -onclose $cancelBtnAction
