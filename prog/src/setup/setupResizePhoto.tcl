# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 2feb21 pv

source $::AnnotatePng
  
# openResizeWindow
##opens new toplevel window if [needsResize]
##called by addPic
proc openResizeWindow {} {
  tk_messageBox -type ok -message $::movePicToResize
  global fontsize
  set margin 10
  namespace eval resizePic {}

  #Copy addpicture::curPic to canvas
  set resizePic::resizeCanvPic [image create photo]
  set resizePic::scaleFactor [getResizeScalefactor]
  $resizePic::resizeCanvPic copy $addpicture::curPic -subsample $resizePic::scaleFactor

  lassign [getCanvSizeFromPic $resizePic::resizeCanvPic] canvX canvY
  set winX [expr $canvX + 2*$margin]
  set winY [expr $canvY + 2*$margin]

  #Create toplevel window w/canvas & pic
  set w [toplevel .resizePhoto -bg lightblue -padx $margin -pady $margin -height $winX -width $winY]
  set resizePic::c [canvas $w.resizeCanv -bg lightblue -height $canvY -width $canvX]
  $resizePic::c create image 0 0 -image $resizePic::resizeCanvPic -anchor nw -tags {img mv}

  #Create title & buttons
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    NewsHandler::QueryNews "Bild nicht gespeichert" red
    catch {image delete $resizePic::resizeCanvPic}
    namespace delete resizePic
  }
  set confirmBtnAction {
    .resizePhoto.confirmBtn conf -state disabled
    .resizePhoto.cancelBtn  conf -state disabled
    set img [doResize $resizePic::c $resizePic::scaleFactor]
    catch {image delete $resizePic::resizeCanvPic}
    namespace delete resizePic
    set ::Modal.Result "Success"
    openReposWindow $img
  }

  ttk::button $w.confirmBtn -text Ok -command $confirmBtnAction
  ttk::button $w.cancelBtn -textvar ::cancel -command $cancelBtnAction
  pack $w.confirmBtn $w.cancelBtn ;#will be repacked into canv window
  set bildname [file tail $addpicture::targetPicPath]

  $resizePic::c create window [expr $canvX - 150] 50 -anchor ne -window $w.confirmBtn -tag okbtn
  $resizePic::c create window [expr $canvX - 80] 50 -anchor ne -window $w.cancelBtn -tag delbtn
  pack $resizePic::c -side top -fill none

  #Set bindings
  $resizePic::c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  
  set cmd [list dragCanvasItem %W img %X %Y]
  $resizePic::c bind mv <B1-Motion> $cmd

#TODO try to bind movements to Mousewheel + Arrow keys:
## But how to define specific steps?????
#$resizePic::c bind mv <MouseWheel> {%W yview scroll [expr {- (%D)}] units}
set moveUD {%W yview scroll [expr {-%D/120}] units}
set moveRL {%W xview scroll [expr {-%D/120}] units}

#$resizePic::c bind mv <MouseWheel> $moveUD

#  $resizePic::c bind mv <Key-Up> $moveUD
  $resizePic::c bind mv <Key-uparrow> $cmd
#  $reposPic::canv bind mv <Down>
#  $reposPic::canv bind mv <Right>
#  $reposPic::canv bind mv <Left>
    
  bind $w <Return> $confirmBtnAction
  bind $w <Escape> $cancelBtnAction
  
  Show.Modal $w -destroy 1 -onclose $cancelBtnAction
} ;#END openResizeWindow

# openReposWindow
##opens new toplevel window if .resizePhoto doesn't exist
##called by addPic ?????????if ![needsResize]??????????????
proc openReposWindow {pic} {
  catch {destroy .resizePhoto}
  #TODO falsche textvar
  tk_messageBox -type ok -message $::textposAdjust
  
  global fontsize fontcolortext
  namespace eval reposPic {}

  set reposPic::reposCanvPic [image create photo]
  set reposPic::w [toplevel .reposPhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  set reposPic::canv [canvas $reposPic::w.reposCanv -bg lightblue]
  $reposPic::canv create image 0 0 -image $reposPic::reposCanvPic -anchor nw -tags {img mv}
  pack $reposPic::canv

  set reposPic::scaleFactor [getReposScalefactor]
  $reposPic::reposCanvPic copy $pic -subsample $reposPic::scaleFactor

  #Define button actions
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    NewsHandler::QueryNews "$::reposNotSaved" red
    file delete $addpicture::targetPicPath
    catch {image delete $reposPic::reposCanvPic}
    namespace delete reposPic
    namespace delete addpicture
  }

  set confirmBtnAction {
    set ::Modal.Result "Success"
    #Compute background luminacy & set font shades
    set lum [getAreaLuminacy $reposPic::canv canvTxt]
    setCanvasFontColour $reposPic::canv $fontcolortext $lum
    #Process PNG info
    lassign [$reposPic::canv coords txt] x y
    set x [expr $x * $reposPic::scaleFactor]
    set y [expr $y * $reposPic::scaleFactor]
    processPngComment $addpicture::targetPicPath $x $y $lum

    NewsHandler::QueryNews "$::reposSaved" lightgreen
    catch {image delete $addpicture::curPic}
    catch {image delete $reposPic::reposCanvPic}
    namespace delete reposPic
    namespace delete addpicture
  }

  set confBtn [button $reposPic::w.moveTxtBtn -command $confirmBtnAction -text OK]
  set cancBtn [button $reposPic::w.cancelBtn -textvar cancel -command $cancelBtnAction]
  pack $cancBtn $confBtn -side right
  
#  $reposPic::canv create window -15 15 -anchor nw -window $confBtn
  $reposPic::canv itemconf mv -state disabled
  $reposPic::w.moveTxtBtn conf -state disabled

  #Set bindings
  $reposPic::canv bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $reposPic::canv bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}
  
  set imgX [image width $reposPic::reposCanvPic]
  set imgY [image height $reposPic::reposCanvPic]
  $reposPic::canv conf -width $imgX -height $imgY

  #Creaste moving text (with positon & luminance)
  createMovingTextBox $reposPic::canv
  
  #Configure text size
   set screenX [winfo screenwidth .]
   set fontfactor [expr $screenX / $imgX]
   if !$fontfactor {
     set canvFontsize $::fontsize
   } {
     set canvFontsize [expr round($::fontsize / $fontfactor)]
   }
   font conf movingTextReposFont -size $canvFontsize
   
  bind $reposPic::w <Return> $confirmBtnAction
  bind $reposPic::w <Escape> $cancelBtnAction

  #Start colour scanning in background - TODO Set back to after idle once colourscan is working!
  after idle {
    $reposPic::canv itemconf mv -state normal
    $reposPic::w.moveTxtBtn conf -state normal
    set textpos.wait "Passen Sie die Textposition nach Wunsch an und quittieren Sie mit OK."
  }

  Show.Modal $reposPic::w -destroy 1 -onclose $cancelBtnAction
  
} ;#END openReposWindow

