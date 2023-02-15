# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 28jan23 pv

source $::AnnotatePng
  
# openResizeWindow
##opens new toplevel window if [needsResize]
##called by addPic
proc openResizeWindow {} {

  global fontsize
  set margin 10

  tk_messageBox -type ok -message $msgbox::movePicToResize
  
 	#Copy addpicture::curPic to canvas
  namespace eval resizePic {

    set origW [image width $addpicture::curPic]
    set origH [image height $addpicture::curPic]
  	image create photo resizeCanvPic
  	set scaleFactor [getResizeScalefactor]
  	resizeCanvPic copy $addpicture::curPic -subsample $scaleFactor
  	resizeCanvPic conf -width [expr $origW / $scaleFactor] -height [expr $origH / $scaleFactor]
	}

  lassign [getCanvSizeFromPic resizeCanvPic] canvX canvY
  
  set winX [expr $canvX + 2*$margin]
  set winY [expr $canvY + 2*$margin]

  #Create toplevel window w/canvas & pic
  set w [toplevel .resizePhoto -bg lightblue -padx $margin -pady $margin -height $winX -width $winY]
  set resizePic::c [canvas $w.resizeCanv -bg lightblue -height $canvY -width $canvX]
  $resizePic::c create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}
	#Create progress bar
	ttk::progressbar $w.pb -mode indeterminate -length 150

  #Create title & buttons
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    NewsHandler::QueryNews "$msg::reposNotSaved" red
    catch {image delete resizeCanvPic}
    namespace delete resizePic
  }
  
  set confirmBtnAction {
    .resizePhoto.confirmBtn conf -state disabled
		.resizePhoto.pb start
    set img [doResize $resizePic::c $resizePic::scaleFactor]
    set ::Modal.Result "Success"
    openReposWindow $img
  }

  ttk::button $w.confirmBtn -textvar msg::ok -command $confirmBtnAction
  ttk::button $w.cancelBtn -textvar msg::cancel -command $cancelBtnAction
  pack $w.confirmBtn $w.cancelBtn
  set bildname [file tail $addpicture::targetPicPath]

	#Place buttons onto canvas
  $resizePic::c create window [expr $canvX - 150] 50 -anchor ne -window $w.confirmBtn -tag okbtn
  $resizePic::c create window [expr $canvX - 80] 50 -anchor ne -window $w.cancelBtn -tag delbtn
  pack $resizePic::c -side top -fill none
	pack $w.pb -pady 15
	
  #Set bindings
  $resizePic::c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  
  set cmd [list dragCanvasItem %W img %X %Y]
  $resizePic::c bind mv <B1-Motion> $cmd

#TODO Joel: try to bind movements to Mousewheel + Arrow keys:
## But how to define specific steps?????
#$resizePic::c bind mv <MouseWheel> {%W yview scroll [expr {- (%D)}] units}
set moveUD {%W yview scroll [expr {-%D/120}] units}
set moveRL {%W xview scroll [expr {-%D/120}] units}

bind $resizePic::c <MouseWheel> $moveUD

#  $resizePic::c bind mv <Key-Up> $moveUD
  bind $resizePic::c <Key-uparrow> $cmd
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
    NewsHandler::QueryNews "$msg::reposNotSaved" red
    file delete $addpicture::targetPicPath
    catch {image delete $reposPic::reposCanvPic}
    namespace delete reposPic
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

    NewsHandler::QueryNews "$msg::reposSaved" lightgreen
    catch {image delete $reposPic::reposCanvPic}
    namespace delete reposPic
  }

  set confBtn [button $reposPic::w.moveTxtBtn -command $confirmBtnAction -textvar msg::ok]
  set cancBtn [button $reposPic::w.cancelBtn -command $cancelBtnAction -textvar msg::cancel]
  pack $cancBtn $confBtn -side right
 
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

  #Ask if text should be moved
  ##if no, set margins to 0 & save & close window
  set res [tk_messageBox -type yesno -message $msgbox::textposAdjust] 
  if {$res == "no"} {
    set lum [getAreaLuminacy $reposPic::canv canvTxt]
    processPngComment $addpicture::targetPicPath 0 0 $lum
    NewsHandler::QueryNews "$msg::reposSaved" lightgreen
    destroy $reposPic::w
  }

  catch {Show.Modal $reposPic::w -destroy 1 -onclose $cancelBtnAction}
  
} ;#END openReposWindow
