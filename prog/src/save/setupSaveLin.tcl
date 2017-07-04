# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 30jun17

source $SetupSaveLinHelpers

## OLD STUFF - TO BE REMOVED SOON! ##################################
file delete -force ~/.biblepix

#check .bashrc for old entry and remove
set chan [open ~/.bashrc]
set readfile [read $chan]
close $chan
set string1 {biblepix}
set string2 {prog/bash}
if {[regexp $string1 $readfile] || [regexp $string2 $readfile]} {
	regsub -all -line "^$string1.*$" $readfile {} readfile
        regsub $string2 $readfile {prog/unix} readfile
        set chan [open ~/.bashrc w]
	puts $chan $readfile
	close $chan
}

#move any old jpegs to $imgdir
set jpglist [glob -nocomplain -directory $rootdir *.jpg *.jpeg *.JPG *.JPEG] 
foreach file $jpglist {
	file copy -force $file $imgdir
	file delete $file
}
############################################################


set hasError 0

#Run setLinCrontab OR setLinAutostart - progs return 1 or 0
if {
	[setLinCrontab]
	} {
	catch setLinAutostart Error
	
	if {$Error!=0} {
		tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
		set hasError 1
	} 
}

#Run setLinMenu
catch setLinMenu Error

if {!$hasError && $Error!=""} {
	tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
	set hasError 1
}

## SET BACKGROUND PICTURE/SLIDESHOW if $enablepic
if {$enablepic} {
	tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangeDesktop
	
	catch setLinBackground Error

	if {!$hasError && $Error!=""} {
		tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
		set hasError 1
	}
}

if {!$hasError} {
	tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $changeDesktopOk
}
