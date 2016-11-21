# ~/Biblepix/prog/src/biblepix-setup.tcl
# Main Setup program for BiblePix, starts Setup dialogue
# Called by User via Windows/Unix Desktop entry
# If called by BiblePix-Installer, this is the first file downloaded + executed
################################################################################
# Version: 2.3
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 21nov2016

#Verify location & source vars
set srcdir [file dirname [info script]]
set Globals "[file join $srcdir share globals.tcl]"
source $Globals
source $SetupTexts
setTexts $lang

#Make empty dirs in case of GIT download
file mkdir $sigdir $imgdir $twddir $bmpdir $piddir $confdir 

# 1. C R E A T E   M A I N   F R A M E

package require Tk

#Set preliminary X variables
#set screenwidth [winfo screenwidth .]
set screenheight [winfo screenheight .]
set wWidth 1000
set wHeight [expr $screenheight - 250]
set f4 "TkCaptionFont 30 bold"

#Create bottom frame
frame .fbottom
pack .fbottom -fill x -side bottom

#Create top frame
frame .ftop
pack .ftop -fill x

#Create notebook
ttk::notebook .n -width $wWidth -height $wHeight
pack .n -fill y -expand true -padx 10 -pady 10

#Create Title (LOGO to be created later)
ttk::label .ftop.titelmitlogo -textvar bpsetup -text "BiblePix Installation" -font $f4
pack .ftop.titelmitlogo -side left

#Create notebook Tabs
.n add [frame .n.f0 -padx 10] -text Welcome
.n add [frame .n.f1 -padx 10] -text International
.n add [frame .n.f2 -padx 10] -text Desktop
.n add [frame .n.f6 -padx 10] -text Photos
.n add [frame .n.f3 -padx 10] -text E-Mail

if {$platform=="unix"} {
	.n add [frame .n.f4 -padx 10] -text Terminal
}

.n add [frame .n.f5 -padx 10] -text Manual

#Fill .fbottom
button .b4 -text OK -width 10
button .b5 -text Cancel -width 10 -command exit
pack .b5 .b4 -in .fbottom -side right

label .label -text "BiblePix Version $version"
pack .label -in .fbottom -side left

message .news -textvariable news -width [expr $wWidth - 300]
set news biblepix.vollmar.ch
pack .news -in .fbottom -fill x

#Set initial FTP message & progress bar
.n.f0 configure -padx 40 -pady 50 -borderwidth 10
label .n.f0.progbarL -justify center -bg lightblue -fg black -borderwidth 10 -textvariable httpStatus

ttk::progressbar .n.f0.progbar -mode indeterminate -length 200
pack .n.f0.progbarL .n.f0.progbar
.n.f0.progbar start


# 2.  D O   H T T P  U P D A T E   (if not initial)

if { [info exists InitialJustDone] } {
	
	set httpStatus $uptodateHttp
	.news configure -bg green
	set news $uptodateHttp

} else {
	
	set httpStatus $updatingHttp
	source $Http
        
	# a) Do Update if $config exists
	if { [file exists $Config] } {
		runHTTP
	# b) Do Reinstall
        } else {
		runHTTP Initial
	}
	
	if {$error} {
		
		.n.f0.progbarL configure -bg red
		set httpStatus $noConnHttp
		after 1000 {
			.n.f0.progbar stop
			.n.f0.progbar configure -value 100}	
			.news configure -bg red
			set news $noConnHttp

	} else {
		.n.f0.progbarL configure -bg green
		set httpStatus $uptodateHttp
		after 1000 {
			.n.f0.progbar stop
			.n.f0.progbar configure -value 100}	
			.news configure -bg green
			set news $uptodateHttp
	
	}
}

# 3. B U I L D  G U I

after 3000 {
	pack forget .n.f0.progbarL .n.f0.progbar
	source $SetupBuild
}
#Set news back to neutral
after 7000 {
	.news configure -bg grey
	set ::news "biblepix.vollmar.ch"
}
