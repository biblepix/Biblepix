# ~/Biblepix/prog/src/com/BdfTools.tcl
# BDF scanning and printing tools
# sourced by BdfPrint
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 19may18


# printTwd
## Toplevel printing proc
proc printTwd {TwdFileName img} {
  global marginleft margintop

  parseTwdTextParts $TwdFileName
  set finalImg [printTwdTextParts $marginleft $margintop $img]
  
  return $finalImg
}


# parseTwdTextParts
## prepares Twd nodes for processing
## called by printTwd
proc parseTwdTextParts {TwdFileName} {

  set TwdLang [getTwdLang $TwdFileName]

  #A: SET TWD NODE NAMES
  
  set domDoc [parseTwdFileDomDoc $TwdFileName]
  set todaysTwdNode [getDomNodeForToday $domDoc]
  set parolNode1 [$todaysTwdNode child 2]
  set parolNode2 [$todaysTwdNode lastChild]
  
  if {$todaysTwdNode == ""} {
    source $SetupTexts
    set text1 $noTwdFilesFound
    
  } else {
    
    set titleNode [$todaysTwdNode selectNodes title]
    
  }
  
  set introNode1 [$parolNode1 selectNodes intro]
  set introNode2 [$parolNode2 selectNodes intro]
  
  set refNode1 [$parolNode1 selectNodes ref]
  set refNode2 [$parolNode2 selectNodes ref]

  set textNode1 [$parolNode1 selectNodes text]
  set textNode2 [$parolNode2 selectNodes text]

  # B: EXTRACT TWD TEXT PARTS

  ##title
  set ::title [$titleNode text]
  ##intros
  if {![catch {$introNode1 text} res]} {
    set ::intro1 $res
  }
  if {![catch {$introNode2 text} res]} {
    set ::intro2 $res
  }
  #$introNode1 delete
  #$introNode2 delete
  
  ##refs
  set ::ref1 [$refNode1 text]
  set ::ref2 [$refNode2 text]

  # Detect texts with <em> tags & mark as Italic
  foreach node "[split [$textNode1 selectNodes em/text()]] [split [$textNode2 selectNodes em/text()]]" {
    set nodeText [$node nodeValue]
    if {$nodeText != ""} {
      $node nodeValue \<$nodeText\>
    }
  }
  ##extract text including any tagged
  set ::text1 [$textNode1 asText]
  set ::text2 [$textNode2 asText]

  #Clean up all nodes
 # $domDoc delete
} ;#END proc extractTwdTextParts
  
  
# printTwdTextParts  
## called by printTwd
proc printTwdTextParts {x y img} {
  global enabletitle title intro1 intro2 text1 text2 ref1 ref2 TwdLang
  
  #Sort out markings for Italic & Bold
  if {$TwdLang == "th" || $TwdLang == "zh" } {
    set markB ""
    set markI ""
    set markR ""
    } else {
    set markB +
    set markI <
    set markR ~
    }

  # 1. Print Title in Bold +...~
  if {$enabletitle} {
    set y [printTextLine ${markB}${title}${markR} $x $y $img]
  }
  
  #Print intro1 in Italics <...~
  if [info exists intro1] {
    set y [printTextLine ${markI}${intro1}${markR} $x $y $img IND]
  }
  
  #Print text1
  set textLines [split $text1 \n]
  foreach line $textLines {
    set y [printTextLine $line $x $y $img IND]
  }
  
  #Print ref1 in Italics
  set y [printTextLine ${markI}${ref1}${markR} $x $y $img TAB]

  #Print intro2 in Italics
  if [info exists intro2] {
    set y [printTextLine ${markI}${intro2}${markR} $x $y $img IND]
  }
  
  #Print text2
  set textLines [split $text2 \n]
  foreach line $textLines {
    set y [printTextLine $line $x $y $img IND]
  }

  #Print ref2
  set y [printTextLine ${markI}${ref2}${markR} $x $y $img TAB]

  return $img
  
} ;#END printTwdTextParts


# printLetter
## prints single letter to $img
## called by printTextLine
proc printLetter {letterName img x y} {
  global sun shade fontcolortext RtL weight prefix BBxoff
  upvar $letterName curLetter
  
  set color [set fontcolortext]
  set BBxoff $curLetter(BBxoff)
  set BBx $curLetter(BBx)
  
  # T O D O : JOEL, this doesn't work for Italic Hebrew!!!
  if {$RtL} {
    set FBBx "$${prefix}::FBBx"
    #puts $FBBx
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
        }
        
      if { $xCur <0 } {set xCur 1 } 
        $img put $pxColor -to $xCur $yCur
      }
      incr xCur
    }
    incr yCur
  }
  
} ;#END printLetter


# printTextLine - prints 1 line of text to $img
## Called by printTwd
## calls printLetter
## use 'args' for TAB or IND
proc printTextLine {textLine x y img args} {
  global TwdLang fontName marginleft margintop enabletitle RtL BdfBidi prefix
   
  set FontAsc "$${prefix}::FontAsc"
  
  #Set tab & ind in pixels - TODO: move to Globals?
  set tab 400
  set ind 0
  if {$enabletitle} {set ind 20}
  
  set xBase $x
  if [catch {set yBase [expr $y + $FontAsc]}] {
    set yBase $y
  }
  
  #Compute xBase for RtL    
  if {$RtL} {
    source $BdfBidi
    set imgW [image width $img]
    set textLine [bidi $textLine $TwdLang]
    set operator -
    
# T O D O : THIS IS NOT CLEAR BUT WORKS....(why marginleft*2 ???) 
# JOEL, das geht nur wenn der Rand klein ist, sonst wird der Text doppelt verschoben!!!
    set xBase [expr $imgW - ($marginleft*2) - $x]
    
  } else {
    set operator +
  }
  
  #Compute indentations
  if {$args=="IND"} {
    set xBase [expr $xBase $operator $ind]
  } elseif {$args=="TAB"} {
    set xBase [expr $xBase $operator $tab]
  }
  
  
# T O D O ???: setzt Kodierung nach Systemkodierung? - GEHT NICHT AUF LINUX!!!- 
# jetzt durch "source -encoding utf-8" ersetzt in BdfPrint - JOEL BITTE TESTEN!

  set letterList [split $textLine {}]
  set weight R
  
  foreach letter $letterList {

    #Set new fontstyle if marked
    if {$letter == "<"} {
      set prefix I
      continue
    } elseif {$letter == "~"} {
      set prefix R
      continue
    } elseif {$letter == "+"} {
      set prefix B
      continue
    }

    set encLetter [scan $letter %c]

    if { [catch {upvar 3 ${prefix}::print_$encLetter print_$encLetter} error] } {
 #     puts $error
      continue
      
    } else {
      
      array set curLetter [array get print_$encLetter]
      catch {printLetter curLetter $img $xBase $yBase} error
 #     puts $error
    
      set xBase [expr $xBase $operator $curLetter(DWx)]
    }
  } ;#END foreach
  
  #gibt neue Y-Position für nächste Zeile zurück  
  return [expr $y + $${prefix}::FBBy]

} ;#END printTextLine