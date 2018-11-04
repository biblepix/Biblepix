# ~/Biblepix/prog/src/com/LoadConfig.tcl
# Sets default values if Config missing - sourced by Globals
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 4nov18

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
}

#Set Intro
if {![info exists enabletitle]} {
  set enabletitle 1
}

#Set Enable Pic
if {![info exists enablepic]} {
  set enablepic 1
}

#Set Enable Sig
if {![info exists enablesig]} {
  set enablesig 0
}

#Set Slideshow
if {![info exists slideshow]} {
  set slideshow 300
}

#Set fontfamily
if {![info exists fontfamily] || ($fontfamily != "Sans" && $fontfamily != "Serif")} {
  set fontfamily "Sans"
}

#Set fontsize (must exist and be digits)
if {![info exists fontsize] || ![regexp {[[:digit:]]} $fontsize] || ($fontsize != 20 && $fontsize != 24 && $fontsize != 30)} {
  set fontsize 24
}

#Set fontweight
if {![info exists fontweight]} {
  set fontweight normal
}

#Set fontcolortext
if {![info exists fontcolortext]} {
  set fontcolortext blue
}

#Set marginleft
if {![info exists marginleft]} {
  set marginleft 30
}

#Set margintop
if {![info exists margintop]} {
  set margintop 30
}

#Set Debug
if {![info exists Debug]} {
  set Debug 0
}

#Set httpmock
if {![info exists httpmock]} {
  set httpmock 0
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
