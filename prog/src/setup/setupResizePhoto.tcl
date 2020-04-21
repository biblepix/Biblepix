# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 20apr20 pv

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
  set c [canvas .resizePhoto.resizeCanv -bg lightblue]
  $c create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}
  
  #Create title & buttons
  set cancelButton {set ::Modal.Result "Cancelled"}
  
  #1. Schritt
  set okButton "
    createMovingTextBox $c
    font conf movingTextFont -size $::fontsize
    #$c itemconf addtag img mv
    $c dtag img mv
    $c bind mv <B1-Motion> ;# [list dragCanvasItem %W canvTxt %X %Y]
    $c itemconf text -fill orange -text {Verschieben sie den Text nach Wunsch und drücken Sie OK zum Speichern der Position}
    $c raise text
     
    .resizePhoto.resizeConfirmBtn conf -text Ok -command {
      #annotatePng
      destroy .resizePhoto
      } 
    $c dtag img mv
   
    #TODO threading nötig?
    #.resizePhoto.resizeCanv move ?  -set coords {scanArea resizeCanvPic} - TODO nur beschnittenes Bild!
    
    set ::Modal.Result [doResize $c]
  "
  
  #2. Schritt
  ttk::button .resizePhoto.resizeConfirmBtn -text Ok -command $okButton 
  ttk::button .resizePhoto.resizeCancelBtn -textvar ::cancel -command $cancelButton
    
  pack .resizePhoto.resizeConfirmBtn .resizePhoto.resizeCancelBtn ;#will be repacked into canv window

  set screenFactor [expr $screenX. / $screenY]
  set imgXYFactor [expr $imgX. / $imgY]
  set canvImgX [image width resizeCanvPic]
  set canvImgY [image height resizeCanvPic]

  #do Höhe schneiden - TODO this sucks when pic is correct size!!!!!!!!!!!!!!!!!!!
  if {$imgXYFactor < $screenFactor} {
#puts Höheschneiden
    set canvCutX2 $canvImgX
    set canvCutY2 [expr round($canvImgX / $screenFactor)]

  } else {
#puts Tiefeschneiden
    set canvCutX2 [expr round($canvImgY / $screenFactor)]
    set canvCutY2 $canvImgY
  }

  #Set cutting coordinates & configure canvas
  .resizePhoto.resizeCanv conf -width $canvCutX2 -height $canvCutY2 -bg lightblue -bd 0
  .resizePhoto.resizeCanv create text 20 20 -anchor nw -justify center -font "TkCaptionFont 16 bold" -fill red -activefill green -text "$::movePicToResize" -tags text
  .resizePhoto.resizeCanv create window [expr $canvCutX2 - 150] 50 -anchor ne -window .resizePhoto.resizeConfirmBtn
  .resizePhoto.resizeCanv create window [expr $canvCutX2 - 80] 50 -anchor ne -window .resizePhoto.resizeCancelBtn
  
  pack .resizePhoto.resizeCanv -side top -fill none
  
  #Set bindings
  bind .resizePhoto <Return> $okButton
  bind .resizePhoto <Escape> $cancelButton
  $c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $c bind mv <B1-Motion> [list dragCanvasItem %W img %X %Y]
  #$c bind mv <B1-Motion> [list dragCanvasItem %W canvTxt %X %Y]
  
 #TODO  close window later!
#  Show.Modal .resizePhoto -destroy 1 -onclose $cancelButton
  Show.Modal .resizePhoto -destroy 0 -onclose $cancelButton
  
} ;#END openResizeWindow


#wird bei OK in resizeWin ZUERST aktiviert
#c = .resizePhoto.resizeCanv
proc copyCutPic {c} {
  global fontcolor

  lassign [$c bbox img] x1 y1 x2 y2
  textposCanvPic blank
  textposCanvPic copy resizeCanvPic -from $x1 $y1 $x2 $y2 -subsample 2

  createMovingTextBox $c
  $c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
#  button .reposOKBtn -text "Abspeichern" -command {}
#  pack .reposOKBtn
#  $c create window 300 500 -window .reposOKBtn 

#TODO move
  tk_messageBox -type ok -message "Sie haben 5 Sekunden, um die vorgeschlagene Textposition zu verändern.\nDanach werden die Daten automatisch gespeichert."
  
  set sec 0
  while {$sec < 6000} {
    after 700
    $c itemconf txt -fill red
    after 300
    $c itemconf txt -fill $fontcolor
    incr sec 1000
  }

  annotatePng cutOrigPic 
}

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
