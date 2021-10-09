# ~/Biblepix/prog/src/save/save.tcl
# Records settings & downloads TWD files
# called by biblepix-setup.tcl
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated : 9oct21 pv 

# Return to INTERNATIONAL section if $twddir empty
if [catch {glob $twddir/*$jahr.twd}] {
  .nb select .internationalF
  NewsHandler::QueryNews "$msg::noTwdFilesFound" red
  return

# Return to PHOTOS section if $picsdir empty
} elseif { [catch {glob $photosdir/*}] } {
 .nb select .photosF
  NewsHandler::QueryNews "$msg::noPhotosFound" red
  return
}


# R E W R I T E   C O N F I G

#1.Fetch status variables from GUI (old needed in SaveWin)
set imgstatus [set imgyesState]
set enablepic_old $enablepic

##ticked signature languages
set sigstatus [set sigyesState]
#scan $CodeList from SetupEmail for selected items
if {$sigstatus} {
  set sigLanglist [updateSelectedMailBtnList]
}

set titlelinestatus [set enabletitle]
set fontcolourstatus [.fontcolorSpin get]
set fontsizestatus   [.fontsizeSpin get]
set fontweightstatus [set fontweightState]
set fontfamilystatus [.fontfamilySpin get]

if {$fontweightstatus == 1} {
  set fontweight "bold"
} else {
  set fontweight "normal"
}
  
set fontcolor [set $fontcolourstatus]
set rgb [hex2rgb $fontcolor]
set slidestatus [.slideSpin get]

##textpos coordinates
lassign [$textposC coords mv] x y - -
set marginleftstatus [expr int($x*$textPosFactor)]
set margintopstatus [expr int($y*$textPosFactor)]

##Linux specific
catch {set termstatus [set termyesnoState]}

#2.Write general vars to $Config
set chan [open $Config w]
puts $chan "set lang $lang"
puts $chan "set enabletitle $titlelinestatus"
puts $chan "set enablepic $imgstatus"
##signature
puts $chan "set enablesig $sigstatus"
if {$sigstatus} {
  puts $chan "set sigLanglist \{$sigLanglist\}"
}
##slideshow (old needed in SaveWin)
set slideshow_old $slideshow
puts $chan "set slideshow $slidestatus"
##fonts
puts $chan "set fontfamily \{$fontfamilystatus\}"
puts $chan "set fontsize $fontsizestatus"
puts $chan "set fontcolortext $fontcolourstatus"
puts $chan "set enableRandomFontcolor $enableRandomFontcolor"
puts $chan "set fontweight $fontweight"
##margins
puts $chan "set marginleft $marginleftstatus"
puts $chan "set margintop $margintopstatus"

#Leave Debugging Mode/Mocking Http on 1 for testing, otherwise set to 0
if ![info exists Debug] {
  set Debug 0
}
if ![info exists Httpmock] {
  set Httpmock 0
}
puts $chan "set Debug $Debug"
puts $chan "set Httpmock $Httpmock"

#3.Write Linux vars to $Config
if {$os == "Linux"} {
  if [info exists crontab] {
    puts $chan "set crontab 1"
  }
  if [info exists termstatus] {
    puts $chan "set enableterm $termstatus"
  }
  #Define Desktop Images dir
  source $SaveLinHelpers
  puts $chan "set DesktopPicturesDir [setLinDesktopPicturesDir]" 
}

close $chan


#F I N I S H
NewsHandler::QueryNews "Changes recorded. Exiting..." green

#leere das gesamte Fenster, weil es wiederverwendet wird.
pack forget .n .fbottom .ftop

#R U N   I N S T A L L   R O U T I N E S

# 1. put biblepix-setup.tcl & biblepix.tcl in Desktop program menu
# 2. put biblepix.tcl in Autostart
# 3. set up Desktop background image & slide show

source $Config

if {$os == "Windows NT"} {
  source $SaveWin
} elseif {$os == "Linux"} {
  source $SaveLin
}

source $Biblepix
