# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 4jul18

source $SetupSaveLinHelpers
source $SetupTools
source $SetBackgroundChanger

set Error 0
set hasError 0

#Check / Amend Linux executables - TODO: Test again
catch formatLinuxExecutables Error
puts "linExec $Error"

##################################################
# 1 Set up Linux A u t o s t a r t for all Desktops
##################################################
catch setLinAutostart Error
if {$Error} {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linSetAutostartProb
}

#TODO: Create $linSettingAutostart & $linSetAutostartProb



####################################################
# 2 Set up Menu entries for all Desktops
####################################################

# Check running desktop
##returns 1 if GNOME
##returns 2 if KDE
##returns 3 if XFCE4
##returns 4 if Wayland/Sway
##returns 0 if no running desktop detected
set runningDesktop [detectRunningLinuxDesktop]

#Install crontab autostart if no Desktop found - TODO: Test again
#TODO: apologize for not making menu entry...
if {$runningDesktop == 0} {
  puts "No Running Desktop found"
  catch setupLinCrontab Error0
  puts "Crontab $Error0"
}

#Install Menu entries for all desktops
catch setLinMenu Error
puts "LinMenu $Error"
catch setKdeActionMenu Error
puts "KdeAction $Error"

if {!$hasError && $Error!=""} {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message "$desktop: $linChangeDesktopProb"
  set hasError 1
}




#####################################################
## 4 Set up Desktop Background Image
#####################################################

if {$enablepic} {
  tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangingDesktop

  #Try setting main backgrounds - successful if config files found
  ##returncodes : 1=success, 0=failure
  lappend successList "1:[setGnomeBackground]"
  lappend successList "2:[setKdeBackground]"
  lappend successList "3:[setXfceBackground]"
  
  set GnomeBg [setGnomeBackground]
  set KdeBg [setKdeBackground]
  set XfceBg [setXfceBackground]
  
  array set BgSuccessList "Gnome $GnomeBg Kde $KdeBg Xfce $XfceBg"
  
  foreach desktop [array names BgSuccessList] {
    if {$desktop==1} {
    #TODO: include Desktop name in messages !!!!
      tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
    } else {
      tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $changeDesktopOk
    }
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


#################################################
# 6 Set up Linux terminal
#################################################
if {$enableterm} {
  catch setupLinTerminal Error
  puts "Terminal $Error"
  #TODO? message if failure ??
}
