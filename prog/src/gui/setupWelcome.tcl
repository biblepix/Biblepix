# ~/Biblepix/prog/src/gui/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated:21apr17

#Pack flags defined elsewhere
pack .en .de -in .ftop -side right

#Set headings & messages
label .n.f0.tit -font bpfont3 -textvar welc.tit
pack .n.f0.tit -anchor nw

#Set main frame / bottom frame
pack [frame .n.f0.ftop] -expand 0 -fill x
pack [frame .n.f0.ftop.left] [frame .n.f0.ftop.right] -side left -fill x
pack .n.f0.ftop.left -anchor nw
pack .n.f0.ftop.right -expand 1
pack [frame .n.f0.fbot] -expand 0 -fill x

#Set text1 left
#pack [frame .n.f0.ftop.f1] -expand 1 -fill x
label .n.f0.ftop.left.subtit1 -font bpfont2 -textvar welc.subtit1 -padx $px -pady $py
message .n.f0.ftop.left.whatis -textvar welc.txt1 -font bpfont1 -width [expr $wWidth/2] -justify left -padx $px
pack .n.f0.ftop.left.subtit1 -anchor nw
pack .n.f0.ftop.left.whatis  -anchor nw -side left

#Set TheWord Button right
button .n.f0.ftop.right.daswort -font bpfont1 -textvar dwtext -bg $bg -activebackground lightblue -fg blue -pady $py -padx $px -bd 5 
set dwWidget .n.f0.ftop.right.daswort
pack $dwWidget -anchor n
source $Twdtools
$dwWidget configure -command {set dwtext [setTWDWelcome $dwWidget]}
set dwtext [setTWDWelcome $dwWidget]

#Set text2 bottom
label .n.f0.fbot.subtit2 -font bpfont2 -textvar welc.subtit2 -padx $px -pady $py
message .n.f0.fbot.possibilities1 -textvar welc.txt2 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
message .n.f0.fbot.possibilities2 -textvar welc.txt3 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
message .n.f0.fbot.possibilities3 -textvar welc.txt4 -font bpfont1 -width $tw -justify left -pady 0 -padx $px

pack .n.f0.fbot.subtit2 .n.f0.fbot.possibilities1 -anchor nw
if {$platform=="unix"} {
	pack .n.f0.fbot.possibilities2 -anchor nw
}
pack .n.f0.fbot.possibilities3 -anchor nw


#pack .n.f0.subtit2 .n.f0.possibilities1 -anchor w


#Uninstall button
pack [frame .n.f0.uninst] -side bottom -fill x
button .uninst -textvariable uninst -command {source $Uninstall}
pack .uninst -in .n.f0.uninst -anchor w
