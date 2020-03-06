# ~/Biblepix/prog/src/setup/setupMainFrame.tcl
# Called by Setup
# Builds Main Frame
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 5mch20

source -encoding utf-8 $SetupTexts
setTexts $lang
source $SetupTools
source $TwdTools

#Set general X vars & Main Window width
set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]
set wWidth [expr round($screenX * 0.9)]
set wHeight [expr round($screenY * 0.9)]

#if {$screenX < $wWidth} { set wWidth $screenX}
#if {$screenY < $wHeight} { set wHeight $screenY}
set wMx [expr ($screenX - $wWidth) / 2]
set wMy [expr ($screenY - $wHeight) / 2]

set tw [expr $wWidth - 100] ;#text width
set px 10
set py 10
set bg LightGrey
set fg blue
font create bpfont4 -family TkCaptionFont -size 30 -weight bold

#Create bottom frame
pack [frame .fbottom] -fill x -side bottom

#Create top frame
pack [frame .ftop] -fill x

#Create notebook
ttk::notebook .nb -width [expr $wWidth - 50] -height [expr $wHeight - 200]
pack .nb -fill y -expand true -padx $px -pady $py

#Create Title (LOGO to be created later)
ttk::label .ftop.titelmitlogo -textvar bpsetup -font bpfont4
pack .ftop.titelmitlogo -side left

#Create notebook Tabs
.nb add [frame .welcomeF -padx $px] -text Welcome
.nb add [frame .internationalF -padx $px] -text International
.nb add [frame .desktopF -padx $px] -text Desktop
.nb add [frame .photosF -padx $px] -text Photos
.nb add [frame .emailF -padx $px] -text E-Mail

if {$platform=="unix"} {
  .nb add [frame .terminalF -padx $px] -text Terminal
}

.nb add [frame .manualF -padx $px] -text Manual

#Reposition window to screen top
if { [winfo y .] > 20 } {
  wm geometry . +$wMx+$wMy
}

#Fill .fbottom
button .mainSaveB -activebackground lightgreen -textvar ::saveSettings -width 20 -command {source $SetupSave}
button .mainCloseB -activebackground red -textvar ::cancel -width 20 -command exit
pack .mainCloseB .mainSaveB -in .fbottom -side right

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
