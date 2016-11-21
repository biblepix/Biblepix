# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 2nov16

label .n.f3.t1 -textvar f3.tit -font $f3
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

message .n.f3.topframe.left.t2 -textvar f3.txt -font $f1 -width 0 -padx $px -pady $py
pack .n.f3.topframe.left.t2 -anchor nw

label .n.f3.topframe.right.sig -font TkIconFont -bg $bg -relief sunken -width 60 -foreground blue -pady 3 -padx 3 -justify left -textvar f3.ex
pack .n.f3.topframe.right.sig -anchor nw
