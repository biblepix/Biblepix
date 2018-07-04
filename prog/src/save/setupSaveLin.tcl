# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 4jul18

source $SetupSaveLinHelpers
source $SetupTools
source $SetBackgroundChanger

#TODO: reform error handling!!!!
#TODO: remove catches for testing!

set Error 0
set hasError 0

#Check / Amend Linux executables
catch formatLinuxExecutables Error
puts "linExec $Error"

##################################################
# 1 Set up Linux A u t o s t a r t for all Desktops
##################################################
catch setLinAutostart Error
puts "autostart $Error"

# Check running desktop
##returns 1 if GNOME
##returns 2 if KDE
##returns 3 if XFCE4
##returns 4 if Wayland/Sway
##returns 0 if no running desktop detected
set runningDesktop [detectRunningLinuxDesktop]

#Install crontab if no Desktop found
if {$runningDesktop == 0} { 
  puts "No Running Desktop found"
  catch setupLinCrontab Error0
  puts "Crontab $Error0"

#Install Sway Autostart
} elseif {$runningDesktop == 4} {
  catch setSwayAutostartAndBackground Error4
  puts "swayAutostart $Error4"
}

#TODO: organise
if {$Error!=0} {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linSetAutostartProb
  set hasError 1
}


####################################################
# 2 Set up Menu entries for all Desktops
####################################################
catch setLinMenu Error
puts "LinMenu $Error"
catch setKdeActionMenu Error
puts "KdeAction $Error"

if {!$hasError && $Error!=""} {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
  set hasError 1
}


#################################################
# 3 Set up Linux terminal
#################################################
if {$enableterm} {
  catch setupLinTerminal Error
  puts "Terminal $Error"
  #TODO? message if failure ??
}



#####################################################
## 4 Set up Desktop Background Image
#####################################################

if {$enablepic} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangingDesktop

  #Set main backgrounds - successful if config files found
  ##returncodes : 1=success, 0=failure
  lappend successList "1:[setGnomeBackground]"
  lappend successList "2:[setKdeBackground]"
  lappend successList "3:[setXfceBackground]"
  #lappend successList "4:[setSwayAutostartAndBackground]"
  puts $successList
return

#TODO: reorganise from here
  if {$Error==1} {
    tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
    set hasError 1
  }

} ;#£END if enablepic

#TODO:
if {!$hasError} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $changeDesktopOk
}

########################################################
# 5 Try reloading KDE & XFCE Desktops
# Gnome & Sway need no reloading
########################################################

if {$enablepic} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "TODO:RELOADINGDesktop"

  if {$runningDesktop == 2} {
    catch reloadKdeDesktop Error
    puts "reloadKde $Error"
    
  } elseif {$runningDesktop == 3} {
    catch reloadXfceDesktop
    puts "runningDesktop $Error"
  }
}

