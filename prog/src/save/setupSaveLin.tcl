# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 9jun18

source $SetupSaveLinHelpers
source $SetupTools
source $SetBackgroundChanger

set Error 0
set hasError 0

#Check / Amend Linux executables
catch checkExecutables

##################################################
# 1 Set up Linux Autostart for all Desktops
##################################################
catch setLinAutostart

# Check running desktop
##returns 1 if GNOME
##returns 2 if KDE
##returns 3 if XFCE4
##returns 4 if Wayland/Sway
##returns 0 if no running desktop detected
set runningDesktop [detectRunningLinuxDesktop]

#Reload KDE/XFCE desktops - TODO Doppelt! s. u.
if {$runningDesktop == 2 || $runningDesktop == 3} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linKdeXfceRestart

# Make Autostart entry in sway config file
} elseif {$runningDesktop == 4} { 
  
    setSwayAutostart
    
#Install crontab if no Desktop found
} else {

  puts "No Running Desktop found"
  catch setupLinCrontab Error
  
  if {$Error!=0} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linSetAutostartProb
    set hasError 1
  }
}

####################################################
# 2 Set up Menu entries for all Desktops
####################################################
catch setLinMenu

#if {!$hasError && $Error!=""} {
#  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
#  set hasError 1
#}


#################################################
# 3 Set up Linux terminal
#################################################
if {$enableterm} {
  catch setupLinTerminal
  #TODO? message if failure ??
}


########################################################
# 4 Try reloading KDE & XFCE4 Desktops & Create message - TODO: differentiate return codes !!!!
# Gnome & Sway need no config reloading
#########################################################
tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $TODO:CREATEMESSAGEtryingToReloadDesktop

if {$runningDesktop == 2} {
  catch reloadKdeDesktop
} elseif {$runningDesktop == 3} {
  catch reloadXfceDesktop
}


## B)  E R R O R   H A N D L I N G

# Create error messages if above fail
if {$enablepic} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangingDesktop
  catch {setLinBackground} Error

  if {$Error==1} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
    set hasError 1
  }
}

if {!$hasError} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $changeDesktopOk
}