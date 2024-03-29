# ~/Biblepix/prog/src/setup/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 22mch24 pv

#set fileJList ""

#Create frames
pack [frame .phMainF] -in .photosF -fill x -pady $py -padx $px
pack [frame .phLeftF] -in .phMainF -side left -anchor nw -pady $py -padx $px
pack [frame .phRightF] -in .phMainF -side right -anchor e -pady $py -padx $px

#Create main title
label .phMainTit -textvar msg::f6Tit -font bpfont3 -justify left
pack .phMainTit -in .phLeftF -pady 15

pack [frame .phBarF] -in .phRightF -anchor w -fill x
pack [frame .phBotF -pady 7] -in .phRightF -side bottom -anchor nw -fill both
pack [frame .phBildF -relief sunken -bd 3] -in .phRightF -anchor e -pady 3 -expand 1 -fill x

#Create Text left, limit width to 1/3
message .phMainM -textvar msg::f6Txt -font bpfont1 -width 500 -pady $py -padx $px
pack .phMainM -in .phLeftF -anchor nw -side left

#Build Photo bar right
button .phOpen -width 30 -textvar msg::f6Find -height 1 -command {
  #set fileJList [doOpen $DesktopPicturesDir .photosC]
openFileDialog $DesktopPicturesDir 
#TODO: monitor tk_getOpenFile & pass result to image list...?
}

button .ph< -text < -height 1 -command {step 0}
button .ph> -text > -height 1 -command {step 1}

#button .ph< -text < -height 1 -command {set fileJList [step $fileJList 1 .photosC]}
#button .ph> -text > -height 1 -command {set fileJList [step $fileJList 0 .photosC]}

button .phCollectBtn -textvar msg::f6Show -height 1 -command {
  set fileJList [doCollect .photosC]
}


#Pack bar
##Count pictures number & text labels packed later by doCollect)
label .phCountNum -textvar numPhotos -bg lightblue
label .phCountTxt -textvar msg::f6numPhotosTxt -bg lightblue
pack .phOpen .ph< .ph> -in .phBarF -side left

#Build Photo canvas right & export vars to ::canvpic
set imgCanv [canvas .photosC]
pack $imgCanv -in .phBildF -side left

namespace eval canvpic {
  variable imgCanv .photosC
  variable canvX ;#set later when GUI loaded
  variable canvY ;# ---
}

label .phPicpathL -textvar picPath
##these are packed later by doCollect
button .phAddBtn -textvar msg::f6Add -activebackground orange -command {addPic $::picPath}
button .phDelBtn -textvar msg::f6Del -activebackground red -command {delPic $imgCanv}
button .phRotateBtn -activebackground orange -textvar msg::rotatePic -command {source $::SetupRotate}

#Pic list of Photosdir for display of 1st pic
set picL [scanPicdir $photosdir]

