# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 8jul18

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

#Install Menu entries for all desktops - no error handling
catch setLinMenu Error
puts "LinMenu $Error"
catch setKdeActionMenu Error
puts "KdeAction $Error"


#################################################
# 3 Set up Linux terminal -- TODO? error handling?
#################################################
if {$enableterm} {
  catch setupLinTerminal Error
  puts "Terminal $Error"
  
}

#Exit if no picture desired
if {!$enablepic} {
  return 0
}



#####################################################
## 4 Set up Desktop Background Image - with error handling
#####################################################

tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangingDesktop

set GnomeErr [setGnomeBackground]
set KdeErr [setKdeBackground]
set XfceErr [setXfceBackground]

#Create OK message for each successful desktop configuration
array set BgSuccessList "
Gnome $GnomeErr 
Kde $KdeErr
Xfce $XfceErr
"
set arrayText [array get BgSuccessList]

foreach desktopName [array names BgSuccessList] {
  if {$BgSuccessList($desktopName) == 0} {
    tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "$desktopName: $changeDesktopOk" 
  }
}

#Create Error message if no desktop configured
if {! [regexp 0 $arrayText] } {
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message $linChangeDesktopProb
}


########################################################
# 5 Try reloading KDE & XFCE Desktops - no error handling
# Gnome & Sway need no reloading
########################################################
if {$runningDesktop==2} {set desktopName KDE}
if {$runningDesktop==3} {set desktopName XFCE4}
tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "$desktopName: $linReloadingDesktop"

#Run progs end finish
if {$runningDesktop == 2} {
  catch reloadKdeDesktop Error
  puts "reloadKde $Error"
  
} elseif {$runningDesktop == 3} {
  catch reloadXfceDesktop
  puts "runningDesktop $Error"
}

return 0