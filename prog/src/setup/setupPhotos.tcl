# ~/Biblepix/prog/src/setup/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 5may24 pv

#Create frames
pack [frame .phMainF] -in .photosF -fill x -pady $py -padx $px
pack [frame .phLeftF] -in .phMainF -side left -anchor nw -pady $py -padx $px
pack [frame .phRightF] -in .phMainF -side right -anchor e -pady $py -padx $px

#Create main title
label .phMainTit -textvar msg::f6Tit -font bpfont3 -justify left
pack .phMainTit -in .phLeftF -pady 15 -anchor nw

pack [frame .phBarF] -in .phRightF -anchor w -fill x
pack [frame .phBotF -pady 7] -in .phRightF -side bottom -anchor nw -fill both
pack [frame .phBildF -relief sunken -bd 3] -in .phRightF -anchor e -pady 3 -expand 1 -fill x

#Create Text left, limit width to 1/3
message .phMainM -textvar msg::f6Txt -font bpfont1 -width 500 -pady $py -padx $px
pack .phMainM -in .phLeftF -anchor nw -side left

#Build Photo bar right
  button .phOpen -width 30 -textvar msg::f6Find -height 1 -command {
  openFileDialog $DesktopPicturesDir 
}

button .ph< -text < -height 1 -command {step <}
button .ph> -text > -height 1 -command {step >}
button .ph<< -text << -height 1 -command {step <<}
button .ph>> -text >> -height 1 -command {step >>}

button .phShowCollectionBtn -textvar msg::f6Show -height 1 -command {
  scanPicdir $photosdir
  resetPhotosGUI
  set picname [lindex $picL 0]
  set canvpic::index 0
  set canvpic::userI 1
  showImage $picname
}

#Pack bar & buttons
pack .phOpen -in .phBarF -side left
pack .ph>> .ph> .ph< .ph<< -in .phBarF -side right

#Build Photo canvas right & export vars to ::canvpic
set imgCanv [canvas .photosC]
pack $imgCanv -in .phBildF -side left

namespace eval canvpic {
  variable imgCanv .photosC
  variable picdir 
  variable canvX ;#set later when GUI loaded
  variable canvY ;# ---
  variable index 0
  variable curpic 
}

#set picpath & picindex labels
pack [frame .phBotF1] [frame .phBotF2] -in .phBotF -side left 
pack .phBotF1 -fill none -anchor w
pack .phBotF2 -fill x -anchor n -expand 1
label .phPicpathL -padx 2 -pady 2 -fg steelblue -font TkSmallCaptionFont -textvar canvpic::picdir
label .phPicnameL -padx 2 -pady 2 -fg steelblue -textvar canvpic::curpic
label .phPicindexTxt -bg azure -textvar msg::f6numPhotosTxt
label .phPicindexL -bg azure -textvar canvpic::userI
label .phCountNum -textvar numPhotos -bg azure
label .phCountTxt -text "/" -bg azure

##these are packed later by resetPhotosGUI
button .phAddBtn -textvar msg::f6Add -activebackground orange -command {addPic}
button .phDelBtn -textvar msg::f6Del -activebackground red -command {deletePhoto}
button .phRotateBtn -activebackground orange -textvar msg::rotatePic -command {source $SetupRotate}

#Create Photosdir piclist for display of 1st pic
set picL [scanPicdir $photosdir]
set canvpic::userI 1

resetPhotosGUI
