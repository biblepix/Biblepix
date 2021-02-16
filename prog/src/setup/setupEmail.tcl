# ~/Biblepix/prog/src/gui/setupEmail.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 16feb21

label .emailF.t1 -textvar f3.tit -font bpfont3
pack .emailF.t1 -anchor w

pack [frame .emailF.titelF -pady 20 -padx 20] -fill x

checkbutton .emailF.titelF.sigyes -textvar f3.btn -variable sigyesState -command {toggleCBstate}
label .emailF.titelF.sprachenL -textvar f3.sprachen -bg lightblue

pack [frame .emailF.topframe] -expand false -fill x
pack [frame .emailF.topframe.left] -side left -expand false 
pack [frame .emailF.topframe.right] -side right -expand 0
.emailF.topframe.right configure -borderwidth 2 -relief sunken -padx 50 -pady 30 -bg $bg

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
  global CodeList
  foreach code $CodeList {
    set varname "sel${code}" 
    if [set ::$varname] {
      lappend sigLanglist $code
    }
  }
  return $sigLanglist
}

##called by .sigyes CB to enable/disable lang checkbuttons
proc toggleCBstate {} {
  global sigLangCBList sigyesState
  
  foreach cb $sigLangCBList {
    
    if {$sigyesState} {
      $cb conf -state normal
    } else {
      $cb conf -state disabled
    }
  }
}

#Create language buttons for each language code
foreach code $CodeList {
  checkbutton .${code}CB -text $code -width 5 -selectcolor yellow -indicatoron 0 -variable sel${code}
  pack .${code}CB -in .emailF.titelF -side right -padx 3
  lappend sigLangCBList .${code}CB
}

#Preselect language Buttons:
##A) $sigLanglist exists
if {[info exists sigLanglist] && $sigLanglist != ""} {
  foreach code $sigLanglist {
  puts $code
    if [file exists [glob -nocomplain -directory $twdDir ${code}*]] {
  puts $code
      set CB .${code}CB
      $CB select
    }
  }
    
##B) $sigLanglist not found
} else {

  if {[info exists syslangCode] && [winfo exists .${syslangCode}CB]} {
    .${syslangCode}CB select
  }

  if {$lang == "de" && [winfo exists .deCB]} {
    .deCB select
  } elseif {$lang == "en" && [winfo exists .enCB]} {
    .enCB select
  }
}

pack .emailF.titelF.sprachenL -side right
pack .emailF.titelF.sigyes -anchor w -side left

if {$enablesig==1} {
  set sigyesState 1
} else {
  set sigyesState 0
}

#Create Message
message .emailF.topframe.left.t2 -font bpfont1  -padx $px -pady $py -textvar f3.txt 
pack .emailF.topframe.left.t2 -anchor nw

#Create Label 1
set sigLabel1 [label .emailF.topframe.right.sig -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable f3dw]

#Create Label 2
set sigLabel2 [label .emailF.topframe.right.sig2 -font TkIconFont -bg $bg -width 0 -foreground blue -pady 3 -padx 3 -justify left -textvariable dwsig]

#Adapt $setupTwdText for signature 
if { [catch {set dwsig [getTodaysTwdSig $setupTwdFileName]}] } {
  set dwsig "----\n $::noTwdFilesFound"
}

#Justify right for Hebrew & Arabic
if { [isRtL [getTwdLang $setupTwdFileName]] } {
  $sigLabel2 configure -justify right
}

pack $sigLabel1 $sigLabel2 -anchor w
