# ~/Biblepix/prog/src/pic/changeBackground.tcl
# Searches system for current Desktop manager, gives out appropriate BG changing command
# Called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 18may18

# GNOME: needs no image changer, detects image change (just provide imgPath at setupSave)
# KDE: needs to be configured (in setupSave)
# XFCE4: needs to be configured (in setupSave)
## KDE & XFCE4 can't accept easy script input

proc getCurrentDesktop {} {

  # W i n d o w s
  
  if {$::platform=="windows"} {
    return Win
  }

  #L i n u x e s :

  ##rule out Gnome and KDE
  if {! [info exists env(GNOME_KEYRING_CONTROL)] &&
      ! [info exists env(GNOME_DESKTOP_SESSION_ID)] } {
    return ""
  }
      
  if { [info exists env(XDG_CURRENT_DESKTOP)] &&
      $env(XDG_CURRENT_DESKTOP) != "KDE" } {
    return ""
  }

  #check Wayland/Sway
  if { [info exists env(SWAYSOCK) || 
      [info exists env(WAYLAND_DISPLAY)] } {
    return Sway
  }

  #check 'xloadimage' / 'display' (ImageMagick)
  if {[auto_execok xloadimage] != ""} {
    lappend desktopList Xloadimage
    return Xloadimage
    } elseif {[auto_execok display] != ""} {
    return ImageMagick
  }
}

set curDesktop [getCurrentDesktop]

#Define command for setBg
if {! [info exists curDesktop]} {
  return ""
}

switch $curDesktop {
  Win {set command setWinBg}
  Sway {set command setSwayBg}
  Xloadimage {set command setXloadimageBg}
  ImageMagick {set command setImageMagickBg}
}

#Produce final setBg command for Biblepix
namespace eval Background {
  proc setBg {} {
    catch {exec $::command}
    namespace export setBg
  }
}



############## Change Background Procs ###########
##################################################

proc setWinBG {} {
  package require registry
  set regpath [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
  registry set $regpath Wallpaper [file nativename $::TwdTIF]
  return "RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters 1, True"
}

proc setSwayBg {} {
  set outputs [exec swaymsg -t get_outputs]
  #find lines with 'Output' and copy last/next word - 2 diff. formats found!
  foreach line [split $outputs \n] {
    if [regexp "Output" $line] {
      return "swaymsg $line bg $::TwdBMP stretch"
    } elseif [regexp "name" $line] {
      set s [string range $line 8 end]
      return "swaymsg output $s bg $::TwdBMP stretch"
    }
  }
}

proc setXloadimageBg {} {
  #General Linux desktops (does not work with modern desktop managers)
  return "xloadimage -onroot $::TwdPNG"
}

proc setImageMagickBg {} {
  #General Linux desktops (does not work with modern desktop managers)
  return "display -window root $::TwdPNG"
}