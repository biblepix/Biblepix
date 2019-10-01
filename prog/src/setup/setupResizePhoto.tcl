# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15may19

proc openResizeWindow {} {
  
  toplevel .resizePhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]

  #Create canvas with pic
  canvas .resizePhoto.resizePhotoCanv
  .resizePhoto.resizePhotoCanv create image 0 0 -image photosCanvPic -anchor nw -tags {img mv}

  #Create title & buttons
  set okButton {set ::Modal.Result [doResize .resizePhoto.resizePhotoCanv]}
  set cancelButton {set ::Modal.Result "Cancelled"}
  ttk::label .resizePhoto.resizeLbl -text "$::movePicToResize" -font {TkHeadingFont 18} -background orange
  ttk::button .resizePhoto.resizeConfirmBtn -text Ok -command $okButton
  ttk::button .resizePhoto.resizeCancelBtn -textvar ::cancel -command $cancelButton
  
  #Set pic factor
  set factor [expr $imgX. / $screenX]
  if {[expr $imgY. / $factor] < $screenY} {
    set factor [expr $imgY. / $screenY]
  }

  #SET SCREENFACTOR - schon da!!!
  set screenFactor [expr $screenY. / $screenX]
  
  
  #Set cutting coordinates & configure canvas
  #set canvCutX2 [expr $screenX * $factor]
  #set canvCutY2 [expr $screenY * $factor]
  
#TODO: falsch BERECHTNET:
  set canvCutX2 [expr $screenX * $factor]
  set canvCutY2 [expr $screenY * $factor]
  
  .resizePhoto.resizePhotoCanv configure -width $canvCutX2 -height $canvCutY2 -bg lightblue -relief solid -borderwidth 2
  
  #Pack everything
  pack .resizePhoto.resizeLbl
  pack .resizePhoto.resizePhotoCanv
  pack .resizePhoto.resizeCancelBtn .resizePhoto.resizeConfirmBtn -side right
  focus .resizePhoto.resizeConfirmBtn
  
  #Set bindings
  bind .resizePhoto <Return> $cancelButton
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

  variable queryOrigXJList ""
  variable queryOrigYJList ""
  variable queryImgXJList ""
  variable queryImgYJList ""
  variable queryCanvXJList ""
  variable queryCanvYJList ""
  variable queryCanvPicX1JList ""
  variable queryCanvPicY1JList ""
  variable queryCanvPicX2JList ""
  variable queryCanvPicY2JList ""
  variable counter 0
  variable isRunning 0

  proc QueryResize {origX origY imgX imgY canvX canvY canvPicX1 canvPicY1 canvPicX2 canvPicY2} {
    variable queryOrigXJList
    variable queryOrigYJList
    variable queryImgXJList
    variable queryImgYJList
    variable queryCanvXJList
    variable queryCanvYJList
    variable queryCanvPicX1JList
    variable queryCanvPicY1JList
    variable queryCanvPicX2JList
    variable queryCanvPicY2JList
    variable counter

    set queryOrigXJList [jappend $queryOrigXJList $origX]
    set queryOrigYJList [jappend $queryOrigYJList $origY]
    set queryImgXJList [jappend $queryImgXJList $imgX]
    set queryImgYJList [jappend $queryImgYJList $imgY]
    set queryCanvXJList [jappend $queryCanvXJList $canvX]
    set queryCanvYJList [jappend $queryCanvYJList $canvY]
    set queryCanvPicX1JList [jappend $queryCanvPicX1JList $canvPicX1]
    set queryCanvPicY1JList [jappend $queryCanvPicY1JList $canvPicY1]
    set queryCanvPicX2JList [jappend $queryCanvPicX2JList $canvPicX2]
    set queryCanvPicY2JList [jappend $queryCanvPicY2JList $canvPicY2]

    incr counter
  }

  proc Run {} {
    variable queryOrigXJList
    variable queryOrigYJList
    variable queryImgXJList
    variable queryImgYJList
    variable queryCanvXJList
    variable queryCanvYJList
    variable queryCanvPicX1JList
    variable queryCanvPicY1JList
    variable queryCanvPicX2JList
    variable queryCanvPicY2JList
    variable counter
    variable isRunning

    if {$counter > 0} {
      if {!$isRunning} {
        set isRunning 1

        set origX [jlfirst $queryOrigXJList]
        set queryOrigXJList [jlremovefirst $queryOrigXJList]

        set origY [jlfirst $queryOrigYJList]
        set queryOrigYJList [jlremovefirst $queryOrigYJList]

        set imgX [jlfirst $queryImgXJList]
        set queryImgXJList [jlremovefirst $queryImgXJList]

        set imgY [jlfirst $queryImgYJList]
        set queryImgYJList [jlremovefirst $queryImgYJList]

        set canvX [jlfirst $queryCanvXJList]
        set queryCanvXJList [jlremovefirst $queryCanvXJList]

        set canvY [jlfirst $queryCanvYJList]
        set queryCanvYJList [jlremovefirst $queryCanvYJList]

        set canvPicX1 [jlfirst $queryCanvPicX1JList]
        set queryCanvPicX1JList [jlremovefirst $queryCanvPicX1JList]

        set canvPicY1 [jlfirst $queryCanvPicY1JList]
        set queryCanvPicY1JList [jlremovefirst $queryCanvPicY1JList]

        set canvPicX2 [jlfirst $queryCanvPicX2JList]
        set queryCanvPicX2JList [jlremovefirst $queryCanvPicX2JList]

        set canvPicY2 [jlfirst $queryCanvPicY2JList]
        set queryCanvPicY2JList [jlremovefirst $queryCanvPicY2JList]

        incr counter -1

        processResize $origX $origY $imgX $imgY $canvX $canvY $canvPicX1 $canvPicY1 $canvPicX2 $canvPicY2

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
