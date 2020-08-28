# ~/Biblepix/prog/src/gui/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated:10may18

#Pack flags defined elsewhere
pack .en .de -in .ftop -side right

#Set headings & messages
label .welcomeF.tit -font bpfont3 -textvar welc.tit
pack .welcomeF.tit -anchor nw

#Set main frame / bottom frame
pack [frame .welcomeF.ftop] -expand 0 -fill x
pack [frame .welcomeF.ftop.left] [frame .welcomeF.ftop.right] -side left -fill x
pack .welcomeF.ftop.left -anchor nw
pack .welcomeF.ftop.right -expand 1
pack [frame .welcomeF.fbot] -expand 0 -fill x

#Set text1 left
#pack [frame .welcomeF.ftop.f1] -expand 1 -fill x
label .welcomeF.ftop.left.subtit1 -font bpfont2 -textvar welc.subtit1 -padx $px -pady $py
message .welcomeF.ftop.left.whatis -textvar welc.txt1 -font bpfont1 -width [expr $wWidth/2] -justify left -padx $px
pack .welcomeF.ftop.left.subtit1 -anchor nw
pack .welcomeF.ftop.left.whatis  -anchor nw -side left

#Set TheWord Button right
button .welcomeF.ftop.right.daswort -font bpfont1 -bg $bg -activebackground lightblue -fg blue -pady $py -padx $px -bd 5 
set twdWidget .welcomeF.ftop.right.daswort
pack $twdWidget -anchor n
$twdWidget configure -command {fillWidgetWithTodaysTwd $twdWidget}
fillWidgetWithTodaysTwd $twdWidget

#Set text2 bottom - TODO change "Möglichkeiten" to formatted text widget!!!
label .welcomeF.fbot.subtit2 -font bpfont2 -textvar welc.subtit2 -padx $px -pady $py
message .welcomeF.fbot.possibilities1 -textvar welc.txt2 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
message .welcomeF.fbot.possibilities2 -textvar welc.txt3 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
message .welcomeF.fbot.possibilities3 -textvar welc.txt4 -font bpfont1 -width $tw -justify left -pady 0 -padx $px

pack .welcomeF.fbot.subtit2 .welcomeF.fbot.possibilities1 -anchor nw
if {$platform=="unix"} {
  pack .welcomeF.fbot.possibilities2 -anchor nw
}
pack .welcomeF.fbot.possibilities3 -anchor nw

#Uninstall button
pack [frame .welcomeF.uninst] -side bottom -fill x
button .uninst -textvariable uninst -command {source $Uninstall}
pack .uninst -in .welcomeF.uninst -anchor w
