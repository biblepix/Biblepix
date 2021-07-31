# ~/Biblepix/prog/src/setup/setupEmail.tcl
# Sourced by setupBuildGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 31jul21 pv

#Statusbar
frame .internationalF.f0 -padx $px
pack .internationalF.f0 -side bottom -fill x
label .internationalF.status -textvar status -font bpfont1 -height 1 -bg $bg -relief sunken
pack .internationalF.status -in .internationalF.f0 -fill x

#Refresh button
button .internationalF.refbtn -text "[mc refresh]" -bg orange -activebackground orange -command {set status [getRemoteTWDFileList]}
pack .internationalF.refbtn -side bottom -fill x -padx $px

#Title
label .internationalF.titel -text "[mc f1Tit]" -font bpfont3
message .internationalF.txt -text "[mc f1Txt]" -width $tw -font bpfont1 -padx $px -pady $py
pack .internationalF.titel .internationalF.txt -anchor w

#Locallist
frame .internationalF.f1 -padx $px
pack .internationalF.f1 -anchor w -fill x

label .internationalF.f1.twdlocaltit -text "[mc TwdLocalTit]" -bg $bg -font bpfont2
pack .internationalF.f1.twdlocaltit -anchor w -fill x
#set listbox
listbox .internationalF.f1.twdlocal -bg lightgreen -width $tw -height 0 -selectmode single -activestyle none
set twdlist [getTwdList]
foreach i [lsort $twdlist] { .internationalF.f1.twdlocal insert end $i }

#Set delete button
button .internationalF.f1.delbtn -bg $bg -text "[mc delete]" -command {
  set lbIndex [.internationalF.f1.twdlocal cursel]
  if {$lbIndex != ""} {
    set fileName [.internationalF.f1.twdlocal get active]
    file delete $twddir/$fileName
    .internationalF.f1.twdlocal delete $lbIndex
  }
  updateMailBtnList .emailF.topF.f2.rightF
}

pack .internationalF.f1.delbtn -side right -fill none
pack .internationalF.f1.twdlocal -anchor w

#Remotelist
frame .internationalF.f2 -padx $px
pack .internationalF.f2 -anchor w -fill x
label .internationalF.f2.twdremotetit -text "[mc TwdRemoteTit]" -bg $bg -justify left -font bpfont2 -padx $px -pady $py
pack .internationalF.f2.twdremotetit -fill x
pack [frame .internationalF.f3] -anchor w -fill x -padx $px
#Titel frame
pack [frame .twdremoteTitleF -bg beige] -in .internationalF.f3 -fill x -anchor w
label .twdremote1L -font "SmallCaptionFont 8" -text "[mc language]" -font TkFixedFont -bg beige -anchor w -width 20
label .twdremote2L -font "SmallCaptionFont 8" -text "[mc year]" -font TkFixedFont -bg beige -anchor w -width 14
label .twdremote3L -font "SmallCaptionFont 8" -text "[mc biblename]" -font TkFixedFont -bg beige -anchor w -width 59
label .twdremote4L -font "SmallCaptionFont 8" -text "[mc bibleversion]" -font TkFixedFont -bg beige -anchor w
pack .twdremote1L .twdremote2L .twdremote3L .twdremote4L -in .twdremoteTitleF -side left

#setup remotelist (inserted later by http.tcl)
frame .internationalF.twdremoteframe -padx $px
listbox .twdremoteLB -yscrollcommand {.twdremoteScr set} -selectmode multiple -activestyle none -font TkFixedFont -width [expr $wWidth - 50] -height [expr $wHeight - 300] -bg lightblue
scrollbar .twdremoteScr -command {.twdremoteLB yview}
button .downloadBtn -text Download -command {
  downloadTWDFiles
  ##window may not exist yet!
  catch {updateMailBtnList .emailF.topF.f2.rightF}
}
pack .internationalF.twdremoteframe -anchor w
pack .downloadBtn -in .internationalF.twdremoteframe -side right -fill x
pack .twdremoteScr .twdremoteLB -in .internationalF.twdremoteframe -side right -fill y
