# ~/Biblepix/prog/src/biblepix.tcl
# Main program, called by System Autostart
# Projects The Word from "Bible 2.0" on a daily changing backdrop image 
# OR displays The Word in the terminal OR adds The Word to e-mail signatures
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 25dec16
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
        	catch {set dwterm [formatTermText $twdfile] }
		if {$dwterm != ""} {
			set f [open $Terminal w]
			puts $f ". $confdir/term.conf"
			puts $f $dwterm
			close $f
			file attributes $Terminal -permissions +x
		}
	}
        
        #Prepare changing Win desktop
	if {$platform=="windows"} {
        	package require registry
        	set regpath [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
        }
        
        proc setWinBG {} {
        	global TwdTIF regpath platform
                if {$platform=="windows"} { 
                	registry set $regpath Wallpaper [file nativename $TwdTIF]
                	exec rundll32.exe user32.dll,UpdatePerUserSystemParameters ,1 ,True
		}
	}

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

	#if Slideshow == 1
	if {$slideshow} {
			#rerun until pidfile renamed by new instance
			set pidfile $piddir/[pid]
			set pidfiledatum [clock format [file mtime $pidfile] -format %d]
			after [expr $slideshow*1000]

				while {[file exists $pidfile]} {
					if {$pidfiledatum==$heute} {
                                        	#run once again (zur Sicherheit?)
						#source $Image
                                                setWinBG
                                               					
                                                after [expr $slideshow*1000]
					
                                        } else {
						#Calling new instance of myself
						source $Biblepix
					}
				}
		
        #if Slideshow == 0		
	} else {
        	
        #        source $Image
			
                if {$platform=="windows"} {
                        #run every minute up to 5x so Windows has time to update
			set limit 0
                        #source $Image
                        
			while {$limit<4} {
			#	source $Image
        			setWinBG
				incr limit
				after 60000
			}
		}
        } ;#END if slideshow
        
} ;#END if enablepic
