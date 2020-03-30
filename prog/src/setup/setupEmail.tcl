# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 31mch20

label .emailF.t1 -textvar f3.tit -font bpfont3
pack .emailF.t1 -anchor w

pack [frame .emailF.titelF -pady 20] -fill x

checkbutton .emailF.titelF.sigyes -textvar f3.btn -variable sigyesState
label .emailF.titelF.sprachenL -textvar f3.sprachen -bg lightblue

pack [frame .emailF.topframe] -expand false -fill x
pack [frame .emailF.topframe.left] -side left -expand false 
pack [frame .emailF.topframe.right] -side right -expand 0
.emailF.topframe.right configure -borderwidth 2 -relief sunken -padx 50 -pady 30 -bg $bg

#Set Sprachbuttons nach Sprachkürzeln 
foreach L [glob -tail -directory $twdDir *.twd] {
  lappend langlist $L
}

foreach e $langlist {
  lappend codelist [string range $e 0 1]
}

set CodeList [lsort -decreasing -unique $codelist]
puts $CodeList

foreach code $CodeList {
  checkbutton .${code}CB -text $code -bg lightblue -highlightbackground blue
  pack .${code}CB -in .emailF.titelF -side right
}

if {$lang == "de"} {
  .deCB select
} elseif {$lang == "en"} {
  .enCB select
}

pack .emailF.titelF.sprachenL -side right
pack .emailF.titelF.sigyes -anchor w -side left

if {$enablesig==1} {
  set sigyesState 1
#  set codeState 1
#  foreach s [pack slaves .emailF.titelF] {$s conf -state normal}
} else {
  set sigyesState 0
#  set codeState 0  
#  foreach s [pack slaves .emailF.titelF] {$s conf -state disabled;.emailF.titelF.sigyes conf -state normal}
}

#Create Message
message .emailF.topframe.left.t2 -font bpfont1  -padx $px -pady $py -textvar f3.txt 
pack .emailF.topframe.left.t2 -anchor nw

#Create Label 1
set sigLabel1 [label .emailF.topframe.right.sig -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable f3dw]

#Create Label 2
set sigLabel2 [label .emailF.topframe.right.sig2 -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable dwsig]

#Adapt $setupTwdText for signature 
if { [catch {set dwsig [getTodaysTwdSig $setupTwdFileName]}] } {
  set dwsig "----\n $::noTwdFilesFound"
}

#Justify right for Hebrew & Arabic
if { [isRtL [getTwdLang $setupTwdFileName]] } {
  $sigLabel2 configure -justify right
}

pack $sigLabel1 $sigLabel2 -anchor w

#TODO remove after testing
proc prob {langlist} {
foreach e $langlist {
  set letter [string index $e 0]
  set i 0
  
  while [string is alpha $letter] {
    append code $letter
    incr i
    set letter [string index $e $i]
    
  }
  
  lappend ::codelist $code
}
}
