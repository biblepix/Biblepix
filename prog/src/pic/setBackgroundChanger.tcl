# ~/Biblepix/prog/src/pic/setBackgroundChanger.tcl
# Searches system for current Desktop manager, gives out appropriate BG changing command
# Called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 19oct22 pv

########################################################################
# WINDOWS: accepts command through RUNDLL32.EXE - a bit buggy still...

# LINUX SWAY (WAYLAND): accepts command through 'swaymsg'
# GNOME: needs no image changer, detects image change
# KDE: needs to be preconfigured (in setupSave)
# XFCE4: needs to be preconfigured (in setupSave)
# Other (Linux) desktops: error "command not found" 
##########################################################################

if {$platform == "windows"} {
  package require registry
}

# detectRunningLinuxDesktop
##returns 1 if GNOME detected
##returns 2 if KDE detected
##returns 3 if XFCE4 detected
##returns 4 if Wayland/Sway detected
##returns 0 if no running desktop detected
##called by SetupSaveLin & .
proc detectRunningLinuxDesktop {} {
  global env
  
  #check GNOME (return 1)
  if { [info exists env(GNOME_KEYRING_CONTROL)] ||
       [info exists env(GNOME_DESKTOP_SESSION_ID)] } {
    return 1
  }
  
  #check KDE (return 2)
  if { [info exists env(XDG_CURRENT_DESKTOP)] &&
      $env(XDG_CURRENT_DESKTOP) == "KDE" } {
      return 2
  } elseif { 
      [info exists env(DESKTOP_SESSION)] &&
      $env(DESKTOP_SESSION) == "kde-plasma" } {
      return 2
  }
  
  #check XFCE4 (return 3)
  if { [info exists env(XDG_CURRENT_DESKTOP)] &&
    $env(XDG_CURRENT_DESKTOP) == "XFCE" } {
    return 3
  } elseif {
    [info exists env(DESKTOP_SESSION)] &&
    $env(DESKTOP_SESSION) == "xfce" } {
    return 3
  }
  
  #check Wayland/Sway (return 4)
  if [info exists env(SWAYSOCK)] {
    return 4
  }

  #no desktop detected
  return 0
}


# B a c k g r o u n d  c h a n g e r s

# setWinBg
##called by setBg
proc setWinBg {} {
  global TwdBMP 
  package require registry

  #try to use %LOCALAPPDATA% var in Reg string
  #set LAD $env(localappdata)
  if [regexp {AppData.Local} $TwdBMP] {
    append picpath %LOCALAPPDATA% \\ Biblepix \\ TodaysPicture \\ theword.bmp
  } else {
    set picpath [file nativename $TwdBMP]
  }    
  #reset picpath every $slideshow secs
  set regpath [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
  registry set "$regpath" Wallpaper "$picpath" expand_sz
}

proc getSwayOutputName {} {
  #Get output(s) in raw (JSON) format
  set outputs [exec swaymsg --raw --type get_outputs]
  
  #Extract list of output name string(s), exit 1 if 0
  set nOutputs [regexp -all name $outputs]
  if {!$nOutputs} {
    return 1
  }

  set index 0
  for {set n 1} {$n<=$nOutputs} {incr n} {
    set line [regexp -start $index -line -inline {name.*$} $outputs]
    regsub -all {[name",: {}"]} $line {} outputName
    lappend outputList $outputName
    #reset index for regexp search
    set index [lindex [regexp -indices name $outputs] 1] 
  }

  return $outputList
}

# C r e a t e  ' s e t B g '   p r o c   i f   a p p l i c a b l e

#Create setBg proc for Windows
##this runs setWinBg and RUNDLL32 7x to update changed Registry entry
if {$platform=="windows"} {
  setWinBg

  proc setBg {} {
    for {set i 0} {$i < 7} {incr i} {
      after 150
      exec RUNDLL32.EXE user32.DLL,UpdatePerUserSystemParameters
    }
  }
  return
}

#Determine running Linux desktop
set runningDesktop [detectRunningLinuxDesktop]

#Set Sway Background
##NOTE: the extra prog 'swaybg' must be present although not called directly here!
if {$runningDesktop == 4} {
  
  if {[auto_execok swaybg] == ""} {
    
    package require Tk
    tk_messageBox -type ok -icon warning -title BiblePix -message "Your Sway desktop needs the extra program 'swaybg' to change background image. Please install and rerun Sway." 
    return 1
  }

  set swayOutput [getSwayOutputName]
  proc setBg {} {
    upvar swayOutput swayOutput
    exec swaymsg output $swayOutput bg $::TwdPNG fit
  }
  return
  
#Skip Gnome / KDE / XFCE4
} elseif {
    $runningDesktop == 1 || 
    $runningDesktop == 2 ||
    $runningDesktop == 3 } {
  return
}

#Create setBg for Xloadimage (general Linux, no effect on popular Desktops)
##tested on dwm
if {[auto_execok xloadimage] != ""} {
  proc setBg {} {
    exec xloadimage -onroot $::TwdPNG
  }
  return
}

#Create setBg for ImageMagick (general Linux, no effect on popular Desktops!)
if {[auto_execok display] != ""} {
  proc setBg {} {
    exec display -window root $::TwdBMP
  }
  return
}

#All other desktops:
proc setBg {} {
  return "Cannot set background."
}

