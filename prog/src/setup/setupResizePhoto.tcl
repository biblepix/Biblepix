# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 23apr20 pv

proc openResizeWindow {} {

  #Create toplevel window w/canvas & pic
  global fontsize
  toplevel .resizePhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600
  image create photo resizeCanvPic
  set c [canvas .resizePhoto.resizeCanv -bg lightblue]
  $c create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}

  #Check which original pic to use
  if [catch {image inuse rotateOrigPic}] {
    set origPic photosOrigPic
  } else {
    set origPic rotateOrigPic
  }

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width $origPic]
  set imgY [image height $origPic]

  #Display original pic in largest possible size
  set maxX [expr $screenX - 200]
  set maxY [expr $screenY - 200]
  ##Reduktionsfaktor ist Ganzzahl
  set reductionFactor 1
  while { $imgX >= $maxX && $imgY >= $maxY } {
    incr reductionFactor
    set imgX [expr $imgX / 2]
    set imgY [expr $imgY / 2]
  }

  #Copy original pic to canvas
  resizeCanvPic copy $origPic -subsample $reductionFactor
  set canvImgX [image width resizeCanvPic]
  set canvImgY [image height resizeCanvPic]
  
       
  # P h a s e  1  (Resizing window)

  #Create title & buttons
  set cancelButton {set ::Modal.Result "Cancelled"}
  
  ttk::button .resizePhoto.resizeConfirmBtn -text Ok
  ttk::button .resizePhoto.resizeCancelBtn -textvar ::cancel -command $cancelButton
  pack .resizePhoto.resizeConfirmBtn .resizePhoto.resizeCancelBtn ;#will be repacked into canv window

  set screenFactor [expr $screenX. / $screenY]
  set imgXYFactor [expr $imgX. / $imgY]
  
  #do Höhe schneiden - TODO this sucks when pic is correct size!!!!!!!!!!!!!!!!!!!
  if {$imgXYFactor < $screenFactor} {

    set canvCutX2 $canvImgX
    set canvCutY2 [expr round($canvImgX / $screenFactor)]

  } else {

    set canvCutX2 [expr round($canvImgY / $screenFactor)]
    set canvCutY2 $canvImgY
  }


  #Set cutting coordinates & configure canvas
  $c conf -width $canvCutX2 -height $canvCutY2
  $c create text 20 20 -anchor nw -justify center -font "TkCaptionFont 16 bold" -fill red -activefill yellow -text "$::movePicToResize" -tags text
  $c create window [expr $canvCutX2 - 150] 50 -anchor ne -window .resizePhoto.resizeConfirmBtn -tag okbtn
  $c create window [expr $canvCutX2 - 80] 50 -anchor ne -window .resizePhoto.resizeCancelBtn -tag delbtn
    
  pack $c -side top -fill none
  
  set canvX [lindex [$c conf -width ] end]
  set canvY [lindex [$c conf -height] end]
  
  
  
puts "$canvX $canvImgX $canvY $canvImgY"
  #Establish calculation factor for: a) font size of Canvas pic & 
  ## b) re-projection of canvas text position to Original pic
  ##eine Flanke muss identisch sein, das ist der korrekte Faktor
  set screen2canvFactor 1.5
  
  if {$canvX == $canvImgX} {
    set screen2canvFactor [expr $screenX. / $imgX]
  } elseif {$canvY == $canvImgY} {
    set screen2canvFactor [expr $screenY. / $imgY]
  }
  
  #Set bindings
  
  bind .resizePhoto <Escape> $cancelButton
  $c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $c bind mv <B1-Motion> [list dragCanvasItem %W img %X %Y]
  
  
  # P h a s e  2  (text repositioning Window)
  
  .resizePhoto.resizeConfirmBtn conf -command "reposTextWin $c $screen2canvFactor"
  bind .resizePhoto <Return> .resizePhoto.resizeConfirmBtn
    
  #TODO Joel help: close window later!
  Show.Modal .resizePhoto -destroy 0 -onclose $cancelButton

} ;#END openResizeWindow

proc reposTextWin {c screen2canvFactor} {
  global fontsize

  pack forget $c 
  pack forget .resizePhoto.resizeCancelBtn
  label .resizePhoto.verschiebenTxtL -font {TkHeaderFont 20 bold} -fg red -bg beige -pady 20 -bd 2 -relief sunken
  .resizePhoto.verschiebenTxtL conf -text "Verschieben Sie den Text nach Wunsch und drücken Sie OK zum Speichern der Position!"
  pack .resizePhoto.verschiebenTxtL -fill x 
  
  $c dtag img mv
  $c delete text
  $c delete delbtn
  pack $c
      
  createMovingTextBox $c
  font conf movingTextFont -size [expr round($fontsize / $screen2canvFactor)]
  $c bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}  

  .resizePhoto.resizeConfirmBtn conf -text Ok -command "processPngInfo $c" 
  

 
  set ::Modal.Result [doResize $c]
  
}

# processPngInfo
##called by open resizeConfBtn (Phase 2)
proc processPngInfo {c} {
  #TODO include new vars in Globals:
  set AnnotatePng $::picdir/annotatePng.tcl
  set ScanColourArea $::picdir/scanColourArea.tcl
  source $AnnotatePng   
  source $ScanColourArea
  
  lassign [$c bbox img] imgX1 imgY1 imgX2 imgY2
  #set canvX1 0
  #set canvY1 0
  set canvX [lindex [$c conf -width] end]
  set canvY [lindex [$c conf -height] end]
  
  
  #TODO move this to main proc!
  #Bildausschnitt berechnen
    
  ##Set Idealzustand: Bild == Canvas 
  set cutX1 0
  set cutY1 0
  set cutX2 $canvX
  set cutY2 $canvY
  
  ##Breite ungleich
  if {$imgX2 > $canvX} {
    ##nach links verschoben
    if {$imgX1 < 0} {
      set cutX1 [expr $imgX1 - ($imgX1 + $imgX1) ]
      set cutX2 [expr $imgX2 - $cutX1]
    ##nach rechts verschoben
    } else {
      set cutX1 0
      set cutX2 $canvX
    }
    
  ##Höhe ungleich
  } elseif {$imgY2 > $canvY} {
    ##nach oben verschoben
    if {$imgY1 < 0} {
      set cutY1 [expr $imgY1 - ($imgY1 + $imgY1) ]
      set cutY2 [expr $imgY2 - $cutY1]
    ##nach unten verschoben
    } else {
      set cutY1 0
      set cutY2 $canvY
    }
  
  ##Alles gleich      
  } else {
    puts "No need for resizing."
    Return 1
  }
  
  #Bild verkleinern zum raschen Berechnen
  image create photo resizeCanvSmallPic      
  resizeCanvSmallPic copy resizeCanvPic -subsample 2 -from $cutX1 $cutY1 $cutX2 $cutY2
  
  #  set x.y [scanColourArea photoCanvPicSmall]
  #TODO compute real x1 + y1 * (factor + 1) (for smallpic)
  
  #  set tint [computeAvBrightness photoCanvPicSmall]
  
  #TODO get filename
  #  processPngComment $file $x $y $tint

  destroy .resizePhoto
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
