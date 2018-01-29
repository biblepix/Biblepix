# ~/Biblepix/prog/src/gui/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated:29jan18

#Pack flags defined elsewhere
pack .en .de -in .ftop -side right

#Set headings & messages
label .nb.welcome.tit -font bpfont3 -textvar welc.tit
pack .nb.welcome.tit -anchor nw

#Set main frame / bottom frame
pack [frame .nb.welcome.ftop] -expand 0 -fill x
pack [frame .nb.welcome.ftop.left] [frame .nb.welcome.ftop.right] -side left -fill x
pack .nb.welcome.ftop.left -anchor nw
pack .nb.welcome.ftop.right -expand 1
pack [frame .nb.welcome.fbot] -expand 0 -fill x

#Set text1 left
#pack [frame .nb.welcome.ftop.f1] -expand 1 -fill x
label .nb.welcome.ftop.left.subtit1 -font bpfont2 -textvar welc.subtit1 -padx $px -pady $py
message .nb.welcome.ftop.left.whatis -textvar welc.txt1 -font bpfont1 -width [expr $wWidth/2] -justify left -padx $px
pack .nb.welcome.ftop.left.subtit1 -anchor nw
pack .nb.welcome.ftop.left.whatis  -anchor nw -side left

#Set TheWord Button right
button .nb.welcome.ftop.right.daswort -font bpfont1 -bg $bg -activebackground lightblue -fg blue -pady $py -padx $px -bd 5 
set twdWidget .nb.welcome.ftop.right.daswort
pack $twdWidget -anchor n
$twdWidget configure -command {fillWidgetWithTodaysTwd $twdWidget}
fillWidgetWithTodaysTwd $twdWidget

#Set text2 bottom
label .nb.welcome.fbot.subtit2 -font bpfont2 -textvar welc.subtit2 -padx $px -pady $py
message .nb.welcome.fbot.possibilities1 -textvar welc.txt2 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
message .nb.welcome.fbot.possibilities2 -textvar welc.txt3 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
message .nb.welcome.fbot.possibilities3 -textvar welc.txt4 -font bpfont1 -width $tw -justify left -pady 0 -padx $px

pack .nb.welcome.fbot.subtit2 .nb.welcome.fbot.possibilities1 -anchor nw
if {$platform=="unix"} {
  pack .nb.welcome.fbot.possibilities2 -anchor nw
}
pack .nb.welcome.fbot.possibilities3 -anchor nw


#pack .nb.welcome.subtit2 .nb.welcome.possibilities1 -anchor w


#Uninstall button
pack [frame .nb.welcome.uninst] -side bottom -fill x
button .uninst -textvariable uninst -command {source $Uninstall}
pack .uninst -in .nb.welcome.uninst -anchor w
