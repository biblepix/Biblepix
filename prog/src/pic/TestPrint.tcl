# Biblepix/prog/src/pic/BdfPrint.tcl
# Updated: 10apr18

source $BdfTools

#T E S T I N G  FONTS
#source $fontdir/Times_24.tcl


#1. get TWD filename? - get full TwdText
set TwdText [getTodaysTwdText $::TwdFileName]
set TwdLang [getTwdLang $::TwdFileName]
set RtL [isRtL $TwdLang]
if {$RtL} {source $Bidi}

#2. TODO: check text for "italic" for <em> and Intro
set emText 0
set intro 0
if {$emText} {
  getTodaysTwdTextNodes ;#CHECK PROC FURTHER DOWN
  source $italicFont
}
if {$intro} {
  getTodaysTwdTextNodes
  source $italicFont
}

#3. source font(s) 
#set TwdLang [getTwdLang $::TwdFileName]
puts $TwdFileName
puts $TwdLang

##Chinese
if {$TwdLang == "zh"} {
  source $fontdir/asian/WenQuanYi_ZenHei_24.tcl
  ##Thai
  } elseif {$TwdLang == "th"} {
  source $fontdir/asian/Kinnari_Bold_20.tcl
  ##all else
  } else {
    
  # T O D O : GET FONT FROM config
  source [file join $fontdir $fontfamily.tcl]
  
}

#called by?
proc printLetterToImage {letterName img x y} {
  global sun shade color mark FBBx RtL
  upvar $letterName curLetter

  set BBxoff $curLetter(BBxoff)
  set BBx $curLetter(BBx)
  
  if {$RtL} {
     set BBxoff [expr $FBBx - $BBx - $BBxoff]
  }   

  set xLetter [expr $x + $BBxoff]
  set yLetter [expr $y - $curLetter(BByoff) - $curLetter(BBy)]

  set yCur $yLetter
  set pixelLines $curLetter(BITMAP)
  foreach pxLine $pixelLines {
    set xCur $xLetter
    for {set i 0} {$i < $curLetter(BBx)} {incr i} {
      set pxValue [string index $pxLine $i]
      
      if {$pxValue != 0} {
        switch $pxValue {
          1 { set pxColor $color }
          2 { set pxColor $sun }
          3 { set pxColor $shade }
          #testzeile (ROT!)
          default { set pxColor $mark }
        }
#puts "$xCur $yCur"
if { $xCur <0 } {set xCur 1 } 
        $img put $pxColor -to $xCur $yCur

      }
      incr xCur
    }
    incr yCur
  }
  
} ;#END printLetterToImage

#Called by writeText
proc writeTextLine {textLine x y img} {
  global mark print_32 TwdLang marginleft Bidi RtL
  
  upvar 2 FontAsc fontAsc
  upvar 2 FBBy FBBy
  set xBase $x
  set yBase [expr $y + $fontAsc]
      
  if {$RtL} {
    set imgW [image width $img]
    #set textLine [bidiBdf $textLine $TwdLang]
    set xBase [expr $imgW - ($marginleft*2) - $x]
  }
  
#puts $xBase
    
# TODO: setzt Kodierung nach Systemkodierung? -finger weg! -TODO: GEHT NICHT AUF LINUX!!!- TODO
#  set textLine [encoding convertfrom utf-8 $textLine]

  set letterList [split $textLine {}]

  foreach letter $letterList {
    set encLetter [scan $letter %c]
    
    upvar 2 "print_$encLetter" "print_$encLetter"
    
    if {[info exists "print_$encLetter"]} {
      array set curLetter [array get "print_$encLetter"]
      
    } else {
        
      array set curLetter [array get "print_32"]
    }

    printLetterToImage curLetter $img $xBase $yBase
    
    #sort out Bidi languages
    if {$RtL} {
      set xBase [expr $xBase - $curLetter(DWx)]
      } else {
      set xBase [expr $xBase + $curLetter(DWx)]
    }
    lappend lineLengthsList $xBase  
  
  } ;#END foreach
  
  return [expr $y + $FBBy]

} ;#END writeTextLine

#Ruft writeTextLine pro Textzeile auf
proc writeText {text x y img } {
#puts "text0 $text"

  global RtL Bidi TwdLang
  if {$RtL} {
    source $Bidi
    set text [bidiBdf $text $TwdLang]
  }
#puts "text1 $text"

  set textLines [split $text \n]
  
#if {$RtL} {set x 1650}

foreach line $textLines {
    set y [writeTextLine $line $x $y $img]
  }
  
  return $y
  
} ;#END writeText

set mark #ff0000
set x $marginleft
#if {$RtL} {
#  set imgW [image width $img]
#  set x [expr $imgW - $marginleft]
#}
set y $margintop
set color [set fontcolortext]

#TEST : below proc not necessary if twdText available
proc TestParseTwd {} { 
  set intro [getParolIntro $parolNode $TwdLang 1]
  if {$intro != ""} {
    addTextLineToTextImg $intro $textImg $RtL $indent
  }
  
  set text [getParolText $parolNode $TwdLang 1]
  set textLines [split $text \n]
  
  foreach line $textLines {
    addTextLineToTextImg $line $textImg $RtL $indent
  }
  
  set ref [getParolRef $parolNode $TwdLang 1]
  addTextLineToTextImg $ref $textImg $RtL [font measure BiblepixFont $tab]
}

set finalImg hgbild

set y [writeText $TwdText $x $y $finalImg]

if {$platform=="windows"} {  
    $finalImg write $TwdTIF -format TIFF
  
  } elseif {$platform=="unix"} {
    $finalImg write $TwdBMP -format BMP
    $finalImg write $TwdPNG -format PNG
  }
  
image delete $finalImg

#exit