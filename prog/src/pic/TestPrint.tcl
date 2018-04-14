# Biblepix/prog/src/pic/BdfPrint.tcl
# Updated: 10apr18

source $BdfTools

#T E S T I N G  FONTS
source $fontdir/Times_24.tcl


#1. get TWD filename? - get full TwdText
set TwdText [getTodaysTwdText $TwdFileName]

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
set TwdLanguage [getTwdLanguage $TwdFileName]
puts $twdFileName
puts $TwdLanguage

##Chinese
if {$TwdLanguage == "zh"} {
  source $fontdir/asian/WenQuanYi_ZenHei_24.tcl
  ##Thai
  } elseif {$TwdLanguage == "th"} {
  source $fontdir/asian/Kinnari_Bold_20.tcl
  ##all else
  } else {
    
  # T O D O : GET FONT FROM config
  #source $fontfamily
  
}


proc printLetterToImage {letterName img x y} {
  global sun shade color mark TwdLanguage FBBx
  upvar $letterName curLetter

puts "FBBx $FBBx"
puts "CurLetBBx $curLetter(BBx)"
puts "x $x"

#if {[array names curLetter] == ""} {return}
  set BBxoff $curLetter(BBxoff)
  set BBx $curLetter(BBx)
  
  if {$TwdLanguage=="he"} {
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
        
        $img put $pxColor -to $xCur $yCur
      }
      incr xCur
    }
    incr yCur
  }
  
} ;#END printLetterToImage

proc writeTextLine {textLine x y img} {
  global mark print_32 TwdLanguage marginleft
  
  upvar 2 FontAsc fontAsc
  upvar 2 FBBy FBBy
  
  if {$TwdLanguage == "he"} {
  #set right margin + eliminate Nikud
    regsub -all {[\u0591-\u05C7]} $textLine {} textLine
    set screenW [winfo screenwidth .]
    
    #Todo: iRGENDWAS STIMMT HIER NOCH NICHT ...
    set xBase [expr $screenW - $marginleft - $marginleft - $marginleft]
  
  } else {
    set xBase $x
  }
  
  set yBase [expr $y + $fontAsc]
  
#setzt Kodierung nach Systemkodierung? -finger weg! -TODO: GEHT NICHT AUF LINUX!!!
#  set textLine [encoding convertfrom utf-8 $textLine]

  set letterList [split $textLine {}]

  foreach letter $letterList {
    set encLetter [scan $letter %c]
    
    upvar 2 "print_$encLetter" "print_$encLetter"
    
    if {[info exists "print_$encLetter"]} {
      array set curLetter [array get "print_$encLetter"]
      
    } else {
    
    #sonst Abstandzeichen
      array set curLetter [array get "print_32"]
    }

    printLetterToImage curLetter $img $xBase $yBase
    
    #sort out Bidi languages
    if {$TwdLanguage == "he"} {
      set xBase [expr $xBase - $curLetter(DWx)]
      } else {
      set xBase [expr $xBase + $curLetter(DWx)]
    }
  }
  
  return [expr $y + $FBBy]

} ;#END writeTextLine

#Ruft writeTextLine pro Textzeile auf
proc writeText {text x y img} {
  set textLines [split $text \n]
  
  foreach line $textLines {
    set y [writeTextLine $line $x $y $img]
  }
  
  return $y
  
} ;#END writeText

set mark #ff0000
set x $marginleft
set y $margintop
set color [set fontcolortext]

#TEST : below not necessary if twdText available
proc TestParseTwd {} { 
  set intro [getParolIntro $parolNode $TwdLanguage 1]
  if {$intro != ""} {
    addTextLineToTextImg $intro $textImg $RtL $indent
  }
  
  set text [getParolText $parolNode $TwdLanguage 1]
  set textLines [split $text \n]
  
  foreach line $textLines {
    addTextLineToTextImg $line $textImg $RtL $indent
  }
  
  set ref [getParolRef $parolNode $TwdLanguage 1]
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