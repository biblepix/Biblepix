# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 29jan18

#Statusbar
frame .nb.international.f0 -padx $px
pack .nb.international.f0 -side bottom -fill x
label .nb.international.status -textvar status -font bpfont1 -height 1 -bg $bg -relief sunken
pack .nb.international.status -in .nb.international.f0 -fill x

#Refresh button
button .nb.international.refbtn -textvariable refresh -bg lightblue -command {set status [getRemoteTWDFileList]}
pack .nb.international.refbtn -side bottom -fill x -padx $px

#Title
label .nb.international.titel -textvar f1.tit -font bpfont3
message .nb.international.txt -textvar f1.txt -width $tw -font bpfont1 -padx $px -pady $py
pack .nb.international.titel .nb.international.txt -anchor w

#Locallist
frame .nb.international.f1 -padx $px
pack .nb.international.f1 -anchor w -fill x

label .nb.international.f1.twdlocaltit -textvar f1.twdlocaltit -bg $bg -font bpfont2
pack .nb.international.f1.twdlocaltit -anchor w -fill x
#set listbox
listbox .nb.international.f1.twdlocal -bg lightgreen -width $tw -height 0 -selectmode single -activestyle none
set twdlist [getTWDlist]
foreach i [lsort $twdlist] { .nb.international.f1.twdlocal insert end $i }
#set deletebutton
button .nb.international.f1.delbtn -bg $bg -textvar delete -command {
  file delete $twdDir/[.nb.international.f1.twdlocal get active]
  .nb.international.f1.twdlocal delete [.nb.international.f1.twdlocal curselection]
}

pack .nb.international.f1.delbtn -side right -fill none
pack .nb.international.f1.twdlocal -anchor w

#Remotelist
frame .nb.international.f2 -padx $px
pack .nb.international.f2 -anchor w -fill x

label .nb.international.f2.twdremotetit -textvar f1.twdremotetit -bg $bg -justify left -font bpfont2 -padx $px
pack .nb.international.f2.twdremotetit -fill x

pack [frame .nb.international.f3] -anchor w -fill x
label .nb.international.f3.twdremotetit2 -textvar f1.twdremotetit2 -width 0 -padx 20
pack .nb.international.f3.twdremotetit2 -side left

#set remotelist ( inserted later by http.tcl)
frame .nb.international.twdremoteframe -width $wWidth -padx $px
listbox .nb.international.twdremoteframe.lb -yscrollcommand {.nb.international.twdremoteframe.sb set} -selectmode multiple -activestyle none -font TkFixedFont -width [expr $wWidth - 50] -height [expr $wHeight - 300] -bg lightblue
scrollbar .nb.international.twdremoteframe.sb -command {.nb.international.twdremoteframe.lb yview}

#set Download button
button .nb.international.twdremoteframe.downloadBtn -text Download -command downloadTWDFiles
pack .nb.international.twdremoteframe -anchor w
pack .nb.international.twdremoteframe.downloadBtn -side right -fill x
pack .nb.international.twdremoteframe.sb -side right -fill y
pack .nb.international.twdremoteframe.lb -side left -fill x