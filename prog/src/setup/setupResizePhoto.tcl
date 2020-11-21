# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 21nov20 pv

#TODO Warum geht das nicht? Warum sourcet er Globals nicht?
#source $SetupResizeTools
#source $Globals
#source $env(HOME)/Biblepix/prog/src/setup/setupResizeTools.tcl

# openResizeWindow
##opens new toplevel window if [needsResize]
##called by addPic
proc openResizeWindow {} {
  global fontsize
  image create photo resizeCanvPic
  
  #Create toplevel window w/canvas & pic
  set w [toplevel .resizePhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  set c [canvas $w.resizeCanv -bg lightblue]
  $c create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}

  #Copy original pic to canvas

  #A) copy addpicture::curPic to canvas
  setPic2CanvScalefactor 
  resizeCanvPic copy $addpicture::curPic -subsample $addpicture::scaleFactor

  # P h a s e  1  (Resizing window)

  #Create title & buttons
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    destroy .resizePhoto
  }
  set confirmBtnAction {
    doResize .resizePhoto.resizeCanv
    openReposWindow
    set ::Modal.Result "Success"
    destroy .resizePhoto
  }

  ttk::button $w.confirmBtn -text Ok -command $confirmBtnAction
  ttk::button $w.cancelBtn -textvar ::cancel -command $cancelBtnAction
  pack $w.confirmBtn $w.cancelBtn ;#will be repacked into canv window
  set bildname [file tail $addpicture::targetPicPath]

  #Set cutting coordinates & configure canvas
  lassign [fitPic2Canv $c] cutX cutY
  $c conf -width $cutX -height $cutY

  $c create text 20 20 -anchor nw -justify center -font "TkCaptionFont 16 bold" -fill red -activefill yellow -text "$::movePicToResize" -tags text
  $c create window [expr $cutX - 150] 50 -anchor ne -window $w.confirmBtn -tag okbtn
  $c create window [expr $cutX - 80] 50 -anchor ne -window $w.cancelBtn -tag delbtn
  pack $c -side top -fill none

  #Set bindings
  $c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $c bind mv <B1-Motion> [list dragCanvasItem %W img %X %Y]
  bind $w <Return> $confirmBtnAction
  bind $w <Escape> $cancelBtnAction
  Show.Modal $w -destroy 0 -onclose $cancelBtnAction

} ;#END openResizeWindow

# openReposWindow
##opens new toplevel window if .resizePhoto doesn't exist
##called by addPic if ![needsResize]
proc openReposWindow {} {
  global fontsize
  image create photo reposCanvPic
  
  set w [toplevel .reposPhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  set c [canvas .reposPhoto.reposCanv -bg lightblue]
  $c create image 0 0 -image reposCanvPic -anchor nw -tags {img mv}
  pack $c
    
  #Determine smallest possible scale factor for canvas pic
  setPic2CanvScalefactor
  reposCanvPic copy $addpicture::curPic -subsample $addpicture::scaleFactor
  
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    file delete $addpicture::targetPicPath
    namespace delete addpicture
    destroy .reposPhoto
  }
  
  set confirmBtnAction {
    set ::Modal.Result "Success"
    processPngInfo .reposPhoto.reposCanv
    NewsHandler::QueryNews {Photo mit Positionsinfo abgespeichert.} lightgreen
    file delete $addpicture::targetPicPath
    namespace delete addpicture
    destroy .reposPhoto
  }
  
  #Create text button on top
  set btn [button $w.moveTxtBtn -font {TkHeaderFont 20 bold} -fg red -pady 2 -padx 2]
  $btn conf -command $confirmBtnAction -bd 5 -relief raised -textvar textpos.wait
  pack $btn
  $c create window -15 15 -anchor nw -window $btn -tags txtL

  #Set bindings
  $c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $c bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}

  set imgX [image width reposCanvPic]
  set imgY [image height reposCanvPic]
  $c conf -width $imgX -height $imgY
  createMovingTextBox $c
  lassign [fitPic2Canv $c] canvX canvY
puts "$canvX $canvY"
  
  #Configure text size
   set screenX [winfo screenwidth .]
   set fontfactor [expr $screenX / $imgX]
   set canvFontsize [expr round($::fontsize / $fontfactor)]
   font conf movingTextReposFont -size $canvFontsize
   
   
#TODO initiate Scan Image in background
#source $::ScanColourArea
#after idle colour::doColourScan
 #TODO das muss woanders hin
 #   $c itemconf mv txtL -state disabled

  bind $w <Return> $confirmBtnAction
  bind $w <Escape> $cancelBtnAction
  Show.Modal $w -destroy 0 -onclose $cancelBtnAction
  
} ;#END openReposWindow

# processPngInfo
##called by open resizeConfBtn (Phase 2)
proc processPngInfo {c} {

  source $::AnnotatePng
#  source $::ScanColourArea

  set w .reposPhoto
  set canvPic [lindex [$c itemcget img -image] end]
  set smallPic reposCanvSmallPic
  #Disable controls while reposCanvSmallPic is being processed


#  lassign [grabCanvSection $c] x1 y1 x2 y2
#  $smallPic copy $canvPic -subsample 3 -from $x1 $y1 $x2 $y2


  # 1. Scan colour area , compute real x1 + y1 * reductionFactor
  #source $::picdir/scanColourArea.tcl

  # lassign [scanColourArea $smallPic] x y luminance

  #reactivate button & text
  after 500 { 
    $::c itemconf mv -state normal
    $::w.confirmBtn conf -state normal
    $::w.moveTxtL conf -fg grey -font "TkHeaderFont 20 bold" -text "Verschieben Sie den Mustertext nach Wunsch und drücken Sie OK zum Speichern der Position!"
  }
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

  #destroy .resizePhoto .reposPhoto


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

    reposCanvPic copy $addpicture::curPic -subsample $addpicture::scaleFactor

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
  $w.moveTxtL conf -padx 10 -pady 10 -fg grey -font 18 -text "Warten Sie einen Augenblick, bis wir die ideale Textposition und -helligkeit berechnet haben..."

  #TODO? furnish real doColourScan!
  #after idle
  source $::picdir/scanColourArea.tcl
  colour::dummyColourScan $w

  $w.resizeConfirmBtn conf -state normal
  $c itemconf mv -state normal

} ;#END setupReposTextWin


#TODO move to setupTools / ImageTools / SetupResizeTools ???
namespace eval ResizeHandler {
 #TODO Joel export ist nicht nötig, wenn Prog mit namespace-Pfad aufgerufen wird
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
