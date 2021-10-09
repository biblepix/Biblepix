# ~/Biblepix/prog/src/setup/setupEmail.tcl
# Sourced by setupBuildGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 9oct21 pv

#Create Title & msg in main frame
label .intTitleL -textvar msg::f1Tit -font bpfont3
message .intTxtM -textvar msg::f1Txt -width $tw -font bpfont1 -padx $px -pady $py
pack .intTitleL .intTxtM -in .internationalF -side top -anchor w

#Create frames
pack [frame .intTopF -padx $px] -in .internationalF -anchor w -fill x
pack [frame .intMidF -padx $px] -in .internationalF -anchor w -fill x
pack [frame .intBotF -padx $px] -in .internationalF -anchor w -fill x
#Refresh button
button .intRefreshBtn -textvar msg::refresh -bg orange -activebackground orange -command {set status [getRemoteTWDFileList]}
pack .intRefreshBtn -in .intBotF -side bottom -fill x -padx $px

##subframes
pack [frame .twdremoteTitleF -bg beige] -in .intBotF -side top -fill x -anchor w
pack [frame .twdremoteF -padx $px] -in .intBotF

label .intStatusL -textvar status -font bpfont1 -height 1 -bg $bg -relief sunken
pack .intStatusL -in .internationalF -fill x



#Locallist
label .intTwdlocalTit -textvar msg::TwdLocalTit -bg $bg -font bpfont2
pack .intTwdlocalTit -in .intTopF -side top -anchor w -fill x

#set listbox
set localLB [listbox .intTwdlocalLB -bg lightgreen -width $tw -height 0 -selectmode single -activestyle none]
set twdlist [getTwdList]
foreach i [lsort $twdlist] {
  $localLB insert end $i 
}

#Set delete button
button .intDelBtn -bg $bg -textvar msg::delete -command {
  set lbIndex [$localLB cursel]
  if {$lbIndex != ""} {
    set fileName [$localLB get active]
    file delete $twddir/$fileName
    $localLB delete $lbIndex
  }
#TODO rectify path!
#  updateMailBtnList .emailF.topF.f2.rightF
}

#TODO get frames right!
pack .intDelBtn -in .intTopF -side right -fill none
pack $localLB -in .intTopF -side left -anchor w

#Remotelist
label .intTwdremoteTit -textvar msg::TwdRemoteTit -bg $bg -justify left -font bpfont2 -padx $px -pady $py
pack .intTwdremoteTit -in .intMidF -side top -fill x

#pack [frame .internationalF.f3] -anchor w -fill x -padx $px

#Titel frame
#pack [frame .twdremoteTitleF -bg beige] -in .internationalF.f3 -fill x -anchor w
label .twdremote1L -font "SmallCaptionFont 8" -textvar msg::language -font TkFixedFont -bg beige -anchor w -width 20
label .twdremote2L -font "SmallCaptionFont 8" -textvar msg::year -font TkFixedFont -bg beige -anchor w -width 14
label .twdremote3L -font "SmallCaptionFont 8" -textvar msg::biblename -font TkFixedFont -bg beige -anchor w -width 59
label .twdremote4L -font "SmallCaptionFont 8" -textvar msg::bibleversion -font TkFixedFont -bg beige -anchor w
pack .twdremote1L .twdremote2L .twdremote3L .twdremote4L -in .twdremoteTitleF -side left

#setup remotelist (inserted later by http.tcl)
#frame .internationalF.twdremoteframe -padx $px
listbox .twdremoteLB -yscrollcommand {.twdremoteSB set} -selectmode multiple -activestyle none -font TkFixedFont -width [expr $wWidth - 50] -height [expr $wHeight - 300] -bg lightblue
scrollbar .twdremoteSB -command {.twdremoteLB yview}
button .downloadBtn -textvar msg::download -command {
  downloadTWDFiles
  catch {updateMailBtnList .emailF.topF.f2.rightF}
}

#pack .internationalF.twdremoteframe -anchor w
pack .downloadBtn -in .twdremoteF -side right -fill x
pack .twdremoteSB .twdremoteLB -in .twdremoteF -side right -fill y
