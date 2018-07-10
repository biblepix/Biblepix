# ~/Biblepix/prog/src/save/setupSaveLin.tcl
# Sourced by SetupSave
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 10jul18

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


#NEW ATTEMPT WITH native tools!!!!
proc setXfceBackground {} {
  global slideshow TwdBMP TwdTIF
  
  #Exit if xfconf-query not found
  if {[auto_execok xfconf-query] == ""} {
    return 1
  }
  
  #Our 'channel' is actually an XML file found in .config/xfce4/xfconf/xfce-perchannel-xml/
  set channel "xfce4-desktop"
  
  puts "Configuring XFCE background image..."

  
  #TODO: Check if this is really needed !!!!!!!!!!!!!!
  #Create/Change backdrop.list if $slideshow
  if {$slideshow} {
    set backdropdir ~/.config/xfce4/desktop
    file mkdir $backdropdir
    set backdroplist $backdropdir/backdrop.list
    set chan [open $backdroplist w]
    puts $chan "$TwdBMP\n$TwdTIF"
    close $chan
  }
  
 #Set monitoring - no Luck, holds up everything!
#exec xfconf-query -c xfce4-desktop -m
  
#xfconf-query -c xfce4-desktop -l >
#/backdrop/screen0/monitor0/image-path NEEDED [path]
#/backdrop/screen0/monitor0/workspace0/backdrop-cycle-enable NEEDED true
#/backdrop/screen0/monitor0/workspace0/backdrop-cycle-timer NEEDED int

  #Scan through 5 screeens & monitors
  for {set s 0} {$s<5} {incr s} {
    for {set m 0} {$m<5} {incr m} {
    
      # 'set' = set if existent
      # 'create' = create if non-existent

      set imgpath /backdrop/screen$s/monitor$m/image-path
      set imgStylePath /backdrop/screen$s/monitor$m/image-style
      if [catch "exec xfconf-query -c $channel -p $imgpath"] {
      
        continue
      
      } else {
      
        puts "Setting $imgpath"
      
        #must set single img path even if slideshow!  
        exec xfconf-query -c $channel -p $imgpath --set $TwdBMP
       # exec xfconf-query -c $channel -p $imgStylePath --create 3
        set ctrlBit 1
      }

      if {$slideshow} {
        
        #run through 5 workspaces (w)
        for {set w 0} {$w<5} {incr w} {
        puts "Setting workspace $w"
        
          set backdropCycleEnablePath /backdrop/screen$s/monitor$m/workspace$w/backdrop-cycle-enable
          set backdropCycleTimerPath /backdrop/screen$s/monitor$m/workspace$w/backdrop-cycle-timer
          
          if [catch "exec xfconf-query -c $channel -p $backdropCycleEnablePath"] {
            continue
            
          } else {
            exec xfconf-query -c $channel -p $backdropCycleEnablePath --set true
            exec xfconf-query -c $channel -p $backdropCycleTimerPath --set [expr $slideshow/60]
          }
        } ;#END for3
      } ;#END if slideshow
    } ;#END for2
  } ;#END for1
    
#reload XFCE4 desktop if running
#    if {! [catch "exec pidof xfdesktop"] }  {
#            wm withdraw .
#            exec xfdesktop --reload
#    }
  
  if [info exists ctrlBit] {
      return 0
  } {
    puts NoLuckSettingXfce
    return 1
  }
  
} ;#END setXfceBackground


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