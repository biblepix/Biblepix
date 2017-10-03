# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2oct17

source $SetupSaveLinHelpers
set hasError 0

#Run setLinCrontab OR setLinAutostart - progs return 1 or 0
if {
  [setLinCrontab]
  } {
  catch setLinAutostart Error
  
  if {$Error!=0} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
    set hasError 1
  } 
}

#Run setLinMenu
catch setLinMenu Error

if {!$hasError && $Error!=""} {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
  set hasError 1
}

## SET BACKGROUND PICTURE/SLIDESHOW if $enablepic
if {$enablepic} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangeDesktop
  
  catch {setLinBackground} Error

  if {!$hasError && $Error!=""} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
    set hasError 1
  }
}

if {!$hasError} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $changeDesktopOk
}
