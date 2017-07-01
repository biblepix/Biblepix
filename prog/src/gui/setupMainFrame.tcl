# ~/Biblepix/prog/src/gui/setupMainFrame.tcl
# Called by Setup
# Builds Main Frame
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 20feb17

pack forget .updateFrame.pbTitle .updateFrame.progbar .updateFrame

source -encoding utf-8 $SetupTexts
setTexts $lang

source $Setuptools

source $Twdtools

#Set general X vars
set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]
set wWidth 1280
set wHeight 940

if {$screenX < $wWidth} { set wWidth $screenX}
if {$screenY < $wHeight} { set wHeight $screenY}
set wMx [expr ($screenX - $wWidth) / 2]
set wMy [expr ($screenY - $wHeight) / 2]

set tw [expr $wWidth - 100] ;#text width
set px 10
set py 10
set bg LightGrey
set fg blue
font create bpfont4 -family TkCaptionFont -size 30 -weight bold

#Create bottom frame
frame .fbottom
pack .fbottom -fill x -side bottom

#Create top frame
frame .ftop
pack .ftop -fill x

#Create notebook
ttk::notebook .n -width [expr $wWidth - 50] -height [expr $wHeight - 200]
pack .n -fill y -expand true -padx $px -pady $py

#Create Title (LOGO to be created later)
ttk::label .ftop.titelmitlogo -textvar bpsetup -font bpfont4
pack .ftop.titelmitlogo -side left

#Create notebook Tabs
.n add [frame .n.f0 -padx $px] -text Welcome
.n add [frame .n.f1 -padx $px] -text International
.n add [frame .n.f2 -padx $px] -text Desktop
.n add [frame .n.f6 -padx $px] -text Photos
.n add [frame .n.f3 -padx $px] -text E-Mail

if {$platform=="unix"} {
	.n add [frame .n.f4 -padx $px] -text Terminal
}

.n add [frame .n.f5 -padx $px] -text Manual

#Reposition window to screen top
if { [winfo y .] > 20 } {
	wm geometry . +$wMx+$wMy
}

#Fill .fbottom
button .b4 -text OK -width 10 -command {source $SetupSave}
button .b5 -text Cancel -width 10 -command exit
pack .b5 .b4 -in .fbottom -side right

if {![info exists version]} {set version ""}
label .label -text "BiblePix Version $version"
pack .label -in .fbottom -side left

# TODO colorieren
message .news -textvariable news -width [expr $wWidth - 350]
if {![info exists error] || !$error} {
	NewsHandler::QueryNews "$uptodateHttp" green
} else {
	NewsHandler::QueryNews "$noConnHttp" red
}
pack .news -in .fbottom -fill x

#Fill tabs
source $SetupBuild