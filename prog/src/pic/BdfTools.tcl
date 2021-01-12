# ~/Biblepix/prog/src/com/BdfTools.tcl
# BDF printing tools
# sourced by BdfPrint
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 11jan21 pv

# printTwd
##Toplevel printing proc
##called by BdfPrint
proc printTwd {TwdFileName img} {
  global colour::marginleft
  global colour::margintop
  parseTwdTextParts $TwdFileName
  set finalImg [printTwdTextParts $marginleft $margintop $img]
  return $finalImg
}

# parseTwdTextParts
## prepares Twd nodes in a separate namespace for further processing
## called by printTwd
proc parseTwdTextParts {TwdFileName} {

  namespace eval twd {
    
    global TwdFileName
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
     
    ##Export text vars to twd:: namespace
    
    ##title
    set title [$titleNode text]
    ##intros
    if {![catch {$introNode1 text} res]} {
      set intro1 $res
    }
    if {![catch {$introNode2 text} res]} {
      set intro2 $res
    }
    
    ##refs
    set ref1 [$refNode1 text]
    set ref2 [$refNode2 text]

    # Detect texts with <em> tags & mark as Italic
    foreach node "[split [$textNode1 selectNodes em/text()]] [split [$textNode2 selectNodes em/text()]]" {
      set nodeText [$node nodeValue]
      if {$nodeText != ""} {
        $node nodeValue \<$nodeText\~
      }
    }
    ##extract text including any tagged
    set text1 [$textNode1 asText]
    set text2 [$textNode2 asText]

    #Clean up all nodes - TODO: nicht nötig? namespace wird sowieso gelöscht!
    $domDoc delete
    
  } ;#END twd:: namespace

} ;#END proc extractTwdTextParts
  
  
# printTwdTextParts  
## called by printTwd
proc printTwdTextParts {x y img} {
  global enabletitle TwdLang
  
  #Sort out markRefngs for Italic & Bold
  if {$TwdLang == "th" || $TwdLang == "zh" } {
    set markTitle ""
    set markRef ""
    set markText ""
  } elseif {[isArabicScript $TwdLang]} {
    #Arabic has no Italics!
    set markTitle +
    set markRef ~
    set markText ~
  } elseif {$::fontweight == "bold"} {
    set markTitle +
    set markRef <
    set markText +
  } else {
    set markTitle +
    set markRef <
    set markText ~
  }

  # 1. Print Title in Bold +...~
  if {$enabletitle} {
    set y [printTextLine ${markTitle}${twd::title} $x $y $img]
  }
  
  #Print intro1 in Italics <...~
  if [info exists twd::intro1] {
    set y [printTextLine ${markRef}${twd::intro1} $x $y $img IND]
  }
  
  #Print text1
  set textLines [split $twd::text1 \n]
  foreach line $textLines {
    set y [printTextLine ${markText}$line $x $y $img IND]
  }
  
  #Print ref1 in Italics
  set y [printTextLine ${markRef}${twd::ref1} $x $y $img TAB]

  #Print intro2 in Italics
  if [info exists twd::intro2] {
    set y [printTextLine ${markRef}${twd::intro2} $x $y $img IND]
  }
  
  #Print text2
  set textLines [split $twd::text2 \n]
  foreach line $textLines {
    set y [printTextLine ${markText}$line $x $y $img IND]
  }

  #Print ref2
  set y [printTextLine ${markRef}${twd::ref2}${markText} $x $y $img TAB]

  return $img
  
} ;#END printTwdTextParts


# printLetter
## prints single letter to $img
## called by printTextLine
proc printLetter {letterName img x y} {
  global colour::regHex 
  global colour::sunHex 
  global colour::shaHex 
  global RtL prefix
  upvar $letterName curLetter	

  set BBxoff $curLetter(BBxoff)
  set BBx $curLetter(BBx)

  if {$RtL} {
    set x [expr $x - $curLetter(DWx)]
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
          1 { set pxColor $regHex }
          2 { set pxColor $sunHex }
          3 { set pxColor $shaHex }
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
## calls printLetter
## use 'args' for TAB or IND
## Called by printTwd
proc printTextLine {textLine x y img args} {
  global TwdLang enabletitle RtL BdfBidi prefix
  global colour::marginleft
  global colour::sunHex colour::regHex colour::shaHex
  
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
    #Move text to right side only if png info not found 
    if ![info exists colour::pngInfo] { 
      set xBase [expr $imgW - ($marginleft) - $x]
    }
    
  } else {
    set operator +
  }
  
  #Compute indentations
  if {$args=="IND"} {
    set xBase [expr $xBase $operator $ind]
  } elseif {$args=="TAB"} {
    set xBase [expr $xBase $operator $tab]
  }

  set letterList [split $textLine {}]
  
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
      puts $error
      continue
      
    } else {
      
      array set curLetter [array get print_$encLetter]
      if [catch {printLetter curLetter $img $xBase $yBase} error] {
        puts "could not print letter: $encLetter"
        error $error
        continue
      }
      
      set xBase [expr $xBase $operator $curLetter(DWx)]
    }
  } ;#END foreach
  
  #gibt neue Y-Position für nächste Zeile zurück  
  return [expr $y + $${prefix}::FBBy]

} ;#END printTextLine
