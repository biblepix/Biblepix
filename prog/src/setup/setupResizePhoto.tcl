# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 28apr20 pv

proc openResizeWindow {targetPicPath} {

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
  set ::reductionFactor $reductionFactor
  
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
  


  #TODO Establish calculation factor for: a) font size of Canvas pic & 
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
  
  .resizePhoto.resizeConfirmBtn conf -command "setupReposTextWin $c $screen2canvFactor $targetPicPath"
  bind .resizePhoto <Return> .resizePhoto.resizeConfirmBtn
    
  #TODO Joel help: close window later!
  Show.Modal .resizePhoto -destroy 0 -onclose $cancelButton

} ;#END openResizeWindow

# openReposWindow
##opens new toplevel window if .resizePhoto doesn't exist
##called by addPic if ![needsResize]
proc openReposWindow {targetPicPath} {
  global fontsize
  toplevel .reposPhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600
  image create photo reposCanvPic
  set c [canvas .reposPhoto.reposCanv -bg lightblue]
  $c create image 0 0 -image reposCanvPic -anchor nw -tags {img mv}

  #Check which original pic to use
  if [catch {image inuse rotateOrigPic}] {
    set origPic photosOrigPic
  } else {
    set origPic rotateOrigPic
  }

  
...
?recalculate screen2canvasFactor?
...
#Redraw window
setupReposTextWin $c $screen2canvFactor $targetPicPath

#process & save
processPngInfo $c $targetPicPath


#Redraw text & button
$w.confirmBtn conf -state normal
$w.moveTxtL conf -text "Verschieben Sie den Text nach Wunsch und drücken Sie OK zum Speichern der Position und Helligkeit."

} ;#END openReposWindow

# setupReposTextWin
##either redraws existing window or creates one 
##called by openResizeWindow & openReposWindow
proc setupReposTextWin {c screen2canvFactor targetPicPath} {
  global fontsize

  if {$c == ".resizePhoto.resizeCanv"} {
    set w .resizePhoto
    pack forget $c 
    pack forget $w.resizeCancelBtn
    $c dtag img mv
    $c delete text
    $c delete delbtn

  } else {set w .reposPhoto}
  
  label $w.moveTxtL -font {TkHeaderFont 20 bold} -fg red -bg beige -pady 20 -bd 2 -relief sunken
  $w.moveTxtL conf -text "Verschieben Sie den Mustertext nach Wunsch und drücken Sie OK zum Speichern der Position!"
  pack $w.moveTxtL -fill x 
  pack $c
       
  createMovingTextBox $c
  font conf movingTextFont -size [expr round($fontsize / $screen2canvFactor)]
  $c bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}  

  catch {button $w.resizeConfirmBtn}
  $w.resizeConfirmBtn conf -text Ok -command "processPngInfo $c $targetPicPath" 
  
  set ::Modal.Result [doResize $c]  
  
  

} ;#END setupReposTextWin

# processPngInfo
##called by open resizeConfBtn (Phase 2)
proc processPngInfo {c targetPicPath} {

  #TODO include new vars in Globals:
  set AnnotatePng $::picdir/annotatePng.tcl
  set ScanColourArea $::picdir/scanColourArea.tcl
  source $AnnotatePng   
  source $ScanColourArea
  
  set w .reposPhoto
  set canvPic [lindex [$c itemcget img -image] end]
  set smallPic reposCanvSmallPic 
  #Disable controls while reposCanvSmallPic is being processed
  
  $c itemconf mv -state disabled
  $w.resizeConfirmBtn conf -state disabled
  $w.moveTxtL conf -fg grey -font 18 -text "Warten Sie einen Augenblick, bis wir die ideale Textposition und -helligkeit berechnet haben..." 

  #Bild verkleinern zum raschen Berechnen
  image create photo $smallPic
  #resizeCanvSmallPic copy cutOrigPic -subsample [incr ::reductionFactor] 
  #OR?
 # b) 
  lassign [cutCanvasPic $c] x1 y1 x2 y2
  $smallPic copy $canvPic -subsample 3 -from $x1 $y1 $x2 $y2 
   
  
  # 1. Scan colour area , compute real x1 + y1 * reductionFactor
  #source $::picdir/scanColourArea.tcl
  
  # lassign [scanColourArea $smallPic] x y luminance

  #reactivate button & text
  after idle
  $c itemconf mv -state normal
  $w.resizeConfirmBtn conf -state normal
  $w.moveTxtL conf -fg grey -font "TkHeaderFont 20 bold" -text "Verschieben Sie den Mustertext nach Wunsch und drücken Sie OK zum Speichern der Position!" 
  
  if {!$x} {
    set x $marginleft
    set y $margintop          
  } else {
    lassign textPos x y
    $c move text $x $y
    
  }
    
     
  # 2. writePngComment $targetPicPath $x $y $luminance
  #TODO recompute correct x + y by using all factors!!!!    
    set x [expr $x * $::reductionFactor]
    set y [expr $y * $::reductionFactor]
    
  
  #   ? NewsHandler::QueryNews "[copiedPicMsg $targetPicPath]" lightblue
 
  destroy .resizePhoto .reposPhoto
    
    
} ;#END processPngInfo


# cutCanvPic
##berechnet reposCanvPic Bildausschnitt für Kopieren nach reposCanvSmallPic
##called by processPngInfo
proc cutCanvasPic {c} { 
  
  lassign [$c bbox img] imgX1 imgY1 imgX2 imgY2

  set canvX [lindex [$c conf -width] end]
  set canvY [lindex [$c conf -height] end]

  set cutX1 0
  set cutY1 0
  set cutX2 $canvX
  set cutY2 $canvY
  
  ##alles gleich
  if {$imgX2 == $canvX &&
      $imgY2 == $canvY
  } {
    puts "No need for resizing."
    Return 0
  }
  

  ##Breite ungleich
  if {$imgX2 > $canvX} {
  
    puts "Breite verschieben"
    if {$imgX1 < 0} {
      set cutX1 [expr $imgX1 - ($imgX1 + $imgX1) ]
      set cutX2 [expr $canvX + $cutX1]

    ##nach rechts verschoben
    } else {
      set cutX1 0
      set cutX2 $canvX
    }
    
  ##Höhe ungleich
  } elseif {$imgY2 > $canvY} {
  
    puts "Höhe verschieben"
    if {$imgY1 < 0} {
      set cutY1 [expr $imgY1 - ($imgY1 + $imgY1) ]
      set cutY2 [expr $canvY + $cutY1]

    ##nach unten verschoben
    } else {
      set cutY1 0
      set cutY2 $canvY
    }
  
  }
  
  return "$cutX1 $cutY1 $cutX2 $cutY2"
  
  
} ;#END cutCanvPic

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
