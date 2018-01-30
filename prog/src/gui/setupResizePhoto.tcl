# ~/Biblepix/prog/src/gui/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 30jan18

proc openResizeWindow {} {
  global moveFrameToResize photosCanvMargin

  toplevel .dlg

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]

  canvas .dlg.dlgCanvas -width [expr $imgX + 2 * $photosCanvMargin] -height [expr $imgY + 2 * $photosCanvMargin]

  set okButton {set ::Modal.Result [doResize .dlg.dlgCanvas]}
  set cancelButton {set ::Modal.Result "Canceled"}
  
  #Create title & buttons
  ttk::label .dlg.resizeLbl -text "$moveFrameToResize" -font {TkHeadingFont 20}
  ttk::button .dlg.resizeConfirmBtn -text Ok -command $okButton
  ttk::button .dlg.resizeCancelBtn -textvar ::cancel -command $cancelButton
  
  .dlg.dlgCanvas create image $photosCanvMargin $photosCanvMargin -image photosCanvPic -anchor nw -tag img

  set factor [expr $imgX. / $screenX]

  if {[expr $imgY. / $factor] < $screenY} {
    set factor [expr $imgY. / $screenY]
  }

  ##set cutting coordinates for cutFrame
  set canvCutX2 [expr $screenX * $factor]
  set canvCutY2 [expr $screenY * $factor]

  # 2. Create AreaChooser with cutting coordinates
  createPhotoAreaChooser .dlg.dlgCanvas $canvCutX2 $canvCutY2

  pack .dlg.resizeLbl
  pack .dlg.dlgCanvas
  pack .dlg.resizeCancelBtn .dlg.resizeConfirmBtn -side right

  focus .dlg.resizeConfirmBtn
  bind .dlg <Return> $cancelButton
  bind .dlg <Escape> $cancelButton

  .dlg.dlgCanvas bind mv <1> {movestart %W %x %y}
  .dlg.dlgCanvas bind mv <B1-Motion> "move %W %x %y $imgX $imgY"
  
  Show.Modal .dlg -destroy 1 -onclose $cancelButton
}

#called by addPic
proc createPhotoAreaChooser {canv x2 y2} {
  global photosCanvMargin
  $canv create rectangle [expr $photosCanvMargin / 2] [expr $photosCanvMargin / 2] [expr $x2 + (1.5 * $photosCanvMargin)] [expr $y2 + (1.5 * $photosCanvMargin)] -tags {mv areaChooser}
  $canv itemconfigure areaChooser -outline red -activeoutline yellow -fill {} -width $photosCanvMargin
}

#Get current coordinates from PhotoAreaChooser
proc getAreaChooserCoords {c} {
  set imgCoords [$c bbox areaChooser]
  return $imgCoords
}