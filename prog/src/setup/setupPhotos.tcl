# ~/Biblepix/prog/src/setup/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 25nov20 pv

#source $SetupResizeTools
set fileJList ""

#Create title
label .photosF.l1 -textvar f6.tit -font bpfont3 -justify left
pack .photosF.l1 -anchor w

#Create frames
pack [frame .photosF.mainf] -expand false -fill x
pack [frame .photosF.mainf.left] -side left -expand false -anchor nw
pack [frame .photosF.mainf.right] -side right -expand true
pack [frame .photosF.mainf.right.bar] -anchor w -fill x
pack [frame .photosF.mainf.right.unten -pady 7] -side bottom -anchor nw -fill both
pack [frame .photosF.mainf.right.bild -relief sunken -bd 3] -anchor e -pady 3 -expand 1 -fill x

#Create Text left
message .photosF.mainf.left.t1 -textvar f6.txt -font bpfont1 -padx $px -pady $py
pack .photosF.mainf.left.t1 -anchor nw -side left -padx {10 40} -pady 40

#Build Photo bar right
button .photosF.mainf.right.bar.open -width 30 -textvar f6.find -height 1 -command {set fileJList [doOpen $DesktopPicturesDir .imgCanvas]}
button .photosF.mainf.right.bar.< -text < -height 1 -command {set fileJList [step $fileJList 1 .imgCanvas]}
button .photosF.mainf.right.bar.> -text > -height 1 -command {set fileJList [step $fileJList 0 .imgCanvas]}
button .photosF.mainf.right.bar.collect -textvar f6.show -height 1 -command {set fileJList [doCollect .imgCanvas]}
label .photosF.mainf.right.bar.count1 -textvar numPhotos -bg lightblue
label .photosF.mainf.right.bar.count2 -textvar numPhotosTxt -bg lightblue

pack .photosF.mainf.right.bar.open -side left
pack .photosF.mainf.right.bar.< -side left
pack .photosF.mainf.right.bar.> -side left

#Build Photo canvas right
set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]
set maxCanvX [expr round([winfo width .] / 1.5)]
set factor [expr ceil($screenX. / $maxCanvX)]

set canvX [expr round($screenX / $factor)]
set canvY [expr round($screenY / $factor)]

canvas .imgCanvas -width $canvX -height $canvY
pack .imgCanvas -in .photosF.mainf.right.bild -side left

label .picPath -textvar picPath
button .addBtn -textvar f6.add -activebackground lightgreen -command {addPic $::picPath}
button .delBtn -textvar f6.del -activebackground red -command {delPic .imgCanvas}
button .rotateBtn -activebackground orange -textvar rotatePic -command {source $::SetupRotate}

set fileJList [doCollect .imgCanvas]
