# ~/Biblepix/prog/src/setup/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 7jul25 pv

source $::AnnotatePng
  
# openResizeWindow
##opens new toplevel window if [needsResize]
##called by addPic
proc openResizeWindow {} {

  global fontsize
  set margin 10

  tk_messageBox -type ok -message $msgbox::movePicToResize
  
 	#Copy origPic to canvas
  namespace eval resizepic {

    set origW [image width origPic]
    set origH [image height origPic]
 puts "$origW $origH"
  	image create photo resizeCanvPic
  	set scaleFactor [getResizeScalefactor]
 puts $scaleFactor
 
  	resizeCanvPic copy origPic -subsample $scaleFactor
  	resizeCanvPic conf -width [expr $origW / $scaleFactor] -height [expr $origH / $scaleFactor]
	}

  lassign [getCanvSizeFromPic resizeCanvPic] canvX canvY
  
  set winX [expr $canvX + 2*$margin]
  set winY [expr $canvY + 2*$margin]

  #Create toplevel window w/canvas & pic
  set w [toplevel .resizePhoto -bg lightblue -padx $margin -pady $margin -relief raised -height $winX -width $winY]
  after idle {tk::PlaceWindow .resizePhoto center}
  
  #configure canvas
  set resizepic::c [canvas $w.resizeCanv -bg lightblue -height $canvY -width $canvX]
  $resizepic::c create image 0 0 -image resizeCanvPic -anchor nw -tags {img mv}
  
#define scroll region - TODO stimmt nicht ganz
  set imX [image width resizeCanvPic]
  set imY [image height resizeCanvPic]
  $resizepic::c conf -scrollregion "0 0 $imX $imY"

  #Create title & buttons
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    NewsHandler::QueryNews "$msg::reposNotSaved" red
    catch {image delete resizeCanvPic}
    catch {namespace delete resizepic}
.phAddBtn conf -state normal
.phRotateBtn conf -state normal

  }
  
  set confirmBtnAction {
    .resizePhoto.confirmBtn conf -state disabled
		.resizePhoto.pb start
		
    set img [doResize $resizepic::c $resizepic::scaleFactor]
    .phAddBtn conf -state disabled
.phRotateBtn conf -state disabled

#TODO gehört das hierhin?
$img write $addpicture::targetPicPath -format PNG 
     
    set ::Modal.Result "Success"
    openReposWindow $img
  }

	#Create Btns, packed later
  ttk::button $w.confirmBtn -textvar msg::ok -command $confirmBtnAction
  ttk::button $w.cancelBtn -textvar msg::cancel -command $cancelBtnAction

set bildname $canvpic::thumb

	#Place buttons onto canvas
  $resizepic::c create window [expr $canvX - 150] 50 -anchor ne -window $w.confirmBtn -tag okbtn
  $resizepic::c create window [expr $canvX - 80] 50 -anchor ne -window $w.cancelBtn -tag delbtn

#frame $w.topF -bg beige
#frame $w.botF -bg yellow
#pack $w.topF $w.botF
#Create scrollbars - TODO NOT WOWRKING!
  scrollbar $w.resizeRightSB -orient vertical -command {$resizepic::c yview} 
	scrollbar $w.resizeBotSB -orient horizontal -command {$resizepic::c xview}
	$resizepic::c conf -yscrollcommand "$w.resizeRightSB set" -xscrollcommand "$w.resizeBotSB set"

	#Create progress bar
	ttk::progressbar $w.pb -mode indeterminate -length 150


pack $w.pb -pady 15 -side bottom
pack $w.resizeBotSB -side bottom -fill x
pack $resizepic::c -side left
pack $w.resizeRightSB -side right -fill y

	
  #Set bindings
  $resizepic::c bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  
  set cmd [list dragCanvasItem %W img %X %Y]
  $resizepic::c bind mv <B1-Motion> $cmd

#TODO Joel: try to bind movements to Mousewheel + Arrow keys:
## But how to define specific steps?????
#$resizepic::c bind mv <MouseWheel> {%W yview scroll [expr {- (%D)}] units}
set moveUD {%W yview scroll [expr {-%D/120}] units}
set moveRL {%W xview scroll [expr {-%D/120}] units}

bind $resizepic::c <MouseWheel> $moveUD

