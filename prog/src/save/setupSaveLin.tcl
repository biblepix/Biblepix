# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 29may18

source $SetupSaveLinHelpers
source $SetupTools
set hasError 0

# 1   S E T   U P   L I N U X   A U T O S T A R T

# 1 Set up Linux Autostart always
setLinAutostart

#TODO: should this be incorporated in aove??
# Set up Linux Crontab if no desktop detected
if { ! [detectRunningLinuxDesktop] } {
  } {
  catch setLinAutostart Error
  
  if {$Error!=0} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linSetAutostartProb
    set hasError 1
  }
}

# 2 Set up Linux right-click menu
catch setLinMenu Error

if {!$hasError && $Error!=""} {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
  set hasError 1
}

# 3 Set up Linux terminal if $enableterm==1
if {$enableterm} {
  catch copyLinTerminalConf
}


# 4 Create error messages if above fail
if {$enablepic} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangingDesktop
  catch {setLinBackground} Error

  if {!$hasError && $Error!=""} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
    set hasError 1
  }
}

if {!$hasError} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $changeDesktopOk
}