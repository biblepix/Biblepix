# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 12may19

#Statusbar
frame .internationalF.f0 -padx $px
pack .internationalF.f0 -side bottom -fill x
label .internationalF.status -textvar status -font bpfont1 -height 1 -bg $bg -relief sunken
pack .internationalF.status -in .internationalF.f0 -fill x

#Refresh button
button .internationalF.refbtn -textvariable refresh -bg lightblue -command {set status [getRemoteTWDFileList]}
pack .internationalF.refbtn -side bottom -fill x -padx $px

#Title
label .internationalF.titel -textvar f1.tit -font bpfont3
message .internationalF.txt -textvar f1.txt -width $tw -font bpfont1 -padx $px -pady $py
pack .internationalF.titel .internationalF.txt -anchor w

#Locallist
frame .internationalF.f1 -padx $px
pack .internationalF.f1 -anchor w -fill x

label .internationalF.f1.twdlocaltit -textvar f1.twdlocaltit -bg $bg -font bpfont2
pack .internationalF.f1.twdlocaltit -anchor w -fill x
#set listbox
listbox .internationalF.f1.twdlocal -bg lightgreen -width $tw -height 0 -selectmode single -activestyle none
set twdlist [getTWDlist]
foreach i [lsort $twdlist] { .internationalF.f1.twdlocal insert end $i }

#Set deletebutton
button .internationalF.f1.delbtn -bg $bg -textvar delete -command {
  set lbIndex [.internationalF.f1.twdlocal cursel]
  if {$lbIndex != ""} {
    set fileName [.internationalF.f1.twdlocal get active]
    file delete $dirlist(twdDir)/$fileName
    .internationalF.f1.twdlocal delete $lbIndex
  }
}

pack .internationalF.f1.delbtn -side right -fill none
pack .internationalF.f1.twdlocal -anchor w

#Remotelist
frame .internationalF.f2 -padx $px
pack .internationalF.f2 -anchor w -fill x

label .internationalF.f2.twdremotetit -textvar f1.twdremotetit -bg $bg -justify left -font bpfont2 -padx $px
pack .internationalF.f2.twdremotetit -fill x

pack [frame .internationalF.f3] -anchor w -fill x
label .internationalF.f3.twdremotetit2 -textvar f1.twdremotetit2 -width 0 -padx 20
pack .internationalF.f3.twdremotetit2 -side left

#set remotelist ( inserted later by http.tcl)
frame .internationalF.twdremoteframe -width $wWidth -padx $px
listbox .internationalF.twdremoteframe.lb -yscrollcommand {.internationalF.twdremoteframe.sb set} -selectmode multiple -activestyle none -font TkFixedFont -width [expr $wWidth - 50] -height [expr $wHeight - 300] -bg lightblue
scrollbar .internationalF.twdremoteframe.sb -command {.internationalF.twdremoteframe.lb yview}

#set Download button
button .internationalF.twdremoteframe.downloadBtn -text Download -command downloadTWDFiles
pack .internationalF.twdremoteframe -anchor w
pack .internationalF.twdremoteframe.downloadBtn -side right -fill x
pack .internationalF.twdremoteframe.sb -side right -fill y
pack .internationalF.twdremoteframe.lb -side left -fill x
