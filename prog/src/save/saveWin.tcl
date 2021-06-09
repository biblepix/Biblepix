# ~/Biblepix/prog/src/gui/setupSaveWin.tcl
# Sourced by Save.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 8jun21

#Windows handles TIF + BMP
package require registry
source $SaveWinHelpers

#Set Registry compatible paths
#set wishpath "[file nativename [auto_execok wish]]"
#set srcpath "[file nativename $srcdir]"
#set winpath "[file nativename $windir]"
#set setuppath "[file nativename $Setup]"
##non-root registry paths
#set regpath_autorun         [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Run} \\]
#set regpath_backgroundtype  [join {HKEY_CURRENT_USER SOFTWARE Microsoft Windows CurrentVersion Explorer Wallpapers} \\]
###root privileges needed
#set regpath_desktop  [join {HKEY_CLASSES_ROOT DesktopBackground Shell Biblepix} \\]
#set regpath_policies [join {HKEY_CURRENT_USER Software Microsoft Windows CurrentVersion Policies System} \\]

# A)  N O N - A D M I N   R E G I S T E R I N G S

#1a. Register Autorun if not present
if { [info exists Debug] && $Debug } {
  regAutorun
} else {
  set autorunError [catch regAutorun err]
  puts $err
}

#1b. Execute single pic theme if running slideshow detected
##runs setWinTheme if necessary & warns to ignore Designs popup
if {$enablepic} {
  tk_messageBox -type ok -icon info -title "BiblePix Theme Installation" -message $winChangingDesktop

  if { [info exists Debug] && $Debug } {
    getBackgroundType
  } else {
    set themeError [catch getBackgroundType err]
  }
}

# B)  A D M I N   R E G I S T E R I N G S

# Register Context Menu IF values differ
set regpathStandardKeyValue "BiblePix Setup"
set posKeyValue "Bottom"
set commandPath "$regpath_desktop\\Command"

#setupCommand must have \\ usw. because of \" inside string, exactly like this:
## ...TODO get from $windir/install.reg !
append setupCommand $wishpath { } \u0022 $setuppath \u0022

#Check if preinstalled and correct:
##a) Grundeintrag
if {
  [catch {registry get $regpath_desktop {} }] || 
  [catch {registry get $regpath_desktop Icon} res1] ||
  [catch {registry get $regpath_desktop Position} res2] ||
  [catch {registry get $commandPath {}} res3] ||
  $res1 != "[file nativename $WinIcon]" ||
  $res2 != "$posKeyValue" ||
  $res3 != "$setupCommand"
} {

  tk_messageBox -type ok -title "BiblePix Registry Installation" -icon info -message $winRegister
  
  if { [info exists Debug] && $Debug } {
    regContextMenu
  } else {
    set regError [catch regContextMenu err]
    puts $err
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
