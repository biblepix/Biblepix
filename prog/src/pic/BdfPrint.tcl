# Biblepix/prog/src/pic/BdfPrint.tcl
# Updated: 19apr18

source $BdfTools

#1. Get today's TWD nodes - todo , THIS IS SOMEWHERE ELSE!!!!!!
setTodaysTwdNodes $::TwdFileName
set TwdLang [getTwdLang $::TwdFileName]

#move?
set RtL [isRtL $TwdLang]
if {$RtL} {source $Bidi}

#2. Preset font names
  ##Chinese: (regular_24)
if {$TwdLang == "zh"} {
  set fontFile $BdfFontsArray(ChinaFont)
  
  ##Thai: (regular_20)
  } elseif {$TwdLang == "th"} {
  set fontFile $BdfFontsArray(ThaiFont)
  
  ##all else: regular & italic
  } else {
  
  #get from Config
  set fontFile $BdfFontsArray($fontfamily)
    
}

#Source Regular Font for all languages
namespace eval R {
  source $fontFile
  #puts $FontAsc
  #namespace export FontAsc
}

#Source Italic font for European languages, set to Regular for others
namespace eval I {
  set fontfamilyI ${fontfamily}I
  set fontFileI $BdfFontsArray($fontfamilyI)
  if [catch {source $fontFileI}] {
    source $fontFile
  }
}

#Source Bold font for title in European languages, set to Regular for others
if {$enabletitle} { 
  namespace eval B {
    set fontfamilyB ${fontfamily}B
    set fontFileB $BdfFontsArray($fontfamilyB)
    if [catch {source $fontFileB}] {
      source $fontFile
    }
  }
}

#Export global font vars


set ::FontAsc $R::FontAsc
set ::FBBy $R::FBBy
set ::FBBx $R::FBBx

#move?
set color [set fontcolortext]

#3. Print Twd to image
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