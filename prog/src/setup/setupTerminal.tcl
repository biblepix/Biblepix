# ~/Biblepix/prog/src/setup/setupTerminal.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 6nov21 pv

#Create label & checkbutton
label .termMainTit -textvar msg::f4Tit -font bpfont3 -pady 15
checkbutton .termYesnoCB -textvar msg::f4Btn -variable termyesnoState
pack .termMainTit .termYesnoCB -in .terminalF -anchor w
if {[info exists enableterm]} {
  if {$enableterm==1} {
    set termyesnoState 1
  }  
}

# C r e a t e  m a i n  f r a m e s
pack [frame .termMainF] -in .terminalF -fill both
pack [frame .termLeftF] -in .termMainF -side left -anchor nw 
pack [frame .termRightF] -in .termMainF -side right -anchor ne -padx 25 -pady 25

# F i l l   l e f t   f r a m e
message .termMainM -textvar msg::f4Txt -font bpfont1 -width 700 -padx $px -pady $py
pack .termMainM -in .termLeftF -anchor nw

# F i l l   r i g h t   f r a m e
#Create bp text widget 
text .termTwdT -width 60 -borderwidth 7
set t .termTwdT
pack $t -in .termRightF -anchor ne -pady 25 -pady 25

##insert whole TWD text from line 1.0
$t insert 1.0 $setupTwdText
$t conf -foreground orange -background black -font twdwidgetfont

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
