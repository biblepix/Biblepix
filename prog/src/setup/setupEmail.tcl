# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 3apr21 pv

#TODO Update page on (re)opening to account for added/deleted TWD language files!

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
checkbutton .sigyesnoCB -textvar f3.btn -variable sigyesState -command {toggleCBstate}

pack .mainTit -in .emailF.topF.f1 -side left
pack .wunschsprachenTit -in .emailF.topF.f1 -side right -anchor ne -pady 10 -padx 100
pack .sigyesnoCB -in .emailF.topF.f2 -side left -anchor nw
pack [frame .emailF.topF.f2.rightF] -side right -padx 100 -pady $py

#List language codes of installed TWD files 
foreach L [glob -tails -directory $twdDir *.twd] {
  lappend langlist $L
}
foreach e $langlist {
  #files may have been deleted after creating Codelist
  if [file exists $twdDir/$e] {
    lappend codelist [string range $e 0 1]
  }
}
set CodeList [lsort -decreasing -unique $codelist]

#Lists selected sigLangCB's
proc updateSelectedList {} {
  global CodeList lang
  foreach code $CodeList {
    set varname "sel${code}" 
    if [set ::$varname] {
      lappend sigLanglist $code
    }
  }
  if ![info exists sigLanglist] {
    puts "No signature languages selected. Saving default."
    set sigLanglist $lang
  }
  return $sigLanglist
}

##called by .sigyes CB to enable/disable lang checkbuttons
proc toggleCBstate {} {
  global sigLangCBList sigyesState  
  foreach cb $sigLangCBList {
    if $sigyesState {
      $cb conf -state normal
    } else {
      $cb conf -state disabled
    }
  }
}

#Create language buttons for each language code
foreach code $CodeList {
  checkbutton .${code}CB -text $code -width 5 -selectcolor beige -indicatoron 0 -variable sel${code}
  pack .${code}CB -in .emailF.topF.f2.rightF -side right -padx 3
  lappend sigLangCBList .${code}CB
}

#Preselect language Buttons:
##A) $sigLanglist exists, but files may have been deleted
if {[info exists sigLanglist] && $sigLanglist != ""} {
  foreach code $sigLanglist {
    if [file exists [glob -nocomplain -directory $twdDir ${code}*]] {
      set CB .${code}CB
      $CB select
    }
  }
    
##B) $sigLanglist not found
} else {

  #select language button if system language is different from $lang var
  if {[info exists syslangCode] && [winfo exists .${syslangCode}CB]} {
    .${syslangCode}CB select
  }
  #select $lang button if it exists
  if {$lang == "de" && [winfo exists .deCB]} {
    .deCB select
  } elseif {$lang == "en" && [winfo exists .enCB]} {
    .enCB select
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
#Create E-Mail text
label .sigL1 -font "TkIconFont 16" -bg $bg -fg blue -pady 13 -padx 13 -justify left -textvar f3dw
label .sigL2 -font "TkIconFont 16" -bg $bg -fg blue -pady 13 -padx 13 -justify left -textvar dwsig

#Get any TWD file for Setup sig (setup=0)
set twdfile [getRandomTwdFile 0]
# setup=1
set dwsig [getTodaysTwdSig $twdfile 1]

#Justify right for Hebrew & Arabic
if [isBidi $dwsig] {
  .sigL2 conf -justify right -font Luxi
}

pack .sigL1 .sigL2 -in .emailF.botF.right -anchor w
