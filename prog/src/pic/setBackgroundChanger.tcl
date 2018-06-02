# ~/Biblepix/prog/src/pic/setBackgroundChanger.tcl
# Searches system for current Desktop manager, gives out appropriate BG changing command
# Called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 1jun18

########################################################################
# WINDOWS: accepts command through RUNDLL32.EXE - a bit buggy still...
# LINUX SWAY (WAYLAND): accepts command through 'swaymsg'
# GNOME: needs no image changer, detects image change, so just provide imgPath (in setupSave)
# KDE: needs to be configured (in setupSave)
# XFCE4: needs to be configured (in setupSave)
##########################################################################


# detectRunningLinuxDesktop
##returns 1 if GNOME or WAYLAND-SWAY detected
##returns 2 if KDE or XFCE4 detected
##returns 0 if no running desktop detected
##called by SetupSaveLin & SetBackgroundChanger
proc detectRunningLinuxDesktop {} {
  global env
  
  #check GNOME
  if { [info exists env(GNOME_KEYRING_CONTROL)] ||
       [info exists env(GNOME_DESKTOP_SESSION_ID)] } {
    puts GnomeDetected
    return 1
    
  }
  
  #check KDE / XFCE
  if [info exists env(XDG_CURRENT_DESKTOP)] {
  
    if {$env(XDG_CURRENT_DESKTOP) == "KDE" ||
        $env(XDG_CURRENT_DESKTOP) == "XFCE" } {
      return 2
    }
    
  } elseif [info exists env(DESKTOP_SESSION)] {
    
    if {$env(DESKTOP_SESSION) == "kde-plasma" ||
        $env(DESKTOP_SESSION) == "xfce" } {
      return 2
    }
  }
  
  #detect Wayland/Sway
  if { [info exists env(SWAYSOCK)] ||
       [info exists env(WAYLAND_DISPLAY)] } {
       puts SwayDetected
    return 1
  }

  #nothing found
  puts nothingDetected
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

# C r e a t e   'setBg'   p r o c   i f   a p p l i c a b l e

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

#Skip Gnome / KDE / XFCE4 / Wayland-Sway
if [detectRunningLinuxDesktop] {
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
    exec display -window root $::TwdPNG
  }
  return
}