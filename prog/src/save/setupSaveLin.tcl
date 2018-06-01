# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 1jun18

source $SetupSaveLinHelpers
source $SetupTools
set hasError 0

# A)   S E T   U P   L I N U X   A U T O S T A R T  & M E N U

# 1 Set up Linux Autostart always, for all installed Desktops
setLinAutostart

# 2A Set up Linux Crontab if no running desktop detected
if { ! [detectRunningLinuxDesktop] } {
puts DesktopYokmush!
  catch setLinAutostartCrontab Error
  
  if {$Error!=0} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linSetAutostartProb
    set hasError 1
  }
  
# 2B Create message if KDE or XFCE4
} elseif {[detectRunningLinuxDesktop] == 2} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linKdeXfceRestart
}


# 3 Set up Linux right-click menu
catch setLinMenu Error

if {!$hasError && $Error!=""} {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
  set hasError 1
}

# 4 Set up Linux terminal if $enableterm==1
if {$enableterm} {
  catch copyLinTerminalConf
}


## B) E R R O R   H A N D L I N G

# Create error messages if above fail
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