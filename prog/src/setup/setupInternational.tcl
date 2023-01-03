# ~/Biblepix/prog/src/setup/setupEmail.tcl
# Sourced by setupBuildGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 3jan23 pv

#Create Title & msg in main frame
label .intTitleL -textvar msg::f1Tit -font bpfont3
message .intTxtM -textvar msg::f1Txt -width $tw -font bpfont1 -padx $px -pady $py
pack .intTitleL .intTxtM -in .internationalF -side top -anchor w

#Create frames
pack [frame .intTopF -padx $px] -in .internationalF -anchor w -fill x -expand 1
pack [frame .intMidF -padx $px] -in .internationalF -anchor w -fill x
pack [frame .intBotF -padx $px] -in .internationalF -anchor w -fill x


#Refresh button
button .intRefreshBtn -textvar msg::refresh -bg orange -activebackground orange -command {
  NewsHandler::QueryNews "[getRemoteTWDFileList]" orange
}
pack .intRefreshBtn -in .intBotF -side bottom -fill x -padx $px

##subframes
pack [frame .twdremoteTitleF -bg beige] -in .intBotF -side top -fill x -anchor w -padx $px
pack [frame .twdremoteF -padx $px] -in .intBotF
label .intStatusL -textvar status -font bpfont1 -height 1 -bg $bg -relief sunken
pack .intStatusL -in .internationalF -fill x

# Local TWD list
label .intTwdlocalTit -textvar msg::TwdLocalTit -font bpfont2
pack .intTwdlocalTit -in .intTopF -side top -anchor w -fill x
##create local listbox & scrollbar
set localLB [listbox .intTwdlocalLB -bg lightgreen -width [expr $tw - $px] -selectmode single -activestyle none -yscrollcommand {.intTwdlocalSB set}]
scrollbar .intTwdlocalSB -command {$localLB yview}
##fill listbox
set twdlist [getTwdList]
foreach i [lsort $twdlist] {
  $localLB insert end $i 
}
##create delete button
button .intDelBtn -bg $bg -textvar msg::delete -command {
  set lbIndex [$localLB cursel]
  if {$lbIndex != ""} {
    set fileName [$localLB get active]
    file delete $twddir/$fileName
    $localLB delete $lbIndex
  }
  updateMailBtnList .mailTop2F
}
pack .intDelBtn -in .intTopF -side right 
pack .intTwdlocalSB -in .intTopF -side right -fill y
pack $localLB -in .intTopF -side left -padx $px

# R E M O T E   T W D   l i s t 
label .intTwdremoteTit -textvar msg::TwdRemoteTit -justify left -font bpfont2 -padx $px -pady $py
pack .intTwdremoteTit -in .intMidF -side top -fill x
##Titel frame
label .twdremote1L -font "SmallCaptionFont 8" -textvar msg::language -font TkFixedFont -bg beige -anchor w -width 20
label .twdremote2L -font "SmallCaptionFont 8" -textvar msg::year -font TkFixedFont -bg beige -anchor w -width 14
label .twdremote3L -font "SmallCaptionFont 8" -textvar msg::biblename -font TkFixedFont -bg beige -anchor w -width 59
label .twdremote4L -font "SmallCaptionFont 8" -textvar msg::bibleversion -font TkFixedFont -bg beige -anchor w
pack .twdremote1L .twdremote2L .twdremote3L .twdremote4L -in .twdremoteTitleF -side left
#Create remote listbox & scrollbar
##content inserted later by http.tcl
listbox .twdremoteLB -yscrollcommand {.twdremoteSB set} -selectmode multiple -activestyle none -font TkFixedFont -width [expr $wWidth - 50] -height [expr $wHeight - 300] -bg lightblue
scrollbar .twdremoteSB -command {.twdremoteLB yview}
button .downloadBtn -textvar msg::download -command {
  downloadTWDFiles
  catch {updateMailBtnList .mailTop2F}
}
pack .downloadBtn -in .twdremoteF -side right -fill x
pack .twdremoteSB .twdremoteLB -in .twdremoteF -side right -fill y
