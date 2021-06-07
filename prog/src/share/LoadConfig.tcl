# ~/Biblepix/prog/src/share/LoadConfig.tcl
# Sets default values if Config missing - sourced by Globals
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 6jun21 pv

#Source Config and LoadConfig for defaults
if [catch {source $Config}] {
  file mkdir $confdir
}

#Set lang var to English or German, depending if system lang found
if ![info exists lang] {
  set lang en

  if {$platform=="windows"} {
    package require registry
    if ![catch {set userlang [registry get [join {HKEY_LOCAL_MACHINE System CurrentControlSet Control Nls Language} \\] InstallLanguage]} ] {
      #code 4stellig, alle Deutsch enden mit 07
      if { [string range $userlang 2 3] == 07 } {
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
    if ![info exists DesktopPicturesDir] {
      set DesktopPicturesDir $HOME
    }
  }
}
if ![info exists sigLanglist] {
  set sigLanglist $lang
}
 
#Set Intro
if ![info exists enabletitle] {
  set enabletitle 1
}
#Set Enable Pic
if ![info exists enablepic] {
  set enablepic 1
}
#Set Enable Sig
if ![info exists enablesig] {
  set enablesig 0
}
#Set Slideshow
if ![info exists slideshow] {
  set slideshow 300
}
#Set fontfamily
if {![info exists fontfamily] || ($fontfamily != "Sans" && $fontfamily != "Serif")} {
  set fontfamily "Sans"
}
#Set fontsize (must exist and be digits and be listed in fontSizeL)
if {![info exists fontsize] || ![string is digit $fontsize] || ![regexp $fontsize $fontSizeL]} {
  set fontsize [lindex $fontSizeL 1]
}
#Set fontweight
if ![info exists fontweight] {
  set fontweight normal
}
#Set fontcolortext, avoiding old colour names in Config
if {![info exists fontcolortext] || [lsearch $fontcolourL $fontcolortext] == -1} {
  set fontcolortext Gold
}
#enable random fontcolor by default
if ![info exists enableRandomFontcolor] {
  set enableRandomFontcolor 1
}
#Set marginleft
if ![info exists marginleft] {
  set marginleft 30
}
#Set margintop
if ![info exists margintop] {
  set margintop 30
}
#Set Debug
if ![info exists Debug] {
  set Debug 0
}
#Set Httpmock
if ![info exists Httpmock] {
  set Httpmock 0
}

#Set colour hex values & export to ::colour namespace
foreach c $fontcolourL {
  set arrname ${c}Arr
  array set myarr [array get $arrname]
  set hexval [format "#%02x%02x%02x" $myarr(r) $myarr(g) $myarr(b)]
  ##export hex values to ::colour namespace
  namespace eval colour {
    variable colname $c
    variable val $hexval
    set $colname $val
  }
}

#Set current font colour (from fontcolortext in Config)
set fontcolorHex [set fontcolortext]

#Define current font name from Config
if {$fontfamily=="Sans"} {
  set fontFamilyTag "Arial"
} elseif {$fontfamily=="Serif"} {
  set fontFamilyTag "Times"
}
if {$fontweight=="bold"} {
  set fontweightState 1
  set fontWeightTag B
} else {
  set fontweightState 0
  set fontWeightTag ""
}
set fontname "${fontFamilyTag}${fontWeightTag}${fontsize}"
set fontnameBold "${fontFamilyTag}B${fontsize}"
#for Italic: reset fontname to normal if Bold
set fontnameItalic "${fontFamilyTag}I${fontsize}"
