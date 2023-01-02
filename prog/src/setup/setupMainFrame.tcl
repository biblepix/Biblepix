# ~/Biblepix/prog/src/setup/setupMainFrame.tcl
# Called by Setup
# Builds Main Frame
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2jan23 pv

#source $SetupTools
#source $TwdTools
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
pack [frame .botMainF] -fill x -side bottom
pack [frame .topMainF] -fill x

#Create notebook
ttk::notebook .nb -width [expr $wWidth - 50] -height [expr $wHeight - 200]
pack .nb -fill y -expand true -padx $px -pady $py
#Create notebook title (LOGO + Flags to be created later)
ttk::label .mainTitleL -textvar msg::bpsetup -font bpfont4 -padding 5
pack .mainTitleL -in .topMainF -side left

##Create notebook tab list (revert order for RTL)
lappend nbtabL .welcomeF .internationalF .desktopF .photosF .emailF .manualF
if [isRtL $lang] {
	set nbtabL [lreverse $nbtabL]
}
##Insert Terminal tab if Unix
if {$platform=="unix"} {
  linsert $nbtabL 4 .terminalF
  frame .terminalF -padx $px -pady $py
}
##Create Notebook tabs (Title texts inserted later by setFlags)
foreach nbtab $nbtabL {
	.nb add [frame $nbtab -padx $px -pady $py] 
}
##Unix
if [winfo exists .terminalF] {
  .nb insert .manualF .terminalF
}
.nb select .welcomeF

#Reposition window to screen top
if { [winfo y .] > 20 } {
  wm geometry . +$wMx+$wMy
}

#Fill .botMainF
button .mainSaveBtn -activebackground lightgreen -textvar msg::saveSettings -width 20 -command {source $Save}
button .mainCloseBtn -activebackground red -textvar msg::close -width 20 -command exit
pack .mainCloseBtn .mainSaveBtn -in .botMainF -side right

if ![info exists version] {set version ""}
label .versionL -text "BiblePix Version $version"
pack .versionL -in .botMainF -side left

message .news -textvar news -width [expr $wWidth - 350] -borderwidth 1 -relief sunken
pack .news -in .botMainF -fill x

#Validate error msg issued by Setup
if [info exists httpError] {
  if {$httpError == 0} {
    NewsHandler::QueryNews "[mc uptodateHTTP]" lightgreen
  } else {
    NewsHandler::QueryNews "[mc noConnHTTP]" red
  }
}

#Fill tabs
source $SetupBuild
