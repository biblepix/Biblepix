# ~/Biblepix/prog/src/save/saveWin.tcl
# Sourced by Save.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 14jul21

package require registry
source $SaveWinHelpers

#1. Register Autorun always
if { [info exists Debug] && $Debug } {
  regAutorun
} else {
  set autorunError [catch regAutorun err]
  puts $err
}

#2. getBackgroundType: Run win theme only if running slideshow detected 
tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message $winChangingDesktop
if { [info exists Debug] && $Debug } {
  getBackgroundType
} else {
  set themeError [catch geBackgroundType err]
}


### N E E D S   A D M I N   R I G H T S:

# 4. Register Context Menu only of values differ
set regpathStandardKeyValue "BiblePix Setup"
set posKeyValue "Bottom"
set commandPath "$regpath_desktop\\Command"

#Check if preinstalled and correct:
if {
  [catch {registry get $regpath_desktop {} }] || 
  [catch {registry get $regpath_desktop Icon} res1] ||
  [catch {registry get $regpath_desktop Position} res2] ||
  [catch {registry get $commandPath {}} res3] ||

  $res1 != "[file nativename $WinIcon]" ||
  $res2 != "$posKeyValue" ||
  [string compare {biblepix-setup.tcl} $res3] != 1
  
} {

#TODO testing
puts $res1
puts $res2
puts $res3

  tk_messageBox -type ok -title "BiblePix Registry Installation" -icon info -message $winRegister
  
  if { [info exists Debug] && $Debug } {
    regContextMenu
  } else {
    set contextMenuError [catch regContextMenu err]
    puts $err
  }
}

set ok 1

#Final message if no errors
if { [info exists autorunError] && $autorunError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Autorun Installation" -message $winChangeDesktopProb
}
if { [info exists desktopBgError] && $desktopBgError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Desktop background installation" -message $winChangeDesktopProb
}
 
if { [info exists contextMenuError] && $contextMenuError } {
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
