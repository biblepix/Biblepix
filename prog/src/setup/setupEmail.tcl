	# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 13oct21 pv

#Create frames & titles
pack [frame .mailTopF] -in .emailF -fill x

#TODO get mailBtn list righ!
#strangely it comes right when deleting a btn in SetupInternational, caused by [updateMailBtnList]!!!
pack [frame .mailTop1F -bg red] -in .mailTopF -fill x
pack [frame .mailTop2F -bg green] -in .mailTopF -fill x -anchor e
pack [frame .mailBotF] -in .emailF -fill both
pack [frame .mailBotLeftF] -in .mailBotF -side left -anchor nw
pack [frame .mailBotRightF -padx 30 -pady 30 -bd 5 -bg $bg -relief sunken] -in .mailBotF -side right -padx 100 

#Create labels & widgets
label .mailMainTit -textvar msg::f3Tit -font bpfont3
label .mailDesiredlangL -textvar msg::f3Sprachen -font bpfont1 -bg beige -bd 1 -relief sunken -padx 7 -pady 3
checkbutton .mailSigyesnoCB -textvar msg::f3Btn -variable sigyesState -command {toggleBtnstate}
pack .mailMainTit -in .mailTop1F -side left
pack .mailDesiredlangL -in .mailTop1F -side right -anchor ne -pady 10 -padx 100
pack .mailSigyesnoCB -in .mailTop2F -side left -anchor nw
pack [frame .mailRight2F] -in .mailTop2F -side right -padx 100 -pady $py

#Set button list
updateMailBtnList .mailRight2F

##called by .sigyes Btn to enable/disable lang checkbuttons
proc toggleBtnstate {} {
  global sigLangBtnList sigyesState
  
  if {![info exists sigLangBtnList] || $sigLangBtnList== ""} {
    return
  }

  foreach cb $sigLangBtnList {
    if $sigyesState {
      $cb conf -state normal
    } else {
      $cb conf -state disabled
    }
  }
}

# PRESELECT LANGUAGE BUTTONS

##A) $sigLanglist exists, but files may have been deleted
if {[info exists sigLanglist] && $sigLanglist != ""} {
  
  foreach code $sigLanglist {
      set Btn .${code}Btn
      $Btn select
  }

##B) $sigLanglist not found
} else {

  #select language button for lang var
  if [winfo exists .${lang}Btn] {
    .${lang}Btn select
  }
}

if $enablesig {
  set sigyesState 1
} else {
  set sigyesState 0
}

#Create Message
message .mailMainM -font bpfont1 -padx $px -pady $py -textvar msg::f3Txt 
pack .mailMainM -in .mailBotLeftF -anchor nw
#Create Twd text
set twdfile [getRandomTwdFile 0]
set dwsig [getTodaysTwdSig $twdfile 1]

#Create E-Mail widgets
label .mailSigL -font twdwidgetfont -bg $bg -fg blue -justify left -textvar msg::f3Expl
text .mailSigT -font twdwidgetfont -background $bg -foreground blue -bd 0
.mailSigT insert 1.0 $dwsig

##right justify www line
set wwwline [.mailSigT search bible2 5.0]
set dotpos [string first . $wwwline]
set lineNo [string range $wwwline 0 $dotpos-1]
.mailSigT tag add www $lineNo.0 end
.mailSigT tag conf www -justify right
.mailSigT conf -height $lineNo

##justify right for Hebrew & Arabic
if [isBidi $dwsig] {
  .mailSigT tag add rtl 1.0 end
  .mailSigT tag conf rtl -justify right
  .mailSigT tag conf www -justify left
}

pack .mailSigL .mailSigT -in .mailBotRightF -anchor w
