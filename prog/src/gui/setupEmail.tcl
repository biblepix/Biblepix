# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 12nov17

label .n.f3.t1 -textvar f3.tit -font bpfont3
pack .n.f3.t1 -anchor w

checkbutton .n.f3.sigyes -textvar f3.btn -variable sigyesState
pack .n.f3.sigyes -anchor w

if {$enablesig==1} {
  set sigyesState 1
} else {
  set sigyesState 0  
}
pack [frame .n.f3.topframe] -expand false -fill x
pack [frame .n.f3.topframe.left] -side left -expand false 
pack [frame .n.f3.topframe.right] -side right -expand 0
.n.f3.topframe.right configure -borderwidth 2 -relief sunken -padx 50 -pady 30 -bg $bg

#Create Message
message .n.f3.topframe.left.t2 -font bpfont1  -padx $px -pady $py -textvar f3.txt 
pack .n.f3.topframe.left.t2 -anchor nw

#Create Label 1
set sigLabel1 [label .n.f3.topframe.right.sig -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable f3dw]

#Create Label 2
set sigLabel2 [label .n.f3.topframe.right.sig2 -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable dwsig]

#Adapt $dwtext for signature 
set dwsig $dwtext
regsub -all {\*} $dwsig {=====} dwsig

#Justify right for Hebrew & Arabic
if { [regexp {[\u05d0-\u076c]} $dwsig] } {
  $sigLabel2 configure -justify right
}

pack $sigLabel1 $sigLabel2 -anchor w
