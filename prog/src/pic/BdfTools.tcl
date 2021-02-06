# ~/Biblepix/prog/src/com/BdfTools.tcl
# BDF printing tools
# sourced by BdfPrint
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 6feb21 pv

# printTwd
##Toplevel printing proc
##called by BdfPrint
proc printTwd {TwdFileName img} {
  global colour::marginleft
  global colour::margintop
  parseTwdTextParts $TwdFileName
  
  ##TODO könnte man hier die Zeilenlänge für bidi berechnen????
  set finalImg [printTwdTextParts $marginleft $margintop $img]
  namespace delete twd
  return $finalImg
}

# parseTwdTextParts
## prepares Twd nodes in a separate namespace for further processing
## called by printTwd
proc parseTwdTextParts {TwdFileName} {
  
  namespace eval twd {
    ##initate vars later needed by catchMarginErrors
    variable xBase
    variable YBase    
    variable xErr
    variable yErr
    
    set screenW [winfo screenwidth .]
    set screenH [winfo screenheight .]
    
    ##initiate current vars    
    variable TwdFileName $::TwdFileName
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
  } ;#END twd:: namespace

} ;#END proc parseTwdTextParts
  

# evalMarginErrors
##evaluates lists created by checkMarginErrors
##called by printTwdTextParts  
proc evalMarginErrors {} {
  
  checkMarginErrors
  
  eval namespace twd {
    
    #A) Return 0 0 if none found
    if [info exists xErrL] {
      set L [join $xErrL ,]
      set xErr [expr max($L)]
  
    } elseif [info exists yErrL] {
      set L [join $yErrL ,]
      set yErr [expr max($L)]
    } else {
    
      return "0 0"
    }
  
    #B) Compute new x & y
    variable x
    variable y
  
    ##to far left(-) OR right(+) 
    if [info exists xErr] {
        
        set y 0
        
      if {$xErr < 0} {
      
        set x [expr $x + ($xErr * -1)]     
      } else {
      
        set x [expr $x - ($xErr - $screenW)]
      }
         
    ##too far below(+)
    } elseif [info exists yErr] {
      
      set x 0
      set y [expr $y - ($yErr - $screenH)] 
    }
  
  } ;#END twd:: namespace
  
  return "$twd::x $twd::y"
}
  
# printTwdTextParts  
## called by printTwd
proc printTwdTextParts {x y img} {
  global enabletitle TwdLang
  global colour::marginleft colour::margintop
  global twd::xErr twd::yErr
  set screenW [winfo screenwidth .]
  set screenH [winfo screenheight .]

  #1) CORRECT ANY MARGIN ERRORS
  lassign [evalMarginErrors] newX newY
  ##accept if values not 0
  if {$newX} {
    set x $newX
    }
  if {$newY} {
    set y $newY
  }
  
  #2) SORT OUT markrefs for Italic & Bold
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

  #3) START PRINTING
  
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

  set imgW [image width $img]
  set imgH [image height $img]

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
         
      #A) Truncate text (break loop) if it exceeds image width or height
      if {$xCur >= $imgW || $yCur >= $imgH} {break}
      #B) else put colour pixel
      if {$xCur <0} {set xCur 1} 
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

#TODO try to avoid this and calculate maxline length instead!
    #Move text to the right only if png info not found
    ##make space on the left if leftmargin near border
    if ![info exists colour::pngInfo] {
      set screenwidth [winfo screenwidth .]
      set minmargin [expr $screenwidth/3]
      if {$marginleft < $minmargin} {
        set marginleft $minmargin
      }
      set xBase [expr $imgW - ($marginleft) - $x]
    }
    
  } else {
    set operator +
  }
puts "marginleft $marginleft"



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

set yBase [expr $y + $${prefix}::FBBy]

#TODO kafam bozuldu - this is called by evalMarginErrors!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
catchMarginErrors $xBase $yBase
    
  #gibt neue Y-Position für nächste Zeile zurück  
  return $yBase

} ;#END printTextLine


# catchMarginErrors
##records any extra widths/heights for later correction 
##called by printTextLine for each line
proc catchMarginErrors {xBase yBase} {
  
  set twd::xBase $xBase
  set twd::yBase $yBase
  
  #make lists to be parsed later by evalMarginErrors
  namespace eval twd {
    ##extra width left
    if {$xBase < 0} {
      lappend xErrL $xBase  
    ##extra width right
    } elseif {$xBase > $screenW} {
      lappend xErrL $xBase
    ##extra height bottom
    } elseif {$yBase > $screenH} {
      lappend yErrL $yBase  
    }
    
catch {    puts "Extra height: $extraH"}
catch {    puts "Extra width: $extraW"}
  }
}
