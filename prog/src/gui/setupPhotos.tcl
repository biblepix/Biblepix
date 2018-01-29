# ~/Biblepix/prog/src/gui/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 13dec17

set fileJList ""

#Create title
label .nb.photos.l1 -textvar f6.tit -font bpfont3 -justify left
pack .nb.photos.l1 -anchor w

#Create frames
pack [frame .nb.photos.mainf] -expand false -fill x
pack [frame .nb.photos.mainf.left] -side left -expand false -anchor nw
pack [frame .nb.photos.mainf.right] -side right -expand true
pack [frame .nb.photos.mainf.right.bar] -anchor w -fill x
pack [frame .nb.photos.mainf.right.unten -pady 7]  -side bottom -anchor nw -fill both
pack [frame .nb.photos.mainf.right.bild -relief sunken -bd 3] -anchor e -pady 3 -expand 1 -fill x

#Create Text left
message .nb.photos.mainf.left.t1 -textvar f6.txt -font bpfont1 -padx $px -pady $py
pack .nb.photos.mainf.left.t1 -anchor nw -side left -padx {10 40} -pady 40

#Build Photo bar right
button .nb.photos.mainf.right.bar.open -textvar f6.find -height 1 -command {set fileJList [doOpen $DesktopPicturesDir .imgCanvas]}
button .nb.photos.mainf.right.bar.< -text < -height 1 -command {set fileJList [step $fileJList 0 .imgCanvas]}
button .nb.photos.mainf.right.bar.> -text > -height 1 -command {set fileJList [step $fileJList 1 .imgCanvas]}
button .nb.photos.mainf.right.bar.collect -textvar f6.show -height 1 -command {set fileJList [doCollect .imgCanvas]}

pack .nb.photos.mainf.right.bar.open -side left
pack .nb.photos.mainf.right.bar.< -side left
pack .nb.photos.mainf.right.bar.> -side left -fill x
pack .nb.photos.mainf.right.bar.collect -side right -fill x

#Build Photo canvas right
set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]
set factor [expr $screenX./$screenY]
set canvX 650
set canvY [expr round($canvX/$factor)]
canvas .imgCanvas -width $canvX -height $canvY
pack .imgCanvas -in .nb.photos.mainf.right.bild -side left

label .picPath -textvar picPath
button .addBtn -textvar f6.add -bg green -command {addPic}
button .delBtn -textvar f6.del -bg red -command {delPic}

set fileJList [doCollect .imgCanvas]
