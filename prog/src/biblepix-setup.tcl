# ~/Biblepix/prog/src/biblepix-setup.tcl
# Main Setup program for BiblePix, starts Setup dialogue
# Called by User via Windows/Unix Desktop entry
# If called by BiblePix-Installer, this is the first file downloaded + executed
################################################################################
# Version: 2.3
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 22dec2016

package require Tk

#Verify location & source vars
set srcdir [file dirname [info script]]
set Globals "[file join $srcdir share globals.tcl]"

if {
	[catch {source $Globals}]
} {
	set httpStatus "Update not possible.\nYou must download and rerun the BiblePix Installer from bible2.net."
	after 7000 {exit}
}


# 1. C R E A T E   M A I N   F R A M E

#Set preliminary X variables
set screenheight [winfo screenheight .]
set screenwidth [winfo screenwidth .]
set wWidth [expr $screenwidth - ($screenwidth/10)]
set wHeight [expr $screenheight - 250]
font create bpfont4 -family TkCaptionFont -size 30 -weight bold

#Create bottom frame
frame .fbottom
pack .fbottom -fill x -side bottom

#Create top frame
frame .ftop
pack .ftop -fill x

#Create notebook
ttk::notebook .n -width $wWidth -height $wHeight
pack .n -fill y -expand true -padx 10 -pady 10
#.n state disabled

#Create Title (LOGO to be created later)
ttk::label .ftop.titelmitlogo -textvar bpsetup -text "BiblePix Installation" -font bpfont4
pack .ftop.titelmitlogo -side left

#Create notebook Tabs
.n add [frame .n.f0 -padx 10] -text Welcome
.n add [frame .n.f1 -padx 10] -text International -state hidden
.n add [frame .n.f2 -padx 10] -text Desktop -state hidden
.n add [frame .n.f6 -padx 10] -text Photos -state hidden
.n add [frame .n.f3 -padx 10] -text E-Mail -state hidden

if {$tcl_platform(platform)=="unix"} {
	.n add [frame .n.f4 -padx 10] -text Terminal -state hidden
}

.n add [frame .n.f5 -padx 10] -text Manual -state hidden

#Reposition window to screen top
if { [winfo y .] > 20 } {
	if {$platform=="windows"} {
		wm overrideredirect . 1
	       # wm positionfrom . user
	       # wm sizefrom . user
	}
	wm geometry . +0+0
}


#Fill .fbottom
button .b4 -text OK -width 10
button .b5 -text Cancel -width 10 -command exit
pack .b5 .b4 -in .fbottom -side right
.b4 configure -state disabled
.b5 configure -state disabled

if {![info exists version]} {set version ""}
label .label -text "BiblePix Version $version"
pack .label -in .fbottom -side left

message .news -textvariable news -width [expr $wWidth - 300]
set news biblepix.vollmar.ch
pack .news -in .fbottom -fill x

#Set initial FTP message & progress bar
.n.f0 configure -padx 40 -pady 50 -borderwidth 20
label .n.f0.progbarL -justify center -bg lightblue -fg black -borderwidth 10 -textvariable httpStatus

ttk::progressbar .n.f0.progbar -mode indeterminate -length 200
pack .n.f0.progbarL .n.f0.progbar
.n.f0.progbar start


# 2.  D O   H T T P  U P D A T E   (if not initial)

#Make empty dirs in case of GIT download
file mkdir $sigdir $imgdir $twddir $bmpdir $piddir $confdir 

#Set initial texts if missing
if { 
	[catch {source $SetupTexts ; setTexts $lang}]
} {
	set updatingHttp "Updating BiblePix program files..."
	set noConnHttp "No connection for BiblePix update. Try later."
}

if { [info exists InitialJustDone] } {
	set httpStatus $uptodateHttp
	.news configure -bg lightgreen
	set news $uptodateHttp

} else {
	
	set httpStatus $updatingHttp
	source $Http
        
	# a) Do Update if $config exists
	if { [file exists $Config] } {
		set error [runHTTP]
	# b) Do Reinstall
        } else {
		set error [runHTTP Initial]
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
		.n.f0.progbarL configure -bg lightgreen
		set httpStatus $uptodateHttp
		after 1000 {
			.n.f0.progbar stop
			.n.f0.progbar configure -value 100}	
			.news configure -bg lightgreen
			set news $uptodateHttp
	
	}
}

# 3. B U I L D  G U I

after 2000 {
	pack forget .n.f0.progbarL .n.f0.progbar
	.n.f0 configure -padx 10 -pady 0 -borderwidth 0
	#Unhide tabs	
	.n add .n.f1
	.n add .n.f2
	.n add .n.f3
	catch {.n add .n.f4}
	.n add .n.f5
	.n add .n.f6
        .b4 configure -state normal
        .b5 configure -state normal
	#Fill tabs
        source $SetupBuild
        #retry resetting geometry
        wm geometry . +0+0
}
#Set news back to neutral
after 4000 {
	.news configure -bg grey
	set ::news "biblepix.vollmar.ch"
}
