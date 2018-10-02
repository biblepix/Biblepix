# ~/Biblepix/prog/src/save/setupSave.tcl
# Records settings & downloads TWD files
# called by biblepix-setup.tcl
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated : 1sept18 

# Return to INTERNATIONAL section if $twdDir empty
if { [catch {glob $twdDir/*$jahr.twd}] } {
  .nb select .internationalF
  NewsHandler::QueryNews "$noTWDFilesFound" red
  return

# Return to PHOTOS section if $picsdir empty
} elseif { [catch {glob $jpegDir/*}] } {
 .nb select .photosF
  NewsHandler::QueryNews "$noPhotosFound" red
  return
}


# R E W R I T E   C O N F I G

#1.Fetch status variables from GUI
set imgstatus [set imgyesState]
set sigstatus [set sigyesState]
set titlelinestatus [set enabletitle]
set fontcolourstatus [$fontcolorSpin get]
set fontsizestatus [$fontsizeSpin get]
set fontweightstatus [set fontweightState]
set fontfamilystatus [$fontfamilySpin get]

if {$fontweightstatus == 1} {
  set fontweight "bold"
} else {
  set fontweight "normal"
}
  
set fontcolor [set $fontcolourstatus]
set rgb [hex2rgb $fontcolor]
set slidestatus [$slideSpin get]

##textpos coordinates
lassign [.textposCanv coords mv] x y - -
set marginleftstatus [expr int($x*$textPosFactor)]
set margintopstatus [expr int($y*$textPosFactor)]

##Linux specific
catch {set termstatus [set termyesnoState]}

#2.Write general vars to $Config
set chan [open $Config w]
puts $chan "set lang $lang"
puts $chan "set enabletitle $titlelinestatus"
puts $chan "set enablepic $imgstatus"
puts $chan "set enablesig $sigstatus"
puts $chan "set slideshow $slidestatus"
puts $chan "set fontfamily \{$fontfamilystatus\}"
puts $chan "set fontsize $fontsizestatus"
puts $chan "set fontcolortext $fontcolourstatus"
puts $chan "set fontweight $fontweight"
puts $chan "set sun [setSun $rgb]"
puts $chan "set shade [setShade $rgb]"
puts $chan "set marginleft $marginleftstatus"
puts $chan "set margintop $margintopstatus"

if {$Debug || $Mock} {
  puts $chan "
  # These variables enable Debugging Mode resp. Mocking Http for testing.
  set Debug $Debug
  set Mock $Mock"
}

#3.Write Linux vars to $Config
if {$os == "Linux"} {
  if {[info exists crontab]} {
    puts $chan "set crontab 1"
  }
  if {[info exists termstatus]} {
    puts $chan "set enableterm $termstatus"
  }
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
  source $SetupSaveWin
} elseif {$os == "Linux"} {
  source $SetupSaveLin
}

########### D E L E T E   O L D   S T U F F  #######################

#Delete obsolete bmpdir
file delete -force $progDir/bmp

#Delete any old TWD files
set vorjahr [expr {$jahr - 1}]
set oldtwdlist [glob -nocomplain -directory $twdDir *$vorjahr.twd]
if {[info exists oldtwdlist]} {
  NewsHandler::QueryNews "Deleting old language files..." lightblue
  
  foreach file $oldtwdlist {
    file delete $file
  }
  NewsHandler::QueryNews "Old TWD files deleted." green
}

###### S t a r t   B i b l e p i x  #####################

source $Biblepix