# ~/Biblepix/prog/src/gui/setupResizePhoto.tcl
# Sourced by SetupPhotos if resizing needed
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 10feb18

proc openResizeWindow {} {
  
  toplevel .dlg -bg lightblue -padx 20 -pady 20

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]

  #Create canvas with pic
  canvas .dlg.dlgCanv
  .dlg.dlgCanv create image 0 0 -image photosCanvPic -anchor nw -tags {img mv}

  #Create title & buttons
  set okButton {set ::Modal.Result [doResize .dlg.dlgCanv]}
  set cancelButton {set ::Modal.Result "Cancelled"}
  ttk::label .dlg.resizeLbl -text "$::movePicToResize" -font {TkHeadingFont 18} -background orange
  ttk::button .dlg.resizeConfirmBtn -text Ok -command $okButton
  ttk::button .dlg.resizeCancelBtn -textvar ::cancel -command $cancelButton
  
  #Set pic factor
  set factor [expr $imgX. / $screenX]
  if {[expr $imgY. / $factor] < $screenY} {
    set factor [expr $imgY. / $screenY]
  }

  #SET SCREENFACTOR - schon da!!!
  set screenFactor [expr $screenY. / $screenX]
  
  
  #Set cutting coordinates & configure canvas
  #set canvCutX2 [expr $screenX * $factor]
  #set canvCutY2 [expr $screenY * $factor]
  
#TODO: falsch BERECHTNET:
  set canvCutX2 [expr $screenX * $factor]
  set canvCutY2 [expr $screenY * $factor]
  
  .dlg.dlgCanv configure -width $canvCutX2 -height $canvCutY2 -bg lightblue -relief solid -borderwidth 2
  
  #Pack everything
  pack .dlg.resizeLbl
  pack .dlg.dlgCanv
  pack .dlg.resizeCancelBtn .dlg.resizeConfirmBtn -side right
  focus .dlg.resizeConfirmBtn
  
  #Set bindings
  bind .dlg <Return> $cancelButton
  bind .dlg <Escape> $cancelButton
 .dlg.dlgCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
 .dlg.dlgCanv bind mv <B1-Motion> [list dragCanvasItem %W mv %X %Y]
  
  Show.Modal .dlg -destroy 1 -onclose $cancelButton
} ;#END openResizeWindow

proc checkItemInside {w item xDiff yDiff} {
#THANKS TO ...
#canvas extents
  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]
  set canvX [winfo width .dlg.dlgCanv]
  set canvY [winfo height .dlg.dlgCanv]
  
  set can(miny) 0
  set can(minx) 0
  set can(maxy) [image height photosCanvPic]
  set can(maxx) [image width photosCanvPic]

  if {$imgX > $canvX} {
    set can(minx) [expr $canvX - $imgX]
    set can(maxy) 0
    set can(maxx) 0
    
  } elseif {$imgY > $canvY} {
      
    set can(miny) [expr $canvY - $imgY]
   # set can(maxy) [expr $can(miny) + (2 * $can(miny))]
  #  set can(maxy) [string range $can(miny) 1 end]
    set can(maxy) 0
    set can(maxx) 0
  }

#puts "minx $can(minx)"
#puts "maxx $can(maxx)"
#puts "maxY $can(maxy)"
#puts "minY $can(miny)"

#	set can(maxx) [winfo width $w ]
#	set can(maxy) [winfo height $w ]

#item coords
	set item [$w coords $item]
	#check min values
	foreach {x y} $item {
		set x [expr $x + $xDiff]
		set y [expr $y + $yDiff]
		if {$x < $can(minx)} {
			 return 0
		}
		if {$y < $can(miny)} {
			 return 0
		}
		if {$x > $can(maxx)} {
			 return 0
		}
		if {$y > $can(maxy)} {
			 return 0
		}
	}
	#puts $item
	return 1
}

proc dragCanvasItem {canWin item newX newY} {
#THANKS TO  ...
	set xDiff [expr {$newX - $::x}]
	set yDiff [expr {$newY - $::y}]
  
	#test before moving
	if {[checkItemInside $canWin $item $xDiff $yDiff]} {
		 #puts inside
		 $canWin move $item $xDiff $yDiff
	}
	set ::x $newX
	set ::y $newY
}
