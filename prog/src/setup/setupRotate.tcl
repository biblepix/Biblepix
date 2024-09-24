# ~/Biblepix/prog/src/setup/setupRotate.tcl
# Creates Rotate toplevel window with scale & mC
# Sourced by "Bild drehen" button
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 24sep24 pv

#TODO make sure photosCanvPic is found!!!
image create photo photosCanvPic
photosCanvPic copy thumb
 
source $RotateTools
namespace eval rotatepic {}
namespace eval addpicture {}

set picname $canvpic::curpic
set picdir  $canvpic::picdir

namespace eval rotatepic {
        variable rotateCanvPic ;#rotateCanvPic
        set rotateCanvPic thumb
}

#Create top window with 4 frames
set rotatepic::W [toplevel .rotateW -width 600 -height 400]
after idle {tk::PlaceWindow .rotateW center}

set F0 [frame ${rotatepic::W}.infoF -bg beige]
set F1 [frame ${rotatepic::W}.topF]
set col1 [gradient beige -0.2]
set col2 [gradient beige -0.1]
set F2 [frame ${rotatepic::W}.midF -bg $col1 -bd 5]
set F3 [frame ${rotatepic::W}.botF -bg $col2 -bd 5]
pack $F0 $F1 $F2 $F3 -fill x -anchor n

#Create widget vars
set scale $F3.scale
set mC $F3.meter
set canv  $F1.rotateC
set 90Btn $F2.90Btn
set 180Btn $F2.180Btn
set anyBtn $F3.anyBtn

#Create photo canvas & copy over photosCanvPic
canvas $mC -width 200 -height 110 -borderwidth 2 -relief sunken -bg lightblue

#Create original pic -TODO only at end?
#TODO this sucks, better below
namespace eval rotatepic {
  set path [file join $canvpic::picdir $canvpic::curpic]
  image create photo rotateOrigPic -file $path
}



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

button $anyBtn -textvar msg::computePreview -activebackground beige \
-command {
  anysetnormal
  vorschau $rotatepic::rotateCanvPic $rotatepic::angle $canv
  $saveBtn conf -bg lightgreen
}
 
button $90Btn -textvar msg::preview90 -activebackground beige \
-command {
  90-180setnormal
  vorschau $rotatepic::rotateCanvPic 90 $canv
  set rotatepic::angle 90
  $saveBtn conf -bg lightgreen
}

button $180Btn -textvar msg::preview180 -activebackground beige \
-command {
  90-180setnormal
  vorschau $rotatepic::rotateCanvPic 180 $canv
  set rotatepic::angle 180
  $saveBtn conf -bg lightgreen
}

set cancelBtnAction {
  set ::Modal.Result "Cancelled"
  catch {image delete $rotatepic::rotateCanvPic}
  destroy $rotatepic::W
  namespace delete rotatepic
}

set confirmBtnAction {
  
  #Create message window on top
  set res [tk_messageBox -type yesno -message $msgbox::rotateWait]
  if {$res == "no"} {
    allsetnormal
    return 1
  }
  
	#Run foreground actions
  vorschau $rotatepic::rotateCanvPic $rotatepic::angle $canv
  photosCanvPic blank
  photosCanvPic copy $rotatepic::rotateCanvPic -shrink

  #Initiate rotation in background, disable controls
  $::saveBtn conf -state disabled
  $::anyBtn conf -state disabled
  .rotateW.infoL conf -fg black -bg orange
  set msg::rotateInfo "[mc rotateWait]"
  if {$lang=="ar"} {set msg::rotateInfo [bidi::fixBidi "[mc rotateWait]"]}
 
  $rotatepb start
  doRotateOrig thumb $rotatepic::angle 1

	#Cleanup
  set msg::rotateInfo "[mc rotateInfo]"
  destroy $rotatepic::W
  namespace delete rotatepic
  set ::Modal.Result "Success"
	.phAddBtn conf -bg lightgreen -activebackground orange
	}

#Create Info label & buttons
set infoL [label .rotateW.infoL -textvar msg::rotateInfo -font TkCaptionFont -bg beige -fg green -padx 5 -pady 10]
set saveBtn $rotatepic::W.saveBtn
set cancelBtn $rotatepic::W.cancelBtn
button $saveBtn -textvar msg::save -activebackground lightgreen -command $confirmBtnAction
button $cancelBtn -textvar msg::cancel -activebackground red -command $cancelBtnAction

catch { canvas $canv }
$canv create image 6 6 -image $rotatepic::rotateCanvPic -anchor nw -tags img
$canv conf -width [image width $rotatepic::rotateCanvPic] -height [image height $rotatepic::rotateCanvPic]

pack $infoL -in $F0 -side left -fill x -expand 1
pack $cancelBtn $saveBtn -in $F0 -side right

pack $canv -in $F1

#Create scale
set ::pi 3.1415927 ;# Good enough accuracy for gfx...
scale $scale -orient h -length 300 -from -30 -to 30 -variable v
set from [$scale cget -from]
set to [$scale cget -to]

#Create meter
pack [makeMeter] -pady 10
pack $scale
trace add variable v write updateMeter
trace add variable v write updateAngle

#Create progress bar
set rotatepb .rotateW.midF.pb
ttk::progressbar $rotatepb -length 200 -orient horizontal -mode indeterminate

#Pack all
pack $90Btn -pady 5 -side left -expand 1
pack $rotatepb -side left -expand 1  
pack $180Btn -side left -expand 1
pack $anyBtn -pady 10

#Return & Escape bindings
bind $rotatepic::W <Escape> $cancelBtnAction
bind $rotatepic::W <Return> $confirmBtnAction
Show.Modal $rotatepic::W -destroy 0 -onclose $cancelBtnAction

