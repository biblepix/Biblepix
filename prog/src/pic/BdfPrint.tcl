# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 12may18

#1. SET BASIC VARS
source $TwdTools
source $BdfTools
set TwdLang [getTwdLang $::TwdFileName]
set ::RtL [isRtL $TwdLang]
puts $TwdLang

#2. SOURCE FONTS INTO NAMESPACES

##Chinese: (regular_24)
if {$TwdLang == "zh"} {
  set ::prefix Z
  if {! [namespace exists Z]} {
    namespace eval Z {
      source -encoding utf-8 $BdfFontsArray(ChinaFont)
    }
  }

  ##Thai: (regular_20)
  } elseif {$TwdLang == "th"} {
  set ::prefix T
    if {! [namespace exists T]} {
      namespace eval T {
        source -encoding utf-8 $BdfFontsArray(ThaiFont)
      }
    }
  
  ## All else: Regular / Bold / Italic
  } else {

  # Source Regular ???if fontweight==normal - gab einige Störungen, weiss nicht warum...
  # vorläufig wirds immer geladen, auch wenn bei "fontweight==bold" kein R:: nötig wäre
  #if {$fontweight == "normal"} {
    if {! [namespace exists R]} {
    set ::prefix R
      namespace eval R {
        source -encoding utf-8 $BdfFontsArray($fontName)
#        puts $FontAsc
      }
    }
#  }
  
  #Source Italic for all except Asian
  if {! [namespace exists I]} {
    namespace eval I {
      source -encoding utf-8 $BdfFontsArray($fontNameItalic)
#      puts $FontAsc
    }
  }
  
  #Source Bold if $enabletitle OR $fontweight==bold
  if {$enabletitle || $fontweight == "bold"} { 
    if {! [namespace exists B]} {
      namespace eval B {
        source -encoding utf-8 $BdfFontsArray($fontNameBold)
#        puts $FontAsc
      }
    }
  }
} ;#END source fonts

# 3. LAUNCH PRINTING & SAVE IMAGE
set img hgbild
set finalImg [printTwd $TwdFileName $img]

if {$platform=="windows"} {  
    $finalImg write $TwdTIF -format TIFF
  
  } elseif {$platform=="unix"} {
    $finalImg write $TwdBMP -format BMP
    $finalImg write $TwdPNG -format PNG
  }

#Cleanup
image delete $finalImg