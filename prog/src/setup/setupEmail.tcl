# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 24pr21 pv

#Create frames & titles
pack [frame .emailF.topF] -fill x
pack [frame .emailF.topF.f1] -fill x
pack [frame .emailF.topF.f2] -fill x
pack [frame .emailF.botF] -fill both
pack [frame .emailF.botF.left] -side left -anchor nw
pack [frame .emailF.botF.right -padx 30 -pady 30 -bd 5 -bg $bg -relief sunken] -side right -padx 100 

#Create labels & widgets
label .mainTit -textvar f3.tit -font bpfont3
label .wunschsprachenTit -textvar f3.sprachen -font bpfont1 -bg beige -bd 1 -relief sunken -padx 7 -pady 3 ;#-fg [gradient beige -0.3]
checkbutton .sigyesnoBtn -textvar f3.btn -variable sigyesState -command {toggleBtnstate}
pack .mainTit -in .emailF.topF.f1 -side left
pack .wunschsprachenTit -in .emailF.topF.f1 -side right -anchor ne -pady 10 -padx 100
pack .sigyesnoBtn -in .emailF.topF.f2 -side left -anchor nw
pack [frame .emailF.topF.f2.rightF] -side right -padx 100 -pady $py

updateMailBtnList .emailF.topF.f2.rightF

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

#Preselect language Buttons:
##A) $sigLanglist exists, but files may have been deleted
if {[info exists sigLanglist] && $sigLanglist != ""} {
  foreach code $sigLanglist {
    if [file exists [glob -nocomplain -directory $twdDir ${code}*]] {
      set Btn .${code}Btn
      $Btn select
    }
  }

##B) $sigLanglist not found
} else {
  #select language button if system language is different from $lang var
  if {[info exists syslangCode] && [winfo exists .${syslangCode}Btn]} {
    .${syslangCode}Btn select
  }
  #select $lang button if it exists
  if {$lang == "de" && [winfo exists .deBtn]} {
    .deBtn select
  } elseif {$lang == "en" && [winfo exists .enBtn]} {
    .enBtn select
  }
}

if $enablesig {
  set sigyesState 1
} else {
  set sigyesState 0
}

#Create Message
message .emailMsg -font bpfont1 -padx $px -pady $py -textvar f3.txt 
pack .emailMsg -in .emailF.botF.left -anchor nw
#Create Twd text
set twdfile [getRandomTwdFile 0]
set dwsig [getTodaysTwdSig $twdfile 1]

#Create E-Mail widgets
label .sigL -font twdwidgetfont -bg $bg -fg blue -justify left -textvar f3dw
text .sigT -font twdwidgetfont -background $bg -foreground blue -bd 0
.sigT insert 1.0 $dwsig

##right justify www line
set wwwline [.sigT search bible2 5.0]
set dotpos [string first . $wwwline]
set lineNo [string range $wwwline 0 $dotpos-1]
.sigT tag add www $lineNo.0 end
.sigT tag conf www -justify right
.sigT conf -height $lineNo

##justify right for Hebrew & Arabic
if [isBidi $dwsig] {
  .sigT tag add rtl 1.0 end
  .sigT tag conf rtl -justify right
  .sigT tag conf www -justify left
}

pack .sigL .sigT -in .emailF.botF.right -anchor w
