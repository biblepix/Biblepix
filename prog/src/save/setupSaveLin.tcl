# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2jun18

source $SetupSaveLinHelpers
source $SetupTools
source $SetBackgroundChanger

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
  
  #Make entry in ~/.bash_profile
  set bashProfile $HOME/.bash_profile
  if [file exists $bashProfile] {
    set chan [open $bashProfile r]
    set t [read $chan]
    close $chan
  }
  ##delete any previous entries
  if [regexp {[Bb]iblepix} $t] {
    regsub -all -line {^.*iblepix.*$} $t {} t
  }
  ##add line for term.sh
  set chan [open $bashProfile w]
  append t \n sh { } $Terminal
  puts $chan $t
  close $chan
}

# 5 Add "Sh-Bang" with correct 'env' path to main executables
set envPath [auto_execok env]
set shBangLine "\#!$envPath tclsh"

##read out Biblepix & Setup texts
set chan1 [open $Biblepix r]
set chan2 [open $Setup r]
set text1 [read $chan1]
set text2 [read $chan2]
close $chan1
close $chan2

##reset texts if no sh-bang found
if {![regexp \#! $text1] } {
  append t1 $shBangLine \n $text1
  set chan [open $Biblepix w]
  puts $chan $t1
  close $chan
}
if {![regexp \#! $text2] } {
  append t2 $shBangLine \n $text2
  set chan [open $Setup w]
  puts $chan $t2
  close $chan
}
##cleanup
catch {unset shBangLine text1 text2 t1 t2}

##make files executable
file attributes $Biblepix -permissions +x
file attributes $Setup  -permissions +x
 
## B)  E R R O R   H A N D L I N G

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