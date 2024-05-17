# ~/Biblepix/prog/src/share/LoadConfig.tcl
# Sets default values if Config missing - sourced by Globals
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 5jan23 pv

#Source Config and LoadConfig for defaults
if [catch {source $Config}] {
  file mkdir $confdir
}

#Set Setup lang from Conf, else from system
if ![info exists lang] {

  ##get system lang for Win
  if {$platform=="windows"} {
  
    #get user lang from registry
    ## NOTE: old solution was to extract SYSTEM INSTALL LANGUAGE NUMBER CODE, but new gets user lang
    ## (OBSOLETE CODE: registry get [join {HKEY_LOCAL_MACHINE System CurrentControlSet Control Nls Language} \\	] InstallLanguage)
    package require registry
    if ![catch {set locale [registry get [join {HKEY_CURRENT_USER {Control Panel} International} \\] LocaleName]} ] {
      set syslang [string range $locale 0 1]
    }

  ##get system lang for Linux
  } elseif {$platform=="unix"} {
  
    if [info exists env(LANG)] {
      set syslang [string range $env(LANG) 0 1]
    }
  }

  #compare syslang with langs in $msgdir, fallback: en
  if [info exists syslang] {
    set msgL [glob -directory $msgdir -tail *.msg]
    if {[string first $syslang $msgL] >= 0} {
      set lang $syslang
    } else {
      set lang "en"
    }
  }
}

#Populate sigLangList with at least $lang
if ![info exists sigLanglist] {
  set sigLanglist $lang
}

#Linux: set user picdir to $HOME
if ![info exists DesktopPicturesDir] {
  set DesktopPicturesDir "$env(HOME)"
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
  set fontfamily "Serif"
}

# F O N T S I Z E

##Set GENERAL fontsize to 20pt if not defined or not in fontsizeL
if {![info exists fontsize] || [lsearch $fontSizeL $fontsize] == "-1" } {
  set fontsize [lindex $fontSizeL 2]
}

##Set CHINESE ITALIC: use regular
set ChinafontI${fontsize} [file join $fontdir Wenquanyi${fontsize}.tcl]

# setChinafontBold
##sets Chinese Bold font to next bigger regular if exists
##called by BdfPrint
proc setChinafontBold {fontsize} {
  global fontSizeL fontdir
  set curInd [lsearch $fontSizeL $fontsize]
  set nextsize [lindex $fontSizeL [incr curInd]]
  if {$nextsize != ""} {
    set ChinafontB [file join $fontdir Wenquanyi${nextsize}.tcl]
  } else {
    set ChinafontB [file join $fontdir Wenquanyi${fontsize}.tcl]
  }
  return $ChinafontB
}
# setChinafontItalic - TODO geht noch nicht! - probably unnecessary anyway
##sets Chinese Italic font (refs) to next smaller regular if exists
##called by BdfPrint
proc setChinafontItalic {fontsize} {
  global fontSizeL fontchinadir
  set curInd [lsearch $fontSizeL $fontsize]
  set prevsize [lindex $fontSizeL [incr curInd -1]]
  if {$prevsize != ""} {
    set ChinafontI [file join $fontchinadir Wenquanyi${prevsize}.tcl]
  } else {
    set ChinafontI [file join $fontchinadir Wenquanyi${fontsize}.tcl]
  }
  return $ChinafontI
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

## Prepare $Http sourcing for Setup
#Set Debug
if ![info exists Debug] {
  set Debug 0
}
#Set Httpmock
if ![info exists Httpmock] {
  set Httpmock 0
}

#Handle Http & HttpMock
if { [info exists Httpmock] && $Httpmock} {
  proc sourceHTTP {} {
    source $::HttpMock
  }
} else {
  proc sourceHTTP {} {
    source $::Http
  }
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
