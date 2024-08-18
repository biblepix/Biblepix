# ~/Biblepix/prog/src/save/saveLin.tcl
# Sourced by Save.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 18aug24 pv
source $SaveLinHelpers
source $SetupTools
source $SetBackgroundChanger
set Error 0
set hasError 0

#Check / Amend Linux executables - TODO: Test again
catch {formatLinuxExecutables} Error

##################################################
# 1 Set up Linux A u t o s t a r t for all Desktops
##################################################
if [catch {setupLinAutostart} Err] {
  puts $Err
  tk_messageBox -type ok -icon error -title "BiblePix Installation" -message "[msgcat::mc linSetAutostartProb]"
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

if {$runningDesktop == 0} {
  tk_MessageBox -type ok -icon error -message "[msgcat:mc linNoDesktopFound]"
}

#Install Menu entries for all desktops - no error handling
catch setupLinMenu Error
#puts "LinMenu $Error"
catch setupKdeActionMenu Error
#puts "KdeAction $Error"


#################################################
# 3 Set up Linux terminal -- TODO? error handling?
#################################################
if $enableterm {
  catch {setupLinTerminal} Error
  
  #TODO Infozeile verschwindet !!!!!!!!!!!!!!!
  NewsHandler::QueryNews $::terminfo lightblue
  after 3000
  
} else {
  setupLinTerminal removeBashrcEntry
}

#Zis isntworking!!!!
#puts "Terminal: $Error"


#Exit if no picture desired
if !$enablepic {
  return 0
}

#####################################################
## 4 Set up Desktop Background Image - with error handling
#####################################################

tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "[msgcat::mc linChangingDesktop]"

#Error codes: 0 = success | 1 = not found | 2 = error
set GnomeErr [setupGnomeBackground]
set KdeErr   [setupKdeBackground]
set XfceErr  [setupXfce4Background]

#Fire up message box for each Desktop configured
##A) None detected
if { $GnomeErr == 1 && $KdeErr == 1 && $XfceErr == 1} {
  tk_messageBox -type ok -icon warning -title "BiblePix Installation" -message "[msgcat::linNoDesktopFound]" 

##B) each individually if installation detected
} else {

  #GNOME (0 or 2)
  if !$GnomeErr {
    set msg "GNOME: [msgcat::mc changeDesktopOk]"
  } elseif {$GnomeErr == 2} {
    set msg "GNOME: [msgcat::mc linChangeDesktopProb]"
  }
  if {$GnomeErr != 1} {
    tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $msg
  }

  #KDE (0 or 2)
  if !$KdeErr {
    set msg "KDE: [msgcat::mc changeDesktopOk]"
  } elseif {$KdeErr == 2} {
    set msg "KDE: [msgcat::mc linChangeDesktopProb]"
  }
  if {$KdeErr != 1} {
    tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $msg
  }
  
  #XFCE4 (only 0)
  if !$XfceErr {
    set msg "XFCE4: [msgcat::mc changeDesktopOk]"
    tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $msg
  } 
}


########################################################
# 5 Try reloading KDE & XFCE Desktops - no error handling
# Gnome(1) & Sway(4) need no reloading
########################################################
if {$runningDesktop !=2 && $runningDesktop !=3} {
  return "Desktop needs no reloading"
} elseif {$runningDesktop==2} {
  set desktopName "KDE Plasma"
} elseif {$runningDesktop==3} {
  set desktopName "XFCE4"
}

tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "$desktopName: [msgcat:mc linReloadingDesktop]"

#Run progs end finish
if {$runningDesktop==2} {
  catch reloadKdeDesktop Error
  puts "reloadKde $Error"
  
} elseif {$runningDesktop==3} {
  catch reloadXfce4Desktop Error
  puts "runningDesktop $Error"
}

return 0
