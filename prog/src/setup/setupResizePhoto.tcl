 # ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 30may20 pv

proc openResizeWindow {} {
  global fontsize
  
  #Create toplevel window w/canvas & pic
  set w [toplevel .resizePhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  set c [canvas $w.resizeCanv -bg lightblue]
  image create photo resizeCanvPic
  $c create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}
  
  #Copy original pic to canvas
  #Determine smallest possible scale factor for canvas pic
  setPic2CanvScalefactor
  resizeCanvPic copy $addpicture::origPic -subsample $addpicture::scaleFactor
       
  # P h a s e  1  (Resizing window)

  #Create title & buttons
  set cancelButton {set ::Modal.Result "Cancelled"}
  set confirmButton {set ::Modal.Result "doResize $c ; destroy .resizePhoto"}
  
  ttk::button .resizePhoto.resizeConfirmBtn -text Ok -command $confirmButton
  ttk::button .resizePhoto.resizeCancelBtn -textvar ::cancel -command $cancelButton
  pack .resizePhoto.resizeConfirmBtn .resizePhoto.resizeCancelBtn ;#will be repacked into canv window

  set bildname [file tail $addpicture::targetPicPath]

  #Set cutting coordinates & configure canvas
  lassign [fitPic2Canv $c] cutX cutY
  $c conf -width $cutX -height $cutY

  $c create text 20 20 -anchor nw -justify center -font "TkCaptionFont 16 bold" -fill red -activefill yellow -text "$::movePicToResize" -tags text
  $c create window [expr $cutX - 150] 50 -anchor ne -window .resizePhoto.resizeConfirmBtn -tag okbtn
  $c create window [expr $cutX - 80] 50 -anchor ne -window .resizePhoto.resizeCancelBtn -tag delbtn
  pack $c -side top -fill none
 
  #Set bindings
  bind .resizePhoto <Escape> $cancelButton
  $c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $c bind mv <B1-Motion> [list dragCanvasItem %W img %X %Y]
  
  # P h a s e  2  (text repositioning Window)
  
  #Confirm button launches doResize & sets up repositioning window
  .resizePhoto.resizeConfirmBtn conf -command "
    set ::Modal.Result [doResize $c]

#TODO adapt!!!!!!!!!!!!!!!!!!!

    openReposWindow
  "
  
  bind .resizePhoto <Return> .resizePhoto.resizeConfirmBtn
    
  #TODO Joel help: close window later!
  Show.Modal .resizePhoto -destroy 1 -onclose $cancelButton

} ;#END openResizeWindow

# openReposWindow
##opens new toplevel window if .resizePhoto doesn't exist
##called by addPic if ![needsResize]
proc openReposWindow {} {
  global fontsize
  set w [toplevel .reposPhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  image create photo reposCanvPic

  set c [canvas .reposPhoto.reposCanv -bg lightblue]
  $c create image 0 0 -image reposCanvPic -anchor nw -tags {img mv}
  createMovingTextBox $c
  
  #Determine smallest possible scale factor for canvas pic
  setPic2CanvScalefactor

  label $w.moveTxtL -font {TkHeaderFont 20 bold} -fg red -bg beige -pady 20 -bd 2 -relief sunken 
  
  $w.moveTxtL conf -fg grey -font 18 -text "Warten Sie einen Augenblick, bis wir die ideale Textposition und -helligkeit berechnet haben..." 
  pack $w.moveTxtL -fill x 
  pack $c

  #Create OK button only!
  button $w.confirmBtn -text OK -command "processPngInfo $c"
  #TODO make $c window instead + put on top
    pack $w.confirmBtn -side right

       
  
    #Set bindings
    $c bind mv <1> {
       set ::x %X
       set ::y %Y
    }
    $c bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}  
    
  #Copy origPic to reposCanv if resizeCanv wasn't opened
  if [catch {image inuse resizeCanvPic}] {

    reposCanvPic copy $addpicture::origPic -subsample $addpicture::scaleFactor
      
  #Copy origPic to reposCanv if resizeCanv wasn't opened
  } else {
    
     reposCanvPic copy $addpicture::origPic -subsample $addpicture::scaleFactor
  }

#TODO was läuft hier? what if resizing is not needed?
    lassign [fitPic2Canv $c] cutX cutY
    $c conf -width $cutX -height $cutY
      
  #TODO geht nicht! Determine moving text font size
  set imgX [image width reposCanvPic]
  set screenX [winfo screenwidth .]
  set fontfactor [expr $screenX / $imgX]
  set canvFontsize [expr round($::fontsize / $fontfactor)]
  font conf movingTextReposFont -size $canvFontsize
  
  #Scan Image
  source $::picdir/scanColourArea.tcl
  colour::dummyColourScan $w
  
  $w.confirmBtn conf -state normal
  $c itemconf mv -state normal
  #TODO do we want these here?
  #$c itemconf mv -state disabled
  #$w.confirmBtn conf -state disabled
  
} ;#END openReposWindow

