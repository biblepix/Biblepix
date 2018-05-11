# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 11may18

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

puts $BdfFontsArray($fontName)
  # Source Regular if fontweight==normal
  if {$fontweight == "normal"} {
    namespace eval R {
      source -encoding utf-8 $BdfFontsArray($fontName)
    }
  }
  
  #Source Italic for all (asian filtered out later)  
  namespace eval I {
    source -encoding utf-8 $BdfFontsArray($fontNameItalic)
  }

  #Source Bold if $enabletitle OR $fontweight==bold
  if {$enabletitle || $fontweight == "bold"} { 
    namespace eval B {
      source -encoding utf-8 $BdfFontsArray($fontNameBold)
    }
  }
} ;#END source fonts

#Export global font vars (fontweight doesn't matter!)
if [namespace exists R] { 
  set prefix R
  } elseif [namespace exists B] {
  set prefix B
  } elseif [namespace exists I] {
  set prefix I
}
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