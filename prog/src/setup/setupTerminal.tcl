# ~/Biblepix/prog/src/gui/setupTerminal.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 29oct18

#Create label & checkbutton
label .terminalF.t1 -textvar f4.tit -font bpfont3
checkbutton .terminalF.termyesno -textvar f4Btn -variable termyesnoState
pack .terminalF.t1 .terminalF.termyesno -anchor w
if {[info exists enableterm]} {
  if {$enableterm==1} {
    set termyesnoState 1
  }  
}

#Create frames left & right
pack [frame .terminalF.mainf] -expand false -fill x
pack [frame .terminalF.mainf.left] -side left -expand false 
pack [frame .terminalF.mainf.right] -side right -expand true -fill both

#Fill left frame
message .terminalF.mainf.left.t2 -textvar f4.txt -font bpfont1 -width 500 -padx $px -pady $py
#text .terminalF.mainf.left.t3 -height 1 -bg $bg
#bash entry
#.terminalF.mainf.left.t3 insert end "echo \"sh $unixdir\/term.sh\" \>\> \~\/\.bashrc"
#.terminalF.mainf.left.t3 configure -state disabled
pack .terminalF.mainf.left.t2 -anchor nw -fill none
#pack .terminalF.mainf.left.t3 -anchor sw -fill x
pack [label .terminalF.mainf.left.t4 -font bpfont2 -textvar expl -anchor w]

#Fill right frame
pack [label .terminalF.mainf.right.lb]
set padLeft 5

#Create bp text widget 
text .terminalF.mainf.right.bp -width 70  
set t .terminalF.mainf.right.bp
$t insert 1.0 $setupTwdText
$t configure -foreground orange -background black -pady 5 -padx 5
##Colour 1st line
$t tag add intro 1.0 1.end
$t tag conf intro -foreground yellow -background blue

##Colour refLines
set refL1 [$t search "                  " 1.0 end]
set refL2 [$t count -lines 1.0 end].0
$t tag add refL $refL1 [string index $refL1 0].end
$t tag add refL $refL2 end
$t tag conf refL -foreground lightgreen -background black

#add last line
$t insert end "\nbiblepix@localhost ~ $" grün
$t tag conf grün -foreground green
pack $t
