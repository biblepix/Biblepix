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
