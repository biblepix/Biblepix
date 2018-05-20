# ~/Biblepix/prog/src/pic/setBackgroundChanger.tcl
# Searches system for current Desktop manager, gives out appropriate BG changing command
# Called by Biblepix
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 20may18

# GNOME: needs no image changer, detects image change (just provide imgPath at setupSave)
# KDE: needs to be configured (in setupSave)
# XFCE4: needs to be configured (in setupSave)
# KDE & XFCE4 can't accept easy script input

# B a c k g r o u n d  c h a n g e r s

proc setWinBG {} {
  package require registry
  set regpath [join {HKEY_CURRENT_USER {Control Panel} Desktop} \\]
  registry set $regpath Wallpaper [file nativename $::TwdTIF]
}

proc setSwayBg {} {
  set outputs [exec swaymsg -t get_outputs]
  #find lines with 'Output' and copy last/next word - 2 diff. formats found!
  foreach line [split $outputs \n] {
    if [regexp "Output" $line] {
      return "swaymsg $line bg $::TwdBMP stretch"
      
    } elseif [regexp "name" $line] {
    
      set s [regexp -line -inline -lineanchor {name.*$} $line]
      puts $s
      regsub -all {[",:"]} $s {} s
      puts $s
      regsub {name } $s {} outputName
     puts $outputName
    }
  }
  ##STILL TESTING if * is enough:
  set outputName *
  return $outputName
}

# C r e a t e   'setBg'   p r o c   i f   a p p l i c a b l e

#Create setBg proc for Windows 
if {$platform=="windows"} {
  setWinBg
  proc setBg {} {
    exec RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters 1, True
  }
  return
}

#Create setBg for Wayland/Sway 
if { [info exists env(SWAYSOCK)] } {
  
  set ::outputName [setSwayBg]

  proc setBg {} {
    upvar 1 outputName outputName
    #exec swaymsg output $outputName bg $::TwdBMP stretch
    exec swaymsg output $outputName bg $::TwdBMP stretch
    
  }

  return
}

#Create setBg for Xloadimage (general Linux)
if {[auto_execok xloadimage] != ""} {
  proc setBg {} {
    exec xloadimage -onroot $::TwdPNG
  }
  return
}

#Create setBg for ImageMagick (general Linux)
if {[auto_execok display] != ""} {
  proc setBg {} {
    exec display -window root $::TwdPNG
  }
  return
}