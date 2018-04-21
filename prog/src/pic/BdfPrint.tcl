# Biblepix/prog/src/pic/BdfPrint.tcl
# Updated: 19apr18

source $BdfTools

#1. Get today's TWD nodes - todo , THIS IS SOMEWHERE ELSE!!!!!!
setTodaysTwdNodes $::TwdFileName
set TwdLang [getTwdLang $::TwdFileName]

#move?
set RtL [isRtL $TwdLang]
if {$RtL} {source $Bidi}

#2. Source font(s) 

##Chinese: regular
if {$TwdLang == "zh"} {
  source $fontdir/asian/WenQuanYi_ZenHei_24.tcl
  ##Thai: regular
  } elseif {$TwdLang == "th"} {
  source $fontdir/asian/Kinnari_Bold_20.tcl
  ##all else: regular & italic
  } else {
    
  source [file join $fontdir $fontfamily.tcl]
  source [file join $fontdir italic ${fontfamily}I.tcl]
}


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
