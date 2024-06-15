# ~/Biblepix/prog/src/setup/setupEmail.tcl
# Sourced by setupBuildGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15june24 pv

#Create Title & msg in main frame - enable wrapping text at any width (1 width is by letters, the other by pixels!)
label .intTitleL -textvar msg::f1Tit -font bpfont3
label .intTxtM -textvar msg::f1Txt -font bpfont1 -padx $px -pady $py -justify left -anchor w -width 150 -wraplength 1300
pack .intTitleL .intTxtM -in .internationalF -anchor nw

.intTxtM conf -wraplength 1000 

#Create frames
pack [frame .intTopF -padx $px] -in .internationalF -anchor w -fill x -expand 1
pack [frame .intMidF -padx $px] -in .internationalF -anchor w -fill x
pack [frame .intBotF -padx $px] -in .internationalF -anchor w -fill none

#Refresh button
button .intRefreshBtn -textvar msg::refresh -bd 2 -activebackground orange -command {
  NewsHandler::QueryNews "[getRemoteTWDFileList]" orange
}
pack .intRefreshBtn -in .intBotF -side bottom -padx $px -pady 3

##subframes
pack [frame .twdremoteTitleF] -in .intBotF -side top -fill x -anchor w -padx $px -pady 5 
pack [frame .twdremoteF -padx $px] -in .intBotF
label .intStatusL -textvar status -font bpfont1 -height 1 -bg $bg -relief sunken
pack .intStatusL -in .internationalF -fill x

# Local TWD list
label .intTwdlocalTit -textvar msg::TwdLocalTit -font bpfont2 -bg lightblue
pack .intTwdlocalTit -in .intTopF -anchor w

##create local listbox & scrollbar
set localLB [listbox .intTwdlocalLB -bg beige -width [expr $tw - $px] -selectmode single -activestyle none -yscrollcommand {.intTwdlocalSB set} -bd 2]
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
pack .intDelBtn -in .intTopF -side right -padx 3 
pack .intTwdlocalSB -in .intTopF -side right -fill y
pack $localLB -in .intTopF -side left -padx $px

# R E M O T E   T W D   l i s t 
label .intTwdremoteTit -textvar msg::TwdRemoteTit -justify left -font bpfont2 -pady 3 -bg lightblue
pack .intTwdremoteTit -in .intMidF -anchor w -pady 7

##Titel frame
label .twdremote1L -font "TkCaptionFont" -textvar msg::language -anchor w -width 18
label .twdremote2L -font "TkCaptionFont" -textvar msg::year -anchor w -width 12
label .twdremote3L -font "TkCaptionFont" -textvar msg::biblename -anchor w -width 52
label .twdremote4L -font "TkCaptionFont" -textvar msg::bibleversion -anchor w
pack .twdremote1L .twdremote2L .twdremote3L .twdremote4L -in .twdremoteTitleF -side left
#Create remote listbox & scrollbar
##content inserted later by http.tcl
listbox .twdremoteLB -yscrollcommand {.twdremoteSB set} -selectmode multiple -activestyle none -font TkFixedFont -width [expr $wWidth - 50] -height [expr $wHeight - 300] -bg grey90 -bd 2
scrollbar .twdremoteSB -command {.twdremoteLB yview}
button .downloadBtn -textvar msg::download -command {
  downloadTWDFiles
  catch {updateMailBtnList .mailTop2F}
}
pack .downloadBtn -in .twdremoteF -side right -padx 3
pack .twdremoteSB .twdremoteLB -in .twdremoteF -side right -fill y
