# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 19apr20 pv

proc openResizeWindow {} {

  toplevel .resizePhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600

  #Check which original to use
  if [catch {image inuse rotateOrigPic}] {
    set origPic photosOrigPic
  } else {
    set origPic rotateOrigPic
  }

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width $origPic]
  set imgY [image height $origPic]

  image create photo resizeCanvPic

  #Display original pic in largest possible size
  set maxX [expr $screenX - 200]
  set maxY [expr $screenY - 200]
  
  set reductionFactor 1
  while { $imgX >= $maxX && $imgY >= $maxY } {
    incr reductionFactor
    set imgX [expr $imgX / 2]
    set imgY [expr $imgY / 2]
  }

#puts $reductionFactor

  resizeCanvPic copy $origPic -subsample $reductionFactor

  #Create canvas with pic
  canvas .resizePhoto.resizePhotoCanv -bg lightblue
  .resizePhoto.resizePhotoCanv create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}

  #Create title & buttons
  set okButton {set ::Modal.Result [doResize .resizePhoto.resizePhotoCanv]}
  set cancelButton {set ::Modal.Result "Cancelled"}
  
  ttk::button .resizePhoto.resizeConfirmBtn -text Ok -command $okButton
  ttk::button .resizePhoto.resizeCancelBtn -textvar ::cancel -command $cancelButton
  pack .resizePhoto.resizeConfirmBtn .resizePhoto.resizeCancelBtn ;#will be repacked into canv window


  
  #Set scale factor
#  set factor [expr $imgX. / $screenX]
#  if {[expr $imgY. / $factor] < $screenY} {
#    set factor [expr $imgY. / $screenY]
#  }
#puts $factor

  set screenFactor [expr $screenX. / $screenY]
  set imgXYFactor [expr $imgX. / $imgY]
  set canvImgX [image width resizeCanvPic]
  set canvImgY [image height resizeCanvPic]

  #do Höhe schneiden
  if {$imgXYFactor < $screenFactor} {
puts Höheschneiden
    set canvCutX2 $canvImgX
    set canvCutY2 [expr round($canvImgX / $screenFactor)]

  } else {
puts Tiefeschneiden
    set canvCutX2 [expr round($canvImgY / $screenFactor)]
    set canvCutY2 $canvImgY
  }


#puts $imgXYFactor
#puts $screenFactor

  #Set cutting coordinates & configure canvas
  .resizePhoto.resizePhotoCanv conf -width $canvCutX2 -height $canvCutY2 -bg lightblue -bd 0
  .resizePhoto.resizePhotoCanv create text 20 20 -anchor nw -justify center -font "TkCaptionFont 16 bold" -fill red -activefill green -text "$::movePicToResize"
  .resizePhoto.resizePhotoCanv create window [expr $canvCutX2 - 150] 50 -anchor ne -window .resizePhoto.resizeConfirmBtn
  .resizePhoto.resizePhotoCanv create window [expr $canvCutX2 - 80] 50 -anchor ne -window .resizePhoto.resizeCancelBtn
  
  pack .resizePhoto.resizePhotoCanv -side top -fill none
  
  #Set bindings
  bind .resizePhoto <Return> $okButton
  bind .resizePhoto <Escape> $cancelButton
 .resizePhoto.resizePhotoCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
 
 #Run dragging canvasItem
 set margin 0
 set itemW 0
 .resizePhoto.resizePhotoCanv bind mv <B1-Motion> [list dragCanvasItem %W img %X %Y]
  
  Show.Modal .resizePhoto -destroy 1 -onclose $cancelButton

} ;#END openResizeWindow


namespace eval ResizeHandler {
  namespace export QueryResize
  namespace export Run

  variable queryCutImgJList ""
  variable counter 0
  variable isRunning 0

#TODO Joel was läuft hier falsch?
#Das Problem ist, dass 'cutImg' nicht resizePhoto (das Bild vom Resize-Canvas), sondern photosOrigPic sein muss.
#set cutImg photosOrigPic

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
