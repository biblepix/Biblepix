# ~/Biblepix/prog/src/pic/setBackgroundChanger.tcl
# Searches system for current Desktop manager, gives out appropriate BG changing command
# Called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 26jun18

########################################################################
# WINDOWS: accepts command through RUNDLL32.EXE - a bit buggy still...
# LINUX SWAY (WAYLAND): accepts command through 'swaymsg'
# GNOME: needs no image changer, detects image change
# KDE: needs to be preconfigured (in setupSave)
# XFCE4: needs to be preconfigured (in setupSave)
##########################################################################


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
  if { [info exists env(SWAYSOCK)] ||
       [info exists env(WAYLAND_DISPLAY)] } {
    return 4
  }

  #no desktop detected
  return 0
}


# B a c k g r o u n d  c h a n g e r s
proc setWinBg {} {
  package require registry
  set regpath [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
  registry set $regpath Wallpaper [file nativename $::TwdTIF]
}

proc setSwayBg {} {
  #Get output(s) in raw (JSON) format
  set outputs [exec swaymsg --raw --type get_outputs]
  #Extract first output name string - TODO: allow for several output names!!!
  foreach line [split $outputs \n] {
    if [regexp "name" $line] {
      set s [regexp -line -inline -lineanchor {name.*$} $line]
      regsub -all {[name",: {}"]} $s {} outputName
    }
  }
  
  return $outputName
}

# C r e a t e  ' s e t B g '   p r o c   i f   a p p l i c a b l e

#Create setBg proc for Windows 
if {$platform=="windows"} {
  setWinBg
  proc setBg {} {
    for {set i 0} {$i < 10} {incr i} {
      sleep 100
      exec RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters 1, True
    }
  }
  return
}

set runningDesktop [detectRunningLinuxDesktop]

#Set Sway Background
if {$runningDesktop == 4} {
  set swayOutput [setSwayBg]
  proc setBg {} {
    upvar swayOutput swayOutput
    exec swaymsg output $swayOutput bg $::TwdBMP center
  }
  return
  
#Skip Gnome / KDE + XFCE4
} elseif {
    $runningDesktop == 1 || 
    $runningDesktop == 2 ||
    $runningDesktop == 3 } {
  return
}

#Create setBg for Xloadimage (general Linux, no effect on modern Desktops!)
if {[auto_execok xloadimage] != ""} {
  proc setBg {} {
    exec xloadimage -onroot $::TwdPNG
  }
  return
}

#Create setBg for ImageMagick (general Linux, no effect on modern Desktops!)
if {[auto_execok display] != ""} {
  proc setBg {} {
    exec display -window root $::TwdBMP
  }
  return
}