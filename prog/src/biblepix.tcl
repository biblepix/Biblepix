# ~/Biblepix/prog/src/biblepix.tcl
# Main program, called by System Autostart
# Projects The Word from "Bible 2.0" on a daily changing backdrop image 
# OR displays The Word in the terminal OR adds The Word to e-mail signatures
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15nov16
######################################################################

#Verify location & source Globals
set srcdir [file dirname [info script]]
set Globals "[file join $srcdir share globals.tcl]"
source $Globals

#Parse TWD file & get text for all functions - or start Setup
source $Twdtools

if {[catch "set twdfile [getRandomTWDFile]"] } {
	source -encoding utf-8 $SetupTexts
	setTexts $lang
	tk_messageBox -title BiblePix -type ok -icon error -message $noTWDFilesFound
	catch {source $Setup} ; # catch if run by running Setup :-)

} else {

	#Always create term.sh for Unix terminal
	if {$platform=="unix"} {
		set dwterm [formatTermText $twdfile]
		set f [open $Terminal w]
		puts $f ". $confdir/term.conf"
		puts $f $dwterm
		close $f
		file attributes $Terminal -permissions +x
	}

	#Stop any running biblepix.tcl
	foreach file [glob -nocomplain -directory $piddir *] {
		file delete -force $file
	}
	set pidfile [open $piddir/[pid] w]
	close $pidfile

	#Update signatures
	if {$enablesig} {
		source $Signature
	}

	#Create image & start slideshow
	if {$enablepic} {
		#run once
		source $Image

		#if Slideshow not 0
		if {$slideshow} {
			#rerun until pidfile renamed by new instance
			set pidfile $piddir/[pid]
			set pidfiledatum [clock format [file mtime $pidfile] -format %d]
			after [expr $slideshow*1000]
		
				while {[file exists $pidfile]} {
					if {$pidfiledatum==$heute} {
						source $Image
						after [expr $slideshow*1000]
					} else {
	#Calling myself !!!!!!!!!!!!!!!!!!!!!!!!!
						source $Biblepix
					}
				}
		#if Slideshow == 0		
		} else {
			 		
			#run BiblePix every minute up to 5x so Windows has time to grab the new pic
			set limit 0
				while {$limit<4} {
					source $Image
					incr limit
					after 60000
				}
		
		exit
		
		}
	#puts "We seeem to be stale. Exiting."
	
	} ;#END if enablepic
} ;#END MAIN
