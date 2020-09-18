# ~/Biblepix/prog/src/setup/setupRotate.tcl
# Creates Rotate toplevel window
#
# Updated 3apr20

#Toplevel main window
set T .rotateW
toplevel $T -width 600 -height 400

set C $T.rotateC
set mC $T.meterC
canvas $mC -width 200 -height 110 -borderwidth 2 -relief sunken -bg lightblue

set scale $T.scale

image create photo rotateCanvPic
rotateCanvPic copy photosCanvPic
set im rotateCanvPic


#Picture & buttons
#TODO texte in textfile schieben
button $T.okBtn -text "Vorschau berechnen" -bg orange -activebackground yellow
button $T.cancelBtn -text Abbruch -activebackground red -command {catch {destroy .rotateW} ; return 0}
button $T.saveBtn -text Abspeichern -activebackground lightgreen -command {}

catch  {  canvas $C -width 600 -height 400 }
$C create image 20 20 -image $im -anchor nw
$C conf -width [image width $im] -height [image height $im]
pack $C       

#Create Meter
source $setupdir/setupRotateMeter.tcl
pack [makeMeter] -pady 20

#Pack Scale
#pack [scale $s -orient h -length 300 -from -90 -to 90 -variable v]
pack $scale
trace add variable v write updateMeter
set ::v 0
updateMeterTimer
  
#Load rotate command
source $picdir/ImageRotate.tcl
proc vorschau {} {
  global C im v
  #Reset canvas to original size
  #$im blank
  #$im copy photosCanvPic -shrink
  #$C conf -height [image height $im] -width [image width $im]

#TODO origPic nehmen+rotieren, zwischenspeichern, dann verkleinern für Vorschau
   
  set rotatedImg [image_rotate photosCanvPic $v]
  
  $im blank
  $im copy $rotatedImg 
  image delete $rotatedImg
  $C conf -height [image height $im] -width [image width $im]
  return 0
}
.rotateW.okBtn conf -command {vorschau}

#.rotateW.okBtn conf -command "image_rotate photosCanvPic [$s get]"

#TODO!!! - seems to happen after topwindow is closed
#can't set "v": invalid command name ".rotateW.scale"
#invalid command name ".rotateW.scale"
#    while executing
#"$s cget -from"
#    (procedure "updateMeter" line 4)

pack .rotateW.okBtn -pady 30
pack .rotateW.cancelBtn .rotateW.saveBtn -side right

#    set im photosCanvPic
#    set im2 [image create photo]
#    $im2 copy $im
#    set C .rotateW.rotateC
#    
#$C create image 50  90 -image $im
#$C create image 170 90 -image $im2
#entry $C.e -textvar angle -width 4
#    set angle 99
#    bind $C.e <Return> {
#        $im2 config -width [image width $im] -height [image height $im]
#        $im2 copy $im
#        wm title . [time {image_rotate $im2 $::angle}]
#    }

#$C create window 5 5 -window $C.e -anchor nw
#    checkbutton $C.cb -text Update -variable update
#    set ::update 1
#    $C create window 40 5 -window $C.cb -anchor nw

bind .rotateW <Escape> {destroy .rotateW}
bind .rotateW <Return> "image_rotate photosCanvPic $v; return 0 "
#.rotateW.okBtn conf -bg red -command "image_rotate photosCanvPic $v"
#return

