# ~/Biblepix/prog/src/setup/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 11oct21 pv
set fileJList ""

#Create main title
label .phMainTit -textvar msg::f6Tit -font bpfont3 -justify left
pack .phMainTit -in .photosF -anchor w

#Create frames
pack [frame .phMainF] -in .photosF -fill x
pack [frame .phLeftF] -in .phMainF -side left -anchor nw
pack [frame .phRightF] -in .phMainF -side right -expand 1
pack [frame .phBarF] -in .phRightF -anchor w -fill x
pack [frame .phBotF -pady 7] -in .phRightF -side bottom -anchor nw -fill both
pack [frame .phBildF -relief sunken -bd 3] -in .phRightF -anchor e -pady 3 -expand 1 -fill x

#Create Text left
message .phMaintxtM -textvar msg::f6Txt -font bpfont1 -padx $px -pady $py
pack .phMaintxtM -in .phLeftF -anchor nw -side left -padx {10 40} -pady 40

#Build Photo bar right
button .phOpen -width 30 -textvar msg::f6Find -height 1 -command {
  set fileJList [doOpen $DesktopPicturesDir .photosC]
}
button .ph< -text < -height 1 -command {set fileJList [step $fileJList 1 .photosC]}
button .ph> -text > -height 1 -command {set fileJList [step $fileJList 0 .photosC]}
button .phCollectBtn -textvar msg::f6Show -height 1 -command {
  set fileJList [doCollect .photosC]
}
#Pack bar
##(Count pictures number & text labels packed later by doCollect)
label .phCountNum -textvar numPhotos -bg lightblue
label .phCountTxt -textvar msg::f6numPhotosTxt -bg lightblue
pack .phOpen -in .phBarF -side left
pack .ph< -in .phBarF -side left
pack .ph> -in .phBarF -side left

#Build Photo canvas right
canvas .photosC
pack .photosC -in .phBildF -side left
label .phPicpathL -textvar picPath
##these are packed later by doCollect
button .phAddBtn -textvar msg::f6Add -activebackground lightgreen -command {addPic $::picPath}
button .phDelBtn -textvar msg::f6Del -activebackground red -command {delPic .photosC}
button .phRotateBtn -activebackground orange -textvar msg::rotatePic -command {source $::SetupRotate}

#TODO Joel Bild nicht angezeigt bei Programmstart!
set fileJList [doCollect .photosC]
