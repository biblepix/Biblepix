# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 12nov17

label .nb.email.t1 -textvar f3.tit -font bpfont3
pack .nb.email.t1 -anchor w

checkbutton .nb.email.sigyes -textvar f3.btn -variable sigyesState
pack .nb.email.sigyes -anchor w

if {$enablesig==1} {
  set sigyesState 1
} else {
  set sigyesState 0  
}
pack [frame .nb.email.topframe] -expand false -fill x
pack [frame .nb.email.topframe.left] -side left -expand false 
pack [frame .nb.email.topframe.right] -side right -expand 0
.nb.email.topframe.right configure -borderwidth 2 -relief sunken -padx 50 -pady 30 -bg $bg

#Create Message
message .nb.email.topframe.left.t2 -font bpfont1  -padx $px -pady $py -textvar f3.txt 
pack .nb.email.topframe.left.t2 -anchor nw

#Create Label 1
set sigLabel1 [label .nb.email.topframe.right.sig -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable f3dw]

#Create Label 2
set sigLabel2 [label .nb.email.topframe.right.sig2 -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable dwsig]

#Adapt $setupTwdText for signature 
set dwsig [getTodaysTwdSig $setupTwdFileName]

#Justify right for Hebrew & Arabic
if { [isRtL [getTwdLanguage $setupTwdFileName]] } {
  $sigLabel2 configure -justify right
}

pack $sigLabel1 $sigLabel2 -anchor w
