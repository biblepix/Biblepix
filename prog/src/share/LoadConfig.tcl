# ~/Biblepix/prog/src/share/LoadConfig.tcl
# Sets default values if Config missing - sourced by Globals
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 2jan21 pv

#Source Config and LoadConfig for defaults
if { [catch {source $Config}] } {
  file mkdir $dirlist(confdir)
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
  
    if [info exists env(LANG)] {
      set syslangCode [string range $env(LANG) 0 1]
    }
    if {[info exists syslangCode] && $syslangCode == "de"} {
      set lang de
    }
    if {![info exists DesktopPicturesDir]} {
      set DesktopPicturesDir $HOME
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
#Set fontsize (must exist and be digits and be listed in fontSizeList)
if {![info exists fontsize] || ![string is digit $fontsize] || ![regexp $fontsize $fontSizeList]} {
  set fontsize [lindex $fontSizeList 1]
}
#Set fontweight
if {![info exists fontweight]} {
  set fontweight normal
}
#Set fontcolortext
if {![info exists fontcolortext]} {
  set fontcolortext Gold
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
#Set Httpmock
if {![info exists Httpmock]} {
  set Httpmock 0
}

#Set current font colour in hex for GUI
##getting fontcolortext from Config & extracting rgb from array
array set colArr [array get [string tolower $fontcolortext 0]]
set fontcolourHex [format "#%02x%02x%02x" $colArr(r) $colArr(g) $colArr(b)]

#if {$fontcolortext == "Gold"} {
#  set fontcolor [rgb2hex $gold(r) $gold(g) $gold(b)]
#} elseif {$fontcolortext == "Green"} {
#  set fontcolor [rgb2hex $green(r) $green(g) $green(b)]
#} elseif {$fontcolortext == "Silver"} {
#  set fontcolor [rgb2hex $silver(r) $silver(g) $silver(b)]
#} elseif {$fontcolortext == "Black"} {
#  set fontcolor [rgb2hex $black(r) $black(g) $black(b)]  
###blue or undefined:
#} else {
#  set fontcolor [rgb2hex $blue(r) $blue(g) $blue(b)]
#}

#Define current font name from Config
if {$fontfamily=="Sans"} {
  set fontFamilyTag "Arial"
} elseif {$fontfamily=="Serif"} {
  set fontFamilyTag "Times"
}
if {$fontweight=="bold"} {
  set fontWeightTag B
} else {
  set fontWeightTag ""
}
set fontname "${fontFamilyTag}${fontWeightTag}${fontsize}"
set fontnameBold "${fontFamilyTag}B${fontsize}"
#for Italic: reset fontname to normal if Bold
set fontnameItalic "${fontFamilyTag}I${fontsize}"
