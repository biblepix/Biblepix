# ~/Biblepix/prog/src/gui/setupSaveWin.tcl
# Sourced by Save.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 24may21

#Windows handles TIF + BMP
package require registry
source $SaveWinHelpers

#Set Registry compatible paths
set wishpath [file nativename [auto_execok wish]]
set winpath [file nativename $dirlist(windir)]


# A)  N O N - A D M I N   R E G I S T E R I N G S

#1a. Register Autorun always
if { [info exists Debug] && $Debug } {
  setWinAutorun
} else {
  set autorunError [catch setWinAutorun]
}

#1b. Execute single pic theme if running slideshow detected
if {$enablepic} {
  if { [info exists Debug] && $Debug } {
    setBackgroundType
  } else {
    set themeError [catch setBackgroundType]
  }
}

# B)  A D M I N   R E G I S T E R I N G S

# Register Context Menu IF values differ
# TODO move to Globals
set regpath_desktop [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\]
set regpathStandardKeyValue "BiblePix Setup"
set iconKeyValue "$winpath\\biblepix.ico"
set posKeyValue "Bottom"
set commandPath "$regpath_desktop\\Command"
regsub -all {[{}]} "$wishpath [file nativename $Setup]" {} commandPathStandardKeyValue

#1. Prüfe Grundeintrag und Schlüssel
if { [catch {registry get $regpath_desktop {}} ] ||
  [registry get $regpath_desktop Icon] != $iconKeyValue ||
  [registry get $regpath_desktop Position] != $posKeyValue ||
  [registry get $commandPath {}] != $commandPathStandardKeyValue
  } {
  
  tk_messageBox -type ok -title "BiblePix Registry Installation" -icon info -message $winRegister
  if { [info exists Debug] && $Debug } {
    setWinContextMenu
  } else {
    set regError [catch setWinContextMenu]
  }
}

set ok 1

#Final message if no errors
if { [info exists autorunError] && $autorunError } {
  set ok 0
    tk_messageBox -type ok -icon error -title "BiblePix Autorun Installation" -message $winChangeDesktopProb
} 
if { [info exists regError] && $regError } {
  set ok 0
  tk_messageBox -type ok -title "BiblePix Registry Installation" -icon error -message $winRegisterProb
}
if { [info exists themeError] && $themeError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Theme Installation" -message $winChangeDesktopProb
}

if {$ok} {
  tk_messageBox -type ok -title "BiblePix Installation" -icon info -message $changeDesktopOk
}
