# ~/Biblepix/prog/src/setup/setupRotate.tcl
# Creates Rotate toplevel window with scale & meter
# Sourced by "Bild drehen" button
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 30dec20 jh

source $RotateTools
namespace eval rotatePic {}

#Toplevel main window
set rotatePic::T .rotateW
set scale $rotatePic::T.scale
set mC $rotatePic::T.meterC
set canv $rotatePic::T.rotateC
toplevel $rotatePic::T -width 600 -height 400
canvas $mC -width 200 -height 110 -borderwidth 2 -relief sunken -bg lightblue

#Copy photosCanvPic to rotateCanv
set rotatePic::rotateCanvPic [image create photo]
$rotatePic::rotateCanvPic copy photosCanvPic
set rotatePic::angle 0
set ::v 0

#Picture & buttons
button $rotatePic::T.previewBtn -textvar computePreview -activebackground beige \
 -command {vorschau $rotatePic::rotateCanvPic $rotatePic::angle $canv; pack $mC $scale}
 
button $rotatePic::T.90°Btn -textvar preview90 -activebackground beige \
-command {pack forget $mC $scale; vorschau $rotatePic::rotateCanvPic 90 $canv; set rotatePic::angle 90}

button $rotatePic::T.180°Btn -textvar preview180 -activebackground beige \
-command {pack forget $mC $scale; vorschau $rotatePic::rotateCanvPic 180 $canv; set rotatePic::angle 180}

#Create message field
label $rotatePic::T.msgL -textvar rotateWait -bg silver -fg silver -font {TkHeadingFont 16 bold} -anchor n -pady 20 

set cancelBtnAction {
  set ::Modal.Result "Cancelled"
  image delete $rotatePic::rotateCanvPic
  destroy $rotatePic::T
  namespace delete rotatePic
}

set confirmBtnAction {
  #Initiate rotation in background, close window when finished 
  after idle {
    doRotateOrig photosOrigPic $rotatePic::angle
    destroy $rotatePic::T
    namespace delete rotatePic
  }

  vorschau $rotatePic::rotateCanvPic $rotatePic::angle $canv

  #Run foreground actions
  $rotatePic::T.msgL conf -fg red -bg beige -bd 5
  photosCanvPic blank
  photosCanvPic copy $rotatePic::rotateCanvPic -shrink
  image delete $rotatePic::rotateCanvPic
  set ::Modal.Result "Success"
}

button $rotatePic::T.saveBtn -textvar save -activebackground lightgreen -command $confirmBtnAction
button $rotatePic::T.cancelBtn -textvar cancel -activebackground red -command $cancelBtnAction

catch { canvas $canv }
$canv create image 6 6 -image $rotatePic::rotateCanvPic -anchor nw -tags img
$canv conf -width [image width $rotatePic::rotateCanvPic] -height [image height $rotatePic::rotateCanvPic]
pack $canv

#Create Meter
#set mC .rotateW.meterC
set ::pi 3.1415927 ;# Good enough accuracy for gfx...
scale .rotateW.scale -orient h -length 300 -from -90 -to 90 -variable v
set from [$scale cget -from]
set to [$scale cget -to]

pack $rotatePic::T.90°Btn -pady 5
pack $rotatePic::T.180°Btn
pack [makeMeter] -pady 10

#Pack Scale
pack $scale
trace add variable v write updateMeter
trace add variable v write updateAngle

pack $rotatePic::T.previewBtn -pady 10
pack $rotatePic::T.msgL -fill x
pack $rotatePic::T.cancelBtn $rotatePic::T.saveBtn -side right

bind $rotatePic::T <Escape> $cancelBtnAction
bind $rotatePic::T <Return> $confirmBtnAction
Show.Modal $rotatePic::T -destroy 0 -onclose $cancelBtnAction
