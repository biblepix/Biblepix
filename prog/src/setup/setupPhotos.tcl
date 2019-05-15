# ~/Biblepix/prog/src/setup/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15may19

set fileJList ""

#Create title
label .photosF.l1 -textvar f6.tit -font bpfont3 -justify left
pack .photosF.l1 -anchor w

#Create frames
pack [frame .photosF.mainf] -expand false -fill x
pack [frame .photosF.mainf.left] -side left -expand false -anchor nw
pack [frame .photosF.mainf.right] -side right -expand true
pack [frame .photosF.mainf.right.bar] -anchor w -fill x
pack [frame .photosF.mainf.right.unten -pady 7]  -side bottom -anchor nw -fill both
pack [frame .photosF.mainf.right.bild -relief sunken -bd 3] -anchor e -pady 3 -expand 1 -fill x

#Create Text left
message .photosF.mainf.left.t1 -textvar f6.txt -font bpfont1 -padx $px -pady $py
pack .photosF.mainf.left.t1 -anchor nw -side left -padx {10 40} -pady 40

#Build Photo bar right
button .photosF.mainf.right.bar.open -textvar f6.find -height 1 -command {set fileJList [doOpen $DesktopPicturesDir .imgCanvas]}
button .photosF.mainf.right.bar.< -text < -height 1 -command {set fileJList [step $fileJList 0 .imgCanvas]}
button .photosF.mainf.right.bar.> -text > -height 1 -command {set fileJList [step $fileJList 1 .imgCanvas]}
button .photosF.mainf.right.bar.collect -textvar f6.show -height 1 -command {set fileJList [doCollect .imgCanvas]}

pack .photosF.mainf.right.bar.open -side left
pack .photosF.mainf.right.bar.< -side left
pack .photosF.mainf.right.bar.> -side left -fill x
pack .photosF.mainf.right.bar.collect -side right -fill x

#Build Photo canvas right
set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]
set factor [expr $screenX./$screenY]
set canvX 650
set canvY [expr round($canvX/$factor)]
canvas .imgCanvas -width $canvX -height $canvY
pack .imgCanvas -in .photosF.mainf.right.bild -side left

label .picPath -textvar picPath
button .addBtn -textvar f6.add -bg lightgreen -activebackground gold -command {addPic}
button .delBtn -textvar f6.del -bg orange -activebackground red -command {delPic}

set fileJList [doCollect .imgCanvas]
