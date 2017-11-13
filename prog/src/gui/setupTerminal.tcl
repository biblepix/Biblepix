# ~/Biblepix/prog/src/gui/setupTerminal.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 9aug17

#Create label & checkbutton
label .n.f4.t1 -textvar f4.tit -font bpfont3
checkbutton .n.f4.termyesno -textvar f4Btn -variable termyesnoState
pack .n.f4.t1 .n.f4.termyesno -anchor w
if {[info exists enableterm]} {
    if {$enableterm==1} {
        set termyesnoState 1
    }  
}

#Create frames left & right
pack [frame .n.f4.mainf] -expand false -fill x
pack [frame .n.f4.mainf.left] -side left -expand false 
pack [frame .n.f4.mainf.right] -side right -expand true -fill both

#Fill left frame
message .n.f4.mainf.left.t2 -textvar f4.txt -font bpfont1 -width 500 -padx $px -pady $py
text .n.f4.mainf.left.t3 -height 1 -bg $bg
#bash entry
.n.f4.mainf.left.t3 insert end "echo \"sh $unixdir\/term.sh\" \>\> \~\/\.bashrc"
.n.f4.mainf.left.t3 configure -state disabled
pack .n.f4.mainf.left.t2 -anchor nw -fill none
pack .n.f4.mainf.left.t3 -anchor sw -fill x
pack [label .n.f4.mainf.left.t4 -font bpfont2 -textvar expl -anchor w]

#Fill right frame
pack [label .n.f4.mainf.right.lb]
set padLeft 5

#Create bp text widget 
text .n.f4.mainf.right.bp -width 70  
set t .n.f4.mainf.right.bp
$t insert 1.0 $setupTwdText
$t configure -foreground orange -background black -pady 5 -padx 5
#change 1st line
$t tag add intro 1.0 1.end
$t tag conf intro -foreground yellow -background blue
#add last line
$t insert end "\n\nbiblepix@localhost ~ $" grün
$t tag conf grün -foreground green
pack $t
