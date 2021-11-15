# ~/Biblepix/prog/src/setup/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15nov21 pv

#Create frames & titles
pack [frame .mailLeftF] -in .emailF -side left -anchor nw
pack [frame .mailRightF] -in .emailF -side right -anchor ne -fill both
pack [frame .mailTop1F] -in .mailRightF -fill x
pack [frame .mailTop2F] -in .mailRightF -fill x
pack [frame .mailBotRightF -bg $bg -bd 5 -relief sunken -pady 30 -padx 30] -in .mailRightF -fill both -padx 30 -pady 30 -anchor center

#Create labels & widgets
label .mailMainTit -textvar msg::f3Tit -font bpfont3
label .mailDesiredlangL -textvar msg::f3Sprachen -font bpfont1 -bg beige -bd 1 -relief sunken -padx 7 -pady 3
checkbutton .mailSigyesnoCB -textvar msg::f3Btn -variable sigyesState -command {toggleBtnstate}
pack .mailMainTit -in .mailLeftF -anchor w
pack .mailSigyesnoCB -in .mailLeftF -anchor w 
pack .mailDesiredlangL -in .mailTop1F -side right -anchor ne -pady $py
updateMailBtnList .mailTop2F

# PRESELECT LANGUAGE BUTTONS

##A) $sigLanglist exists, but files may have been deleted
if {[info exists sigLanglist] && $sigLanglist != ""} {
  
  foreach code $sigLanglist {
      set Btn .${code}Btn
      catch {$Btn select}
  }

##B) $sigLanglist not found
} else {

  #select language button for lang var
  if [winfo exists .${lang}Btn] {
    catch {.${lang}Btn select}
  }
}

if $enablesig {
  set sigyesState 1
} else {
  set sigyesState 0
}

#Create Message
message .mailMainM -font bpfont1 -padx $px -pady $py -textvar msg::f3Txt 
pack .mailMainM -in .mailLeftF -anchor nw
#Create Twd text
set twdfile [getRandomTwdFile 0]
set dwsig [getTodaysTwdSig $twdfile 1]

#Create E-Mail widgets
label .mailSigL -font twdwidgetfont -bg $bg -fg blue -textvar msg::f3Expl -justify left
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
