# ~/Biblepix/prog/src/setup/setupMainFrame.tcl
# Called by Setup
# Builds Main Frame
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 4aug21 pv
source $SetupTools
source $TwdTools
setTexts $lang

#Set general X vars & Main Window width
set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]
set wWidth [expr min(round($screenX * 0.9), 1920)]
set wHeight [expr round($screenY * 0.9)]
set wMx [expr ($screenX - $wWidth) / 2]
set wMy [expr ($screenY - $wHeight) / 2]
set tw [expr $wWidth - 100] ;#text width
set px 10
set py 10
set bg LightGrey
set fg blue
catch {font create bpfont4 -family TkCaptionFont -size 30 -weight bold}

#Create frames
pack [frame .fbottom] -fill x -side bottom
pack [frame .ftop] -fill x
#Create notebook
ttk::notebook .nb -width [expr $wWidth - 50] -height [expr $wHeight - 200]
pack .nb -fill y -expand true -padx $px -pady $py
#Create Title (LOGO to be created later)
ttk::label .ftop.titelmitlogo -textvar msg::bpsetup -font bpfont4 -padding 5
pack .ftop.titelmitlogo -side left

#Create notebook Tabs
.nb add [frame .welcomeF -padx $px -pady $py] -text $msg::welcome
.nb add [frame .internationalF -padx $px -pady $py] -text $msg::bibletexts
.nb add [frame .desktopF -padx $px -pady $py] -text $msg::desktop
.nb add [frame .photosF -padx $px -pady $py] -text $msg::photos
.nb add [frame .emailF -padx $px -pady $py] -text $msg::email
.nb add [frame .manualF -padx $px -pady $py] -text $msg::manual
if {$platform=="unix"} {
  .nb insert 5 [frame .terminalF -padx $px -pady $py] -text $msg::terminal
}

#Reposition window to screen top
if { [winfo y .] > 20 } {
  wm geometry . +$wMx+$wMy
}

#Fill .fbottom
button .mainSaveB -activebackground lightgreen -textvar msg::saveSettings -width 20 -command {source $Save}
button .mainCloseB -activebackground red -textvar msg::close -width 20 -command exit
pack .mainCloseB .mainSaveB -in .fbottom -side right

if {![info exists version]} {set version ""}
label .label -text "BiblePix Version $version"
pack .label -in .fbottom -side left

message .news -textvar news -width [expr $wWidth - 350] -borderwidth 1 -relief sunken

#Validate error msg issued by Setup
if [info exists httpError] {
  if {$httpError == 0} {
    NewsHandler::QueryNews "$uptodateHttp" lightgreen
  } else {
    NewsHandler::QueryNews "$noConnHttp" red
  }
}
pack .news -in .fbottom -fill x

#Fill tabs
source $SetupBuild
