# ~/Biblepix/prog/src/com/LoadConfig.tcl
# Sets default values if Config missing - sourced by Globals
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 23aug17

#Source Config and LoadConfig for defaults
if { [catch {source $Config}] } {
  file mkdir $confdir
}

#Set language
if { ![info exists lang] } {
  set lang en

     if {$platform=="windows"} {
    package require registry
    if { ! [catch "set userlang [registry get [join {HKEY_LOCAL_MACHINE System CurrentControlSet Control Nls Language} \\] InstallLanguage]" ] } {
      #code 4stellig, alle Deutsch enden mit 07
      if {  [string range $userlang 2 3] == 07 } {
        set lang de
      }
    }
     } elseif {$platform=="unix"} {
    if {[info exists env(LANG)] && [string range $env(LANG) 0 1] == "de"} {
         set lang de
    }
     }
  # set chan [open $Config a]
  # puts $chan "set lang $lang"
  # close $chan
}

#Set Intro
if {![info exists enabletitle]} {
  set enabletitle 1
  # set chan [open $Config a]
  # puts $chan "set enabletitle $enabletitle"
  # close $chan
}

#Set Enable Pic
if {![info exists enablepic]} {
  set enablepic 1
  # set chan [open $Config a]
  # puts $chan "set enablepic $enablepic"
  # close $chan
}

#Set Enable Sig
if {![info exists enablesig]} {
  set enablesig 0
  # set chan [open $Config a]
  # puts $chan "set enablesig $enablesig"
  # close $chan
}

#Set Slideshow
if {![info exists slideshow]} {
  set slideshow 300
  # set chan [open $Config a]
  # puts $chan "set slideshow $slideshow"
  # close $chan
}

#Set fontfamily
if {![info exists fontfamily]} {
  if {$platform=="unix"} {
    set fontfamily {TkTextFont}
  } else {
    set fontfamily {Arial Unicode MS}
  }
  # set chan [open $Config a]
  # puts $chan "set fontfamily \{$fontfamily\}"
  # close $chan
}     

#Set fontsize (must exist and be digits)
if {![info exists fontsize] || ![regexp {[[:digit:]]} $fontsize] } {
  set fontsize 30
  # set chan [open $Config a]
  # puts $chan "set fontsize $fontsize"
  # close $chan
}

#Set fontweight
if {![info exists fontweight]} {
  if {$platform=="unix"} {
     set fontweight normal
        } else {
          set fontweight bold
        }
    # set chan [open $Config a]
    # puts $chan "set fontweight $fontweight"
    # close $chan
}

#Set fontcolortext
if {![info exists fontcolortext]} {
  set fontcolortext blue
  # set chan [open $Config a]
  # puts $chan "set fontcolortext $fontcolortext"
  # close $chan
}

#Set marginleft
if {![info exists marginleft]} {
  set marginleft 30
  # set chan [open $Config a]
  # puts $chan "set marginleft $marginleft"
  # close $chan
}

#Set margintop
if {![info exists margintop]} {
  set margintop 30
  # set chan [open $Config a]
  # puts $chan "set margintop $margintop"
  # close $chan
}

#Set current font colour
if {$fontcolortext == "blue"} {
  set fontcolor $blue
} elseif {$fontcolortext == "gold"} {
  set fontcolor $gold
} elseif {$fontcolortext == "green"} {
  set fontcolor $green
} elseif {$fontcolortext == "silver"} {
  set fontcolor $silver
} else {
  set fontcolor $blue
}