#  $resizepic::c bind mv <Key-Up> $moveUD
  bind $resizepic::c <Key-uparrow> $cmd
#  $repospic::canv bind mv <Down>
#  $repospic::canv bind mv <Right>
#  $repospic::canv bind mv <Left>
    
    
  bind $w <Return> $confirmBtnAction
  bind $w <Escape> $cancelBtnAction
  
  Show.Modal $w -destroy 1 -onclose $cancelBtnAction
  
} ;#END openResizeWindow

# openReposWindow
##opens new toplevel window if ??? .resizePhoto doesn't exist
##asks if text needs repositioning & saves pic with info
##called by addPic if ![needsResize]??????????????
proc openReposWindow {pic} {
  catch {destroy .resizePhoto}
  global fontsize fontcolortext
  namespace eval repospic {}

  set repospic::reposCanvPic [image create photo]
  set repospic::w [toplevel .reposPhoto -bg lightblue -padx 20 -pady 20 -height 400 -width 600]
  after idle {tk::PlaceWindow .reposPhoto center}
  
  set repospic::canv [canvas $repospic::w.reposCanv -bg lightblue]
  
  $repospic::canv create image 0 0 -image $pic -anchor nw -tags {img mv}
  pack $repospic::canv

  image create photo reposCanvPic
 
	set repospic::scaleFactor [getReposScalefactor $pic]
	reposCanvPic copy $pic -subsample $repospic::scaleFactor

  #Define button actions
  set cancelBtnAction {
    set ::Modal.Result "Cancelled"
    NewsHandler::QueryNews "$msg::reposNotSaved" red
    file delete $addpicture::targetPicPath
    catch {image delete reposCanvPic}
    catch {namespace delete repospic}
  }

  set confirmBtnAction {
    set ::Modal.Result "Success"
    #Compute background luminacy & set font shades
    set lum [getAreaLuminacy $repospic::canv canvTxt]
    setCanvasFontColour $repospic::canv $fontcolortext $lum
    #Process PNG info
    lassign [$repospic::canv coords txt] x y
    set x [expr $x * $repospic::scaleFactor]
    set y [expr $y * $repospic::scaleFactor]
    processPngComment $addpicture::targetPicPath $x $y $lum

    NewsHandler::QueryNews "$msg::reposSaved" lightgreen
    catch {image delete reposCanvPic}
    namespace delete repospic
  }

  set confBtn [button $repospic::w.moveTxtBtn -command $confirmBtnAction -textvar msg::ok]
  set cancBtn [button $repospic::w.cancelBtn -command $cancelBtnAction -textvar msg::cancel]
  pack $cancBtn $confBtn -side right
 
  #Set bindings
  $repospic::canv bind mv <1> {
     set ::x %X
     set ::y %Y
  }
  $repospic::canv bind mv <B1-Motion> {dragCanvasItem %W txt %X %Y 20}
  
#  set imgX [image width $repospic::reposCanvPic]
#  set imgY [image height $repospic::reposCanvPic]
  set imgX [image width reposCanvPic]
  set imgY [image width reposCanvPic]
  
  $repospic::canv conf -width $imgX -height $imgY

  #Creaste moving text (with positon & luminance)
  createMovingTextBox $repospic::canv
  
  #Configure text size
   set screenX [winfo screenwidth .]
   set fontfactor [expr $screenX / $imgX]
   if !$fontfactor {
     set canvFontsize $::fontsize
   } {
     set canvFontsize [expr round($::fontsize / $fontfactor)]
   }
   font conf movingTextReposFont -size $canvFontsize
   
  bind $repospic::w <Return> $confirmBtnAction
  bind $repospic::w <Escape> $cancelBtnAction

  #Ask if text should be moved
  ##if no, set margins to 0 & save & close window
  set res [tk_messageBox -type yesno -message $msgbox::textposAdjust] 
  if {$res == "no"} {
    set lum [getAreaLuminacy $repospic::canv canvTxt]
    processPngComment $addpicture::targetPicPath 0 0 $lum
    NewsHandler::QueryNews "$msg::reposSaved" lightgreen
    destroy $repospic::w
  }

  catch {Show.Modal $repospic::w -destroy 1 -onclose $cancelBtnAction}
  
} ;#END openReposWindow
