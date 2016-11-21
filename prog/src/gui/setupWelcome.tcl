# ~/Biblepix/prog/src/gui/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 20nov16

#Pack flags defined elsewhere
pack .en .de -in .ftop -side right

#Set headings & messages
label .n.f0.tit -font $f3 -textvar welc.tit
label .n.f0.subtit1 -font $f2 -textvar welc.subtit1 -padx $px -pady $py
message .n.f0.whatis -textvar welc.txt1 -font $f1 -width $tw -justify left -padx $px

label .n.f0.subtit2 -font $f2 -textvar welc.subtit2 -padx $px -pady $py
message .n.f0.possibilities1 -textvar welc.txt2 -font $f1 -width $tw -justify left -pady 0 -padx $px
message .n.f0.possibilities2 -textvar welc.txt3 -font $f1 -width $tw -justify left -pady 0 -padx $px
message .n.f0.possibilities3 -textvar welc.txt4 -font $f1 -width $tw -justify left -pady 0 -padx $px

pack .n.f0.tit .n.f0.subtit1 .n.f0.whatis -anchor nw

#Set TheWord Button
button .n.f0.daswort -font "TkTextFont 12" -textvar dwtext -bg $bg -activebackground lightblue -fg blue -pady $py -padx $px -bd 5 -command {set dwtext [setTWD]}
pack .n.f0.daswort

proc setTWD {} {
global srcdir platform lang enableintro Twdtools Bidi noTWDFilesFound
	
	# get TWD
	set twdfile [getRandomTWDFile]

	# check TWD
	if {$twdfile==""} {
		.n.f0.daswort configure -foreground black -background red -activeforeground black -activebackground orange
		set dw $noTWDFilesFound
	
	} else {		
	# get TWD
		source $Twdtools
		set dw [formatImgText $twdfile]
		.n.f0.daswort conf -justify left

		#Check for Hebrew text 
		if { [regexp {[\u05d0-\u05ea]} $dw] } {
			set justify right
			source $Bidi
			#Unix
			if {$platform=="unix"} {
				set dw [fixHebUnix $dw]
			
			#Win
			} elseif {$platform=="windows"} {
				set ind ""
				set dw [fixHebWin $dw]
			}
			.n.f0.daswort conf -justify right
 		
		 		
 		#Check for Arabic text
		} elseif { [regexp {[\u0600-\u076c]} $dw] } {
			set justify right
			source $Bidi
			#Unix
			if {$platform == "unix"} {
				set dw [fixArabUnix $dw]
			} elseif {$platform == "windows"} {
			#Win
				set ind ""
				set dw [fixArabWin $dw]
			}
			.n.f0.daswort conf -justify right
		}
	}
	return $dw
        
} ;#end setTWD

set dwtext [setTWD]
#set dwtext $dw

pack .n.f0.subtit2 .n.f0.possibilities1 -anchor w

if {$platform=="unix"} {
	pack .n.f0.possibilities2 -anchor nw
}

pack .n.f0.possibilities3 -anchor w

#Uninstall button
pack [frame .n.f0.uninst] -side bottom -fill x
button .uninst -textvariable uninst -command {source $Uninstall}
pack .uninst -in .n.f0.uninst -anchor w
