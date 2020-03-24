# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 21mch20

proc openResizeWindow {} {


  toplevel .resizePhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width photosOrigPic]
  set imgY [image height photosOrigPic]

  image create photo resizePic

  #Display original pic in largest possible size
  #TODO either avoid too big size for buttons to hide, OR ELIMINATE BUTTONS!
  set maxX [expr $screenX - 200]
  set maxY [expr $screenY - 200]
  
  set reductionFactor 1
  while { $imgX >= $maxX && $imgY >= $maxY } {
    incr reductionFactor
    set imgX [expr $imgX / 2]
    set imgY [expr $imgY / 2]
  }

  resizePic copy photosOrigPic -subsample $reductionFactor

  #Create canvas with pic
  canvas .resizePhoto.resizePhotoCanv
  .resizePhoto.resizePhotoCanv create image 0 0 -image resizePic -anchor nw -tags {img mv}

  #Create title & buttons
  set okButton {set ::Modal.Result [doResize .resizePhoto.resizePhotoCanv]}
  set cancelButton {set ::Modal.Result "Cancelled"}
  
#  ttk::label .resizePhoto.resizeLbl -text "$::movePicToResize" -font {TkHeadingFont 18} -background orange
  ttk::button .resizePhoto.resizeConfirmBtn -text Ok -command $okButton
  ttk::button .resizePhoto.resizeCancelBtn -textvar ::cancel -command $cancelButton
  pack .resizePhoto.resizeConfirmBtn .resizePhoto.resizeCancelBtn ;#will be repacked into canv window
  
  #Set scale factor
  set factor [expr $imgX. / $screenX]
  if {[expr $imgY. / $factor] < $screenY} {
    set factor [expr $imgY. / $screenY]
  }
  
  #Set cutting coordinates & configure canvas
  set canvCutX2 [expr $screenX * $factor]
  set canvCutY2 [expr $screenY * $factor]
  
  .resizePhoto.resizePhotoCanv conf -width $canvCutX2 -height $canvCutY2 -bg lightblue -relief solid -borderwidth 2
  .resizePhoto.resizePhotoCanv create text 20 20 -anchor nw -justify center -font "TkCaptionFont 16 bold" -fill red -text "$::movePicToResize"
  .resizePhoto.resizePhotoCanv create window [expr $canvCutX2 - 150] 50 -anchor ne -window .resizePhoto.resizeConfirmBtn
  .resizePhoto.resizePhotoCanv create window [expr $canvCutX2 - 80] 50 -anchor ne -window .resizePhoto.resizeCancelBtn
  
  #[expr [winfo width .resizePhoto.resizePhotoCanv] - 500]
  #Pack everything
 # pack .resizePhoto.resizeLbl
 # pack .resizePhoto.resizeConfirmBtn -side bottom -fill x
  pack .resizePhoto.resizePhotoCanv -side top -fill none
#  pack .resizePhoto.resizeCancelBtn .resizePhoto.resizeConfirmBtn -side right -expand 1
#
#  focus .resizePhoto.resizeConfirmBtn
  
  #Set bindings
  bind .resizePhoto <Return> $okButton
  bind .resizePhoto <Escape> $cancelButton
 .resizePhoto.resizePhotoCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
 
 .resizePhoto.resizePhotoCanv bind mv <B1-Motion> [list dragCanvasItem %W mv %X %Y]
  
  Show.Modal .resizePhoto -destroy 1 -onclose $cancelButton
} ;#END openResizeWindow



namespace eval ResizeHandler {
  namespace export QueryResize
  namespace export Run

  variable queryCutImgJList ""
  variable counter 0
  variable isRunning 0

  proc QueryResize {cutImg} {
    variable queryCutImgJList
    variable counter

    set queryCutImgJList [jappend $queryCutImgJList $cutImg]

    incr counter
  }

  proc Run {} {
    variable queryCutImgJList
    variable counter
    variable isRunning

    if {$counter > 0} {
      if {!$isRunning} {
        set isRunning 1

        set cutImg [jlfirst $queryCutImgJList]
        set queryCutImgJList [jlremovefirst $queryCutImgJList]

        incr counter -1

        processResize $cutImg

        ResizeHandler::FinishRun
      }
    }
  }

  proc FinishRun {} {
    variable isRunning

    set isRunning 0

    ResizeHandler::Run
  }
}
