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
pack [frame .n.f3.topframe.right] -side right -expand true

message .n.f3.topframe.left.t2 -textvar f3.txt -font bpfont1 -width 0 -padx $px -pady $py
pack .n.f3.topframe.left.t2 -anchor nw

#Create Label mit aktuellem Vers
set sigLabel [label .n.f3.topframe.right.sig -font TkIconFont -bg $bg -relief sunken -width 60 -foreground blue -pady 3 -padx 3 -justify left -textvariable dwSig]

#Create new variable 
set dwsig $dwtext
regsub -all {\*} $dwsig {=====} dwsig

#Justify right for Hebrew & Arabic
if { [regexp {[\u05d0-\u05ea]} $dwsig] } {
  $sigLabel configure -justify right
}

if { [regexp {[\u0600-\u076c]} $dwsig] } {
  $sigLabel configure -justify right
}
    
set dwSig [join [list $f3dw $dwsig] \n] 
pack .n.f3.topframe.right.sig -anchor nw
