# Biblepix/prog/src/pic/BdfPrint.tcl
# Updated: 10apr18

source $BdfTools

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
puts $TwdFileName
puts $TwdLang

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

#called by printTexTLine
proc printLetter {letterName img x y} {
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
  
} ;#END printLetter


#Called by writeText
proc printTextLine {textLine x y img} {
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
  
  
# T O D O: setzt Kodierung nach Systemkodierung? -finger weg! -TODO: GEHT NICHT AUF LINUX!!!- TODO
#  set textLine [encoding convertfrom utf-8 $textLine]

  set letterList [split $textLine {}]

  foreach letter $letterList {

    #set fontweight: < for I / > for R
    if {$letter == "<"} {
      set weight I
      continue
      } elseif {$letter == ">"} {
      set weight R
      continue
    }

    set encLetter [scan $letter %c]
    
    
    
    upvar 2 $weight::print_$encLetter print_$encLetter
    
    
    
    if {[info exists "$weight::print_$encLetter"]} {
      array set curLetter [array get "$weight::print_$encLetter"]
      
    } else {
        
      array set curLetter [array get "R::print_32"]
    }

    printLetter curLetter $img $xBase $yBase
    
    
    
       
    #sort out Bidi languages
    if {$RtL} {
      set xBase [expr $xBase - $curLetter(DWx)]
      } else {
      set xBase [expr $xBase + $curLetter(DWx)]
    }
    
  } ;#END foreach
  
  return [expr $y + $FBBy]

} ;#END printTextLine


#Called by main process
#Calls printTextLine per line
proc prepareText {text x y img } {

  global RtL Bidi TwdFileName TwdLang sharedir
  
  # 1. P r e p a r e   t e x t   p a r t s

  set twdDomDoc [parseTwdFileDomDoc $TwdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  #set Title
  if {$twdTodayNode == ""} {
    set text1 "No Bible text found for today."
    
  } else {
    if {$enabletitle} {
      set twdTitle [getTwdTitle $twdTodayNode $TwdLang]
      
    }
    
  set parolNode1 [getTwdParolNode 1 $twdTodayNode]
  set parolNode2 [getTwdParolNode 2 $twdTodayNode]

  #set Introlines
  set intro1 [getParolIntro $parolNode $TwdLang 1]
  set intro2 [getParolIntro $parolNode $TwdLang 2]
  
  #set Texts
  set textNode1 [$TheWordNode selectNodes parolNode1/text]
  set textNode2 [$TheWordNode selectNodes parolNode2/text]

  #Search for <em> tags in text & mark text with _..._
  set emNodes [$textNode selectNodes em/text() ]
  if {$emNodes != ""} {
    foreach i $emNodes {
      set nodeText [$i nodeValue]
      $i nodeValue [join "< $nodeText >" {}]
    }
  }

  #Give out entire text
  ##must be called with '$textNode asText' to include <em>'s
  set text1 [$textNode1 asText]
  set text2 [$textNode2 asText]
  
  set text1 [getParolText $parolNode $TwdLang 1]
  set text2 [getParolText $parolNode $TwdLang 2]
  
  #set Refs
  set ref1 [getParolRef $parolNode $TwdLang 1]
  set ref2 [getParolRef $parolNode $TwdLang 2]
  
    

  #2. S t a r t   S e l e c t i v e   P r i n t i n g   
  
  set textLines [split $text \n]

  foreach line $textLines {
    set y [writeTextLine $line $x $y $img]
  }
  
  #z hüuf - wa passiert mit em y????????????
  
  writeTextline $title
  
  #set Intros + Refs to Italic <>
  if {$intro1 != ""} {
    writeTextline "$ind <$intro1>" $x $y $img
  }
  writeTextline "$ind $text1" $x $y $img
  writeTextline "$tab <$ref1>" $x $y $img

  if {$intro2 != ""} {
    writeTextline "$ind <$intro2>" $x $y $img
  }

  writeTextline "$ind $text2" $x $y $img
  writeTextline "$tab <$ref2>" $x $y $img
  
  
  

#move to writeTextline (if RTL), Übergabe per arg. RTL=1/0 !!! - nei s'isch schon döt - kei übergob nötig, (if TwdLang ...) ! :-)
#  if {$RtL} {
#  
#    source $BdfBidi
#    set text [bidi $text $TwdLang]
#  }
  
  return $y
  
} ;#END prepareText


set mark #ff0000
set x $marginleft
#if {$RtL} {
#  set imgW [image width $img]
#  set x [expr $imgW - $marginleft]
#}
set y $margintop
set color [set fontcolortext]

#TEST : below proc not necessary if twdText available
proc getTwdTextParts {} { 
  set intro1 [getParolIntro $parolNode $TwdLang 1]
  set intro2 [getParolIntro $parolNode $TwdLang 2]
  if {$intro != ""} {
    addTextLineToTextImg $intro $textImg $RtL $indent
  }
  
  set text1 [getParolText $parolNode $TwdLang 1]
  set text2 [getParolText $parolNode $TwdLang 2]
  set textLines [split $text \n]
  
  foreach line $textLines {
    addTextLineToTextImg $line $textImg $RtL $indent
  }
  
  set ref1 [getParolRef $parolNode $TwdLang 1]
  set ref2 [getParolRef $parolNode $TwdLang 2]
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
