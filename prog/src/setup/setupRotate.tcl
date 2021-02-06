# ~/Biblepix/prog/src/setup/setupRotate.tcl
# Creates Rotate toplevel window with scale & mC
# Sourced by "Bild drehen" button
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 4feb21

source $RotateTools
namespace eval rotatepic {}
namespace eval addpicture {}

if {![info exists addpicture::curPic]} {
  set addpicture::curPic photosOrigPic
}

#Create top window with 3 frames
set rotatepic::W [toplevel .rotateW -width 600 -height 400]
set F1 [frame ${rotatepic::W}.topF]
set col1 [gradient beige -0.2]
set col2 [gradient beige -0.1]
set F2 [frame ${rotatepic::W}.midF -bg $col1 -bd 5]
set F3 [frame ${rotatepic::W}.botF -bg $col2 -bd 5]
pack $F1 $F2 $F3 -fill x -anchor n

#Create widget vars
set scale $F3.scale
set mC $F3.meter
set canv  $F1.rotateC
set 90Btn $F2.90Btn
set 180Btn $F2.180Btn
set anyBtn $F3.anyBtn

#Create photo canvas & copy over photosCanvPic
canvas $mC -width 200 -height 110 -borderwidth 2 -relief sunken -bg lightblue
set rotatepic::rotateCanvPic [image create photo]
$rotatepic::rotateCanvPic copy photosCanvPic
set rotatepic::angle 0
set ::v 0

#F1: Picture & 2 buttons
proc 90-180setnormal {} {
  $::90Btn conf -state normal
  $::180Btn conf -state normal
  $::anyBtn conf -state disabled
  $::mC conf -bg silver
  $::scale conf -state disabled
  $::F3 conf -bg silver
}
proc anysetnormal {} {
  $::anyBtn conf -state normal
  $::mC conf -bg lightblue
  $::scale conf -state normal
  $::F2 conf -bg silver
  $::90Btn conf -state disabled
  $::180Btn conf -state disabled
}
proc allsetnormal {} {
  $::F2 conf -bg green
  $::F3 conf -bg green3
  $::anyBtn conf -state normal
  $::90Btn conf -state normal
  $::180Btn conf -state normal
  $::mC conf -bg lightblue
  $::scale conf -state normal
}

button $anyBtn -textvar computePreview -activebackground beige \
-command {
  anysetnormal
  vorschau $rotatepic::rotateCanvPic $rotatepic::angle $canv
}
 
button $90Btn -textvar preview90 -activebackground beige \
-command {
  90-180setnormal
  vorschau $rotatepic::rotateCanvPic 90 $canv
  set rotatepic::angle 90
}

button $180Btn -textvar preview180 -activebackground beige \
-command {
  90-180setnormal
  vorschau $rotatepic::rotateCanvPic 180 $canv
  set rotatepic::angle 180
}

set cancelBtnAction {
  set ::Modal.Result "Cancelled"
  catch {image delete $rotatepic::rotateCanvPic}
  destroy $rotatepic::W
  namespace delete rotatepic
}

set confirmBtnAction {
  #Run foreground actions
  vorschau $rotatepic::rotateCanvPic $rotatepic::angle $canv
  photosCanvPic blank
  photosCanvPic copy $rotatepic::rotateCanvPic -shrink

  #Create message window on top
  set res [tk_messageBox -type yesno -message $rotateWait]
  if {$res == "no"} {
    allsetnormal
    return 0
  }
  
  #Initiate rotation in background, disable controls, close window when finished
  after idle {
    doRotateOrig $addpicture::curPic $rotatepic::angle
    destroy $rotatepic::W
    namespace delete rotatepic
  }

  image delete $rotatepic::rotateCanvPic
  set ::Modal.Result "Success"
}

set saveBtn $rotatepic::W.saveBtn
set cancelBtn $rotatepic::W.cancelBtn
button $saveBtn -textvar save -activebackground lightgreen -command $confirmBtnAction
button $cancelBtn -textvar cancel -activebackground red -command $cancelBtnAction

catch { canvas $canv }
$canv create image 6 6 -image $rotatepic::rotateCanvPic -anchor nw -tags img
$canv conf -width [image width $rotatepic::rotateCanvPic] -height [image height $rotatepic::rotateCanvPic]
pack $canv -in $F1

#Create scale
set ::pi 3.1415927 ;# Good enough accuracy for gfx...
scale $scale -orient h -length 300 -from -30 -to 30 -variable v
set from [$scale cget -from]
set to [$scale cget -to]

#Create meter
#set meter [makeMeter]
pack [makeMeter] -pady 10
pack $scale
trace add variable v write updateMeter
trace add variable v write updateAngle

#Pack all
pack $90Btn -pady 5 -side left -expand 1
pack $180Btn -side left -expand 1
pack $anyBtn -pady 10
pack $cancelBtn $saveBtn -side right
bind $rotatepic::W <Escape> $cancelBtnAction
bind $rotatepic::W <Return> $confirmBtnAction
Show.Modal $rotatepic::W -destroy 0 -onclose $cancelBtnAction
