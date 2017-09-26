# ~/Biblepix/prog/src/save/setupSave.tcl
# Records settings & downloads TWD files
# called by biblepix-setup.tcl
# Author: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated : 26sep17 

# TODO - remove, this is handled via Download button now
#Make sure either $twdDir or SELECTED contain $jahr-TWD files,
# else stop saving process & return to Setup!
#set SELECTED_TWD_FILES [.n.f1.twdremoteframe.lb curselection]
# A: If SELECTED NOT EMPTY: Start TWD download
#if { $SELECTED_TWD_FILES != ""} {
#  downloadTWDFiles
#}

# return to INTERNATIONAL section if $twdDir empty
if { [catch {glob $twdDir/*$jahr.twd}] } {
    
  .n select .n.f1
  NewsHandler::QueryNews "$noTWDFilesFound" red

#return to PHOTOS section if $picsdir empty
} elseif { [catch {glob $jpegDir/*}] } {
 
  .n select .n.f6
  NewsHandler::QueryNews "$noPhotosFound" red

# else continue with writing Config
} else {

  #2. R E W R I T E   C O N F I G

  #Fetch status variables
  set imgstatus [set imgyesState]
  set sigstatus [set sigyesState]
  set introlinestatus [set enableintro]
  catch {set termstatus [set termyesnoState]}
  set fontcolourstatus [$fontcolorSpin get]
  set fontsizestatus [$fontsizeSpin get]
  set fontweightstatus [set fontweightState]
  set fontfamilystatus [$fontfamilySpin get]
  set slidestatus [$slideSpin get]
  
  #Fetch textpos coordinates
  lassign [$textposCanv coords mv] x y - -
  set marginleftstatus [expr int($x*$textPosFactor)]
  set margintopstatus [expr int($y*$textPosFactor)]

  #Write all settings to config
  set chan [open $Config w]
  puts $chan "set lang $lang"
  puts $chan "set enableintro $introlinestatus"
  puts $chan "set enablepic $imgstatus"
  puts $chan "set enablesig $sigstatus"
  if {[info exists termstatus]} {
    puts $chan "set enableterm $termstatus"
  }
  puts $chan "set slideshow $slidestatus"
  puts $chan "set fontfamily \{$fontfamilystatus\}"
  puts $chan "set fontsize $fontsizestatus"

  if {$fontweightstatus==1} {
    puts $chan "set fontweight bold"
  } else {
    puts $chan "set fontweight normal"
  }
  puts $chan "set fontcolortext $fontcolourstatus"

  ##Compute sun & shade HEX - (procs in Imgtools!)
  set fontcolor [set $fontcolourstatus]
  set rgb [hex2rgb $fontcolor]
  puts $chan "set sun [setSun $rgb]"
  puts $chan "set shade [setShade $rgb]"
  puts $chan "set marginleft $marginleftstatus"
  puts $chan "set margintop $margintopstatus"
  
  close $chan

  #Finish
  NewsHandler::QueryNews "Changes recorded. Exiting..." green

  #leere das gesamte Fenster, weil es wiederverwendet wird.
  pack forget .n .fbottom .ftop

  #######  I N S T A L L   R O U T I N E S   WIN / LINUX / MAC

  # 1. puts biblepix-setup.tcl & biblepix.tcl in Desktop program menu
  # 2. puts biblepix.tcl in Autostart
  # 3. sets Desktop background image & slide show

  if {$os == "Windows NT"} {
    
    source $Config
    source $SetupSaveWin

  } elseif {$os == "Linux"} {
    
    source $Config
    source $SetupSaveLin
    if {[info exists crontab]} {
      set chan [open $Config a]      
      puts $chan "set crontab 1"
      close $chan
    }   
  }
  
  #Delete any old TWD files - TODO : isn't there a better place for this?
  set vorjahr [expr {$jahr - 1}]
  set oldtwdlist [glob -nocomplain -directory $twdDir *$vorjahr.twd]
  if {[info exists oldtwdlist]} {
    NewsHandler::QueryNews "Deleting old language files..." lightblue
    
    foreach file $oldtwdlist {
      file delete $file
    }
    
    NewsHandler::QueryNews "Old TWD files deleted." green
  }

  #Delete old BMPs & start Biblepix
  if {$enablepic} {
    #create random BMP if $imgDir empty
    if { [glob -nocomplain $imgDir/*.bmp] == "" } {
      package require Img
      set photopath [getRandomPhoto]
      set quickimg [image create photo -file $photopath]
      $quickimg write $TwdBMP -format bmp
    }
    foreach file [glob -nocomplain -directory $bmpdir *] {
      file delete -force $file
    }

  }
  
  source $Biblepix
} ;#END WRITE CONFIG
