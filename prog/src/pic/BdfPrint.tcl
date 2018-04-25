# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Updated: 25apr18

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
  namespace eval R {
    source -encoding utf-8 $fontFile
  }
  ##Thai: (regular_20)
} elseif {$TwdLang == "th"} {
  set fontFile $BdfFontsArray(ThaiFont)
  namespace eval R {
    source -encoding utf-8 $fontFile
  }
  
  
## ALL ELSE: REGULAR / BOLD / ITALIC
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
} ;#END main condition

#Export global font vars - TODO: Joel ich hoffte hierdurch das Problem mit Italic zu beheben, aber nein!

set ::FontAsc $I::FontAsc
#set ::FBBy $R::FBBy
#set ::FBBx $R::FBBx

#move?
set color [set fontcolortext]

#3. LAUNCH PRINTING & SAVE IMAGE
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