# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 25nov20 pv

#TODO Warum geht das nicht? Warum sourcet er Globals nicht?
#source $SetupResizeTools
#source $Globals
#source $env(HOME)/Biblepix/prog/src/setup/setupResizeTools.tcl

#TODO should these be called by another lowlevel prog?
source $::ScanColourArea
source $::AnnotatePng
  
# openResizeWindow
##opens new toplevel window if [needsResize]
##called by addPic
proc openResizeWindow {} {
  global fontsize

  #Copy addpicture::curPic to canvas
  image create photo resizeCanvPic
  if ![info exists addpicture::scaleFactor] {
    setPic2CanvScalefactor
  }
  resizeCanvPic copy $addpicture::curPic -subsample $addpicture::scaleFactor

  #Create toplevel window w/canvas & pic
  set w [toplevel .resizePhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  set c [canvas $w.resizeCanv -bg lightblue]
  $c create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}

  #Create title & buttons
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    NewsHandler::QueryNews "Bild nicht gespeichert" red
    #destroy .resizePhoto
    #namespace delete addpicture
  }
  set confirmBtnAction {
    doResize .resizePhoto.resizeCanv
    set ::Modal.Result "Success"
    #destroy .resizePhoto
    #namespace delete addpicture
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
  Show.Modal $w -destroy 1 -onclose $cancelBtnAction

} ;#END openResizeWindow

# openReposWindow
##opens new toplevel window if .resizePhoto doesn't exist
##called by addPic ?????????if ![needsResize]??????????????
proc openReposWindow {pic} {
  global fontsize
  image create photo reposCanvPic

  set w [toplevel .reposPhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  set c [canvas .reposPhoto.reposCanv -bg lightblue]
  $c create image 0 0 -image reposCanvPic -anchor nw -tags {img mv}
  pack $c

#Define button actions
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    NewsHandler::QueryNews "$::reposNotSaved" red
    file delete $addpicture::targetPicPath
    #namespace delete addpicture
    #destroy .reposPhoto
  }
  set confirmBtnAction {
    set ::Modal.Result "Success"

    lassign [.reposPhoto.reposCanv coords txt] x y
    processPngComment $addpicture::targetPicPath $x $y
    
    NewsHandler::QueryNews "$::reposSaved" lightgreen
    file delete $addpicture::targetPicPath
    #namespace delete addpicture
    #destroy .reposPhoto
  }

  #Create text button on top & disable
  set btn [button $w.moveTxtBtn -font {TkHeaderFont 20 bold} -fg red -pady 2 -padx 2]
  $btn conf -command $confirmBtnAction -bd 5 -relief raised -textvar textpos.wait
  pack $btn
  $c create window -15 15 -anchor nw -window $btn
  
  #Start scanning in background
  after idle {
#    colour::doColourScan
  }

  #Determine smallest possible scale factor for canvas pic
  if ![info exists addpicture::scaleFactor] {
    setPic2CanvScalefactor
  }
  reposCanvPic copy $pic -subsample $addpicture::scaleFactor

  #Set bindings
  $c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $c bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}

  set imgX [image width reposCanvPic]
  set imgY [image height reposCanvPic]
  $c conf -width $imgX -height $imgY

  #Creaste moving text  & disable for now
  createMovingTextBox $c
      
  lassign [fitPic2Canv $c] canvX canvY
puts "$canvX $canvY"
  
  #Configure text size
   set screenX [winfo screenwidth .]
   set fontfactor [expr $screenX / $imgX]
   set canvFontsize [expr round($::fontsize / $fontfactor)]
   font conf movingTextReposFont -size $canvFontsize
   
  bind $w <Return> $confirmBtnAction
  bind $w <Escape> $cancelBtnAction
  Show.Modal $w -destroy 1 -onclose $cancelBtnAction
  
} ;#END openReposWindow

#TODO warum hier?
#   processPngComment $addpicture::targetPicPath $x $y