# processPngInfo
##called by open resizeConfBtn (Phase 2)
proc processPngInfo {c} {

  #TODO include new vars in Globals:
  set AnnotatePng $::picdir/annotatePng.tcl
  set ScanColourArea $::picdir/scanColourArea.tcl
  source $AnnotatePng
  source $ScanColourArea
  
  set w .reposPhoto
  set canvPic [lindex [$c itemcget img -image] end]
  set smallPic reposCanvSmallPic
  #Disable controls while reposCanvSmallPic is being processed
  
  #TODO moved to setupRepos!!!
  $c itemconf mv -state disabled
  $w.resizeConfirmBtn conf -state disabled
  
#  lassign [grabCanvSection $c] x1 y1 x2 y2
#  $smallPic copy $canvPic -subsample 3 -from $x1 $y1 $x2 $y2 
   
  
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
  #  set x [expr $x * $::reductionFactor]
  #  set y [expr $y * $::reductionFactor]
    
  
  #   ? NewsHandler::QueryNews "[copiedPicMsg $targetPicPath]" lightblue
 
  destroy .resizePhoto .reposPhoto
    
    
} ;#END processPngInfo





#TODO OBSOLETE, s.a. - take goodies & scrap!
# setupReposTextWin
##either redraws existing window or creates one 
##called by openResizeWindow & openReposWindow
proc setupReposTextWin {c} {
  global fontsize
   
  if {$c == ".resizePhoto.resizeCanv"} {
    set w .resizePhoto
    pack forget $c 
    pack forget $w.resizeCancelBtn
    $c dtag img mv
    $c delete text
    $c delete delbtn

  } else {
    set w .reposPhoto
  }
  
  #Text is set later
  label $w.moveTxtL -font {TkHeaderFont 20 bold} -fg red -bg beige -pady 20 -bd 2 -relief sunken 
  pack $w.moveTxtL -fill x 
  pack $c
  

  
  #Copy origPic to reposCanv if resizeCanv wasn't opened
  if [catch {image inuse resizeCanvPic}] {
    
    reposCanvPic copy $addpicture::origPic -subsample $addpicture::scaleFactor
    
    #TODO was läuft hier? what if resizing is not needed?
    lassign [fitPic2Canv $c] cutX cutY
    $c conf -width $cutX -height $cutY
    
    #Set bindings
    $c bind mv <1> {
       set ::x %X
       set ::y %Y
    }
    #  bind $w <Escape> $cancelButton
    $c bind mv <B1-Motion> [list dragCanvasItem %W img %X %Y]
    button $w.confirmBtn -text OK -command "processPngInfo $c"
    pack $w.confirmBtn -side right
  }
       
  createMovingTextBox $c
  
  #determine proportional font size
  set faktor [expr $screenX / $imgX]
  font conf movingTextReposFont -size [expr round($fontsize / $addpicture::scaleFactor) + 5]
  $c bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}  

  catch {button $w.resizeConfirmBtn}
  $w.resizeConfirmBtn conf -state normal -text Ok -command "processPngInfo $c" 
  
  $c itemconf mv -state disabled
  $w.resizeConfirmBtn conf -state disabled
  $w.moveTxtL conf -fg grey -font 18 -text "Warten Sie einen Augenblick, bis wir die ideale Textposition und -helligkeit berechnet haben..." 
  
  #TODO? furnish real doColourScan!
  #after idle 
  source $::picdir/scanColourArea.tcl
  colour::dummyColourScan $w
  
  $w.resizeConfirmBtn conf -state normal
  $c itemconf mv -state normal
  
} ;#END setupReposTextWin



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
