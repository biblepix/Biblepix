# ~/Biblepix/prog/src/save/saveWin.tcl
# Sourced by Save.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 8nov21

package require registry
source $SaveWinHelpers

#1. Register Autorun always
if { [info exists Debug] && $Debug } {
  regAutorun
} else {
  set regAutorunError [catch regAutorun err]
  puts $err
}

if $enablepic {
  tk_messageBox -type ok -icon info -title "BiblePix Background Registration" -message $msgbox::winChangingDesktop
  
  #2. Register initial Wallpaper parameters 
  if { [info exists Debug] && $Debug } {
    regInitialWallpaper
  } else {
    set regInitialError [catch regInitialWallpaper err]
  }

  #3. Register BackgroundType: (win theme not run now!) 
  if { [info exists Debug] && $Debug } {
    regBackgroundType
  } else {
    set regBackgroundError [catch regBackgroundType err]
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

  tk_messageBox -type ok -title "BiblePix Registry Installation" -icon info -message $msgbox::winRegister
  
  if { [info exists Debug] && $Debug } {
    regContextMenu
  } else {
    set contextMenuError [catch regContextMenu err]
    puts $err
  }
}

set ok 1

#Final Error messages
if { [info exists regAutorunError] && $regAutorunError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Registry Autorun Installation" -message $msgbox::winChangeDesktopProb
}
if { [info exists regInitialError] && $regInitialError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Registry Initial Wallpaper Installation" -message $msgbox::winRegisterProb
}
if { [info exists regBackgroundError] && $regBackgroundError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Registry Background Theme Installation" -message $msgbox::winChangeDesktopProb
}
if { [info exists contextMenuError] && $contextMenuError } {
  set ok 0
  tk_messageBox -type ok -icon error -title "BiblePix Registry Context Menu Installation" -message $msgbox::winRegisterProb
}
#Final OK message
if {$ok} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $msgbox::changeDesktopOk
  exec RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
}

