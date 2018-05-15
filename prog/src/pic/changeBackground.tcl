# ~/Biblepix/prog/src/pic/changeBackground.tcl
# Searches system for current Desktop manager, gives out appropriate BG changing command
# Called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15may18

# TODO: try XDG_CURRENT_DESKTOP

# getDesktopList
## produces List of all installed Desktop managers
proc getDesktopList {} {
  global platform

  if {$platform=="windows"} {
    lappend desktopList "Win"
    
  } else {
    
    #check xloadimage / display (ImageMagick)
    if {[auto_execok xloadimage] != ""} {
      lappend desktopList Xloadimage
    } elseif {[auto_execok display] != ""} {
      lappend desktopList ImageMagick
    }

    #check Wayland/Sway
    if {[auto_execok swaymsg] != ""} {
      lappend desktopList Sway
    }
    
    #check GNOME
    if {[auto_execok gsettings] != ""} {
      lappend desktopList Gnome3
    }
    if {[auto_execok gconftool-2] != ""} {
      lappend desktopList Gnome2
    }
  }
  return $desktopList
}

#Create list of desktops
set desktopList [getDesktopList]

#Create list of corresponding procs
foreach desktop $desktopList {
  switch $desktop {
    Gnome2 {lappend procList setGnomeBg}
    Gnome3 {lappend procList setGnomeBg}
    Xloadimage {lappend procList setXloadimageBg}
    ImageMagick {lappend procList setImageMagickBg}
    Sway {lappend procList setSwayBg}
  }
}


############## Change Background commands ##################3

proc setWinBG {} {
  package require registry
  set regpath [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
  registry set $regpath Wallpaper [file nativename $::TwdTIF]
  return "RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters 1, True"
}

#setSwayBg + getSwayOutputs
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

proc setGnomeBg {} {
  #Gnome2
  if {[auto_execok gconftool-2] != ""} {
    return "gconftool-2 --type=string --set /desktop/gnome/background/picture_filename $::TwdPNG"
  #Gnome3
  } elseif {[auto_execok gsettings] != ""} {
    return "gsettings set org.gnome.desktop.background picture-uri file:///$::TwdPNG"
  }
}


#### Produce final setBg proc, to be imported by Biblepix #####

namespace eval Background {
  
  proc setBg {} {
    global comList
    foreach command $comList {
      catch {exec $command}
    }
  }
  namespace export setBg
}

#Create list of commands for Biblepix
foreach proc $procList {
    lappend Background::comList [$proc]
}
puts $Background::comList