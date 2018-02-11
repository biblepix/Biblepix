# ~/Biblepix/prog/src/gui/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 10feb18

proc openResizeWindow {} {
  
  toplevel .dlg -bg lightblue -padx 20 -pady 20

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]

  #Create canvas with pic
  canvas .dlg.dlgCanv
  .dlg.dlgCanv create image 0 0 -image photosCanvPic -anchor nw -tags {img mv}

  #Create title & buttons
  set okButton {set ::Modal.Result [doResize .dlg.dlgCanv]}
  set cancelButton {set ::Modal.Result "Cancelled"}
  ttk::label .dlg.resizeLbl -text "$::movePicToResize" -font {TkHeadingFont 18} -background orange
  ttk::button .dlg.resizeConfirmBtn -text Ok -command $okButton
  ttk::button .dlg.resizeCancelBtn -textvar ::cancel -command $cancelButton
  
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
  
  .dlg.dlgCanv configure -width $canvCutX2 -height $canvCutY2 -bg lightblue -relief solid -borderwidth 2
  
  #Pack everything
  pack .dlg.resizeLbl
  pack .dlg.dlgCanv
  pack .dlg.resizeCancelBtn .dlg.resizeConfirmBtn -side right
  focus .dlg.resizeConfirmBtn
  
  #Set bindings
  bind .dlg <Return> $cancelButton
  bind .dlg <Escape> $cancelButton
 .dlg.dlgCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
 .dlg.dlgCanv bind mv <B1-Motion> [list dragCanvasItem %W mv %X %Y]
  
  Show.Modal .dlg -destroy 1 -onclose $cancelButton
} ;#END openResizeWindow
