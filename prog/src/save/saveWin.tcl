# ~/Biblepix/prog/src/save/saveWin.tcl
# Sourced by Save.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15jul21

package require registry
source $SaveWinHelpers

#1. Register Autorun always
if { [info exists Debug] && $Debug } {
  regAutorun
} else {
  set autorunError [catch regAutorun err]
  puts $err
}

if $enablepic {
  tk_messageBox -type ok -icon info -title "BiblePix Background Registration" -message $winChangingDesktop
  
  #2. Register initial Wallpaper parameters 
  if { [info exists Debug] && $Debug } {
    regInitialWallpaper
  } else {
    set regInitialError [catch regInitialWallpaper err]
  }

  #3. getBackgroundType: Run win theme only if running slideshow detected 
  if { [info exists Debug] && $Debug } {
    getBackgroundType
  } else {
    set themeError [catch getBackgroundType err]
  }

} ;#END if enablepic


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

#Final Error messages
if { [info exists regInitialError] && $regInitialError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Registry Initial Wallpaper Installation" -icon error -message $winRegisterProb
}

if { [info exists contextMenuError] && $contextMenuError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Registry Context Menu Installation" -icon error -message $winRegisterProb
}

if { [info exists themeError] && $themeError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Theme Installation" -message $winChangeDesktopProb
}

if {$ok} {
  tk_messageBox -type ok -title "BiblePix Installation" -icon info -message $changeDesktopOk
}
