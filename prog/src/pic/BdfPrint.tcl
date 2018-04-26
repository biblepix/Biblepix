# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 26apr18

#1. SET BASIC VARS
source $BdfTools
set TwdLang [getTwdLang $::TwdFileName]
set ::RtL [isRtL $TwdLang]

#2. SOURCE FONTS INTO NAMESPACES

##Chinese: (regular_24)
if {$TwdLang == "zh"} {
  set fontFile $BdfFontsArray(ChinaFont)
  namespace eval R {
    source -encoding utf-8 $fontFile
  }

##Thai: (regular_20)
} elseif {$TwdLang == "th"} {
  set fontFile $BdfFontsArray(ThaiFont)
  namespace eval R {
    source -encoding utf-8 $fontFile
  }
  
  
## All else: Regular / Bold / Italic
} else {

  #Get $fontfamily from Config
  set fontFile $BdfFontsArray($fontfamily)

  # Source Regular if fontweight==normal
  if {$fontweight == "normal"} {
    namespace eval R {
      source -encoding utf-8 $fontFile
    }
  }
  
  #Source Italic for all
  namespace eval I {
    set fontfamilyI ${fontfamily}I
    set fontFileI $BdfFontsArray($fontfamilyI)
    source -encoding utf-8 $fontFileI
  }

  #Source Bold if $enabletitle OR $fontweight==bold
  if {$enabletitle || $fontweight == "bold"} { 
    namespace eval B {
      set fontfamilyB ${fontfamily}B
      set fontFileB $BdfFontsArray($fontfamilyB)
      source -encoding utf-8 $fontFileB
    }
  }
} ;#END source fonts

#Export global font vars (sind gleich in R/B/I)
if [namespace exists R] {set prefix R}
if [namespace exists B] {set prefix B}
if [namespace exists I] {set prefix I}
set ::FontAsc $${prefix}::FontAsc
set ::FBBy $${prefix}::FBBy
set ::FBBx $${prefix}::FBBx

#move?
set color [set fontcolortext]

# 3. LAUNCH PRINTING & SAVE IMAGE
set img hgbild
set finalImg [printTwd $TwdFileName $img]

if {$platform=="windows"} {  
    $finalImg write $TwdTIF -format TIFF
  
  } elseif {$platform=="unix"} {
    $finalImg write $TwdBMP -format BMP
    $finalImg write $TwdPNG -format PNG
  }
  
image delete $finalImg

#exit