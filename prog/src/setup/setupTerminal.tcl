# ~/Biblepix/prog/src/setup/setupTerminal.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 13apr21 pv

#Create label & checkbutton
label .terminalF.t1 -textvar f4.tit -font bpfont3
checkbutton .terminalF.termyesno -textvar f4Btn -variable termyesnoState
pack .terminalF.t1 .terminalF.termyesno -anchor w
if {[info exists enableterm]} {
  if {$enableterm==1} {
    set termyesnoState 1
  }  
}

# C r e a t e  m a i n  f r a m e s
pack [frame .terminalF.mainF] -fill both -expand 1
pack [frame .terminalF.mainF.left] -side left -expand 1 -anchor nw 
pack [frame .terminalF.mainF.right] -side right -anchor ne -padx 25 -pady 25

# F i l l   l e f t   f r a m e
message .termMsg -textvar f4.txt -font bpfont1 -width 500 -padx $px -pady $py
label .termL -font bpfont2 -textvar expl -anchor nw
pack .termMsg -in .terminalF.mainF.left -anchor nw
pack .termL -in .terminalF.mainF.left -anchor nw

# F i l l   r i g h t   f r a m e
#Create bp text widget 
text .termTwdT -width 70 -borderwidth 7
set t .termTwdT
pack $t -in .terminalF.mainF.right -anchor ne -pady 25 -pady 25

##insert whole TWD text from line 1.0
$t insert 1.0 $setupTwdText
$t conf -foreground orange -background black -font "Luxi 16"

#mark all text as right-flushing if RtL
if [isBidi $setupTwdText] {
  $t tag add rtl 1.0 end
  $t tag conf rtl -justify right
}
##colour title line
$t tag add tit 1.0 1.end
$t tag conf tit -foreground yellow -background blue
##colour refs
set tab [string repeat \u00A0 7]
$t tag conf ref -foreground green3
set reflines [$t search -all $tab 1.0 end]
puts $reflines
foreach refline $reflines {
  set dotpos [string first . $refline]
  set lineNo [string range $refline 0 $dotpos-1]
  $t tag add ref $lineNo.0 $lineNo.end 
}
##add last line
$t insert end "\nbiblepix@localhost ~ $" www
$t tag conf www -justify left -foreground green
