# ~/Biblepix/prog/src/setup/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 29jul21 pv

set fileJList ""

#Create title
label .photosF.l1 -text "[mc f6Tit]" -font bpfont3 -justify left
pack .photosF.l1 -anchor w

#Create frames
pack [frame .photosF.mainf] -expand false -fill x
pack [frame .photosF.mainf.left] -side left -expand false -anchor nw
pack [frame .photosF.mainf.right] -side right -expand true
pack [frame .photosF.mainf.right.bar] -anchor w -fill x
pack [frame .photosF.mainf.right.unten -pady 7] -side bottom -anchor nw -fill both
pack [frame .photosF.mainf.right.bild -relief sunken -bd 3] -anchor e -pady 3 -expand 1 -fill x

#Create Text left
message .photosF.mainf.left.t1 -text "[mc f6Txt]" -font bpfont1 -padx $px -pady $py
pack .photosF.mainf.left.t1 -anchor nw -side left -padx {10 40} -pady 40

#Build Photo bar right
button .photosF.mainf.right.bar.open -width 30 -text "[mc f6Find]" -height 1 -command {set fileJList [doOpen $DesktopPicturesDir .photosC]}
button .photosF.mainf.right.bar.< -text < -height 1 -command {set fileJList [step $fileJList 1 .photosC]}
button .photosF.mainf.right.bar.> -text > -height 1 -command {set fileJList [step $fileJList 0 .photosC]}
button .photosF.mainf.right.bar.collect -text "[mc f6Show]" -height 1 -command {set fileJList [doCollect .photosC]}
label .photosF.mainf.right.bar.count1 -textvar numPhotos -bg lightblue
label .photosF.mainf.right.bar.count2 -text "[mc f6numPhotosTxt]" -bg lightblue

pack .photosF.mainf.right.bar.open -side left
pack .photosF.mainf.right.bar.< -side left
pack .photosF.mainf.right.bar.> -side left

#Build Photo canvas right
canvas .photosC
pack .photosC -in .photosF.mainf.right.bild -side left

label .picPathL -textvar picPath
##wird später von doCollect gepackt
#pack .picPathL -in .photosF.mainf.right
  
button .addBtn -text "[mc f6Add]" -activebackground lightgreen -command {addPic $::picPath}
button .delBtn -text "[mc f6Del]" -activebackground red -command {delPic .photosC}
button .rotateBtn -activebackground orange -text "[mc rotatePic]" -command {source $::SetupRotate}

set fileJList [doCollect .photosC]
