# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 9jul18

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
proc setXfceBackground {} {

# X F C E 4  - knows TIF/BMP/PNG !
  if {[auto_execok xfconf-query] != ""} {
  
    for {set s 0} {$s<5} {incr s} {
      for {set m 0} {$m<5} {incr m} {
        catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m/image-path -s $TwdBMP" err
        catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m/image-style -s 3" err
        catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m/image-show -s true" err
          if {$slideshow} {
            set backdropdir ~/.config/xfce4/desktop
            file mkdir $backdropdir
            set imglist $backdropdir/backdrop.list
            set chan [open $imglist w]
            puts $chan "$TwdBMP\n$TwdTIF"
            close $chan
            catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m --create last-image-list -s $imglist" err
            catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m --create backdrop-cycle-enable -s true" err
            catch "exec xfconf-query -c xfce4-desktop -p /backdrop/screen$s/monitor$m --create backdrop-cycle-timer [expr $slideshow/60]" err  
              if {$err!=""} {continue}
            }
        }
      }
#reload XFCE4 desktop if running
#    if {! [catch "exec pidof xfdesktop"] }  {
#            wm withdraw .
#            exec xfdesktop --reload
#    }

  }


}

tk_messageBox -type ok -icon info -title "BiblePix Installation" -message $linChangingDesktop

set GnomeErr [setGnomeBackground]
set KdeErr [setKdeBackground]
set XfceErr [setXfceBackground]

#Create OK message for each successful desktop configuration
if {$GnomeErr==0} {
  append desktopList GNOME
}
if {$KdeErr==0} {
  append desktopList KDE
}
if {$XfceErr==0} {
  append desktopList XFCE4
}
#puts "desktopList: $desktopList"

#Create Ok message if desktopList not empty
if {$desktopList != ""} {
  foreach desktopName $desktopList {
    tk_messageBox -type ok -icon info -title "BiblePix Installation" -message "$desktopName: $changeDesktopOk" 
  }
#Create Error message if no desktop configured
} else {
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