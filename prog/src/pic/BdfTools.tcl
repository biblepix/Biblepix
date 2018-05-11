# ~/Biblepix/prog/src/com/BdfToolss.tcl
# BDF scanning and printing tools
# sourced by BdfPrint
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 11may18


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
  if ![catch {$introNode1 text} res] {
    set ::intro1 $res
  }
  if ![catch {$introNode2 text} res] {
    set ::intro2 $res
  }
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

} ;#END proc extractTwdTextParts
  
  
# printTwdTextParts  
## called by printTwd
proc printTwdTextParts {x y img} {
  global enabletitle title intro1 intro2 text1 text2 ref1 ref2 TwdLang
  
  #Sort out markings for Italic & Bold
  if {$TwdLang == "th" || $TwdLang == "zh" } {
    set mark1 ""
    set mark2 ""
    set mark3 ""
    } else {
    set mark1 £
    set mark2 <
    set mark3 >
    }

  # 1. Print Title in Bold £...>
  if {$enabletitle} {
    set y [printTextLine $mark1$title$mark3 $x $y $img]
  }
  
  #Print intro1 in Italics <...>
  if [info exists intro1] {
    set y [printTextLine <$intro1> $x $y $img IND]
  }
  
  #Print text1
  set textLines [split $text1 \n]
  foreach line $textLines {
    set y [printTextLine $line $x $y $img IND]
  }
  
  #Print ref1 in Italics
  set y [printTextLine $mark2$ref1$mark3 $x $y $img TAB]

  #Print intro2 in Italics
  if [info exists intro2] {
    set y [printTextLine $mark2$intro2$mark3 $x $y $img IND]
  }
  
  #Print text2
  set textLines [split $text2 \n]
  foreach line $textLines {
    set y [printTextLine $line $x $y $img IND]
  }

  #Print ref2
  set y [printTextLine $mark2$ref2$mark3 $x $y $img TAB]

  return $img
  
} ;#END printTwdTextParts


# printLetter
## prints single letter to $img
## called by printTextLine
proc printLetter {letterName img x y} {
  global sun shade color mark RtL weight FBBx
  upvar $letterName curLetter
      
  set BBxoff $curLetter(BBxoff)
  set BBx $curLetter(BBx)
  
  #TODO: JOEL, this dosn't work for Italic font!
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
# #alls printLetter
## use 'args' for TAB or IND
proc printTextLine {textLine x y img args} {
  global mark TwdLang marginleft enabletitle RtL BdfBidi FontAsc FBBy
 
  #Set tab & ind in pixels - TODO: move to Globals?
  set tab 400
  set ind 0
  if {$enabletitle} {set ind 20}
  
  set xBase $x
  set yBase [expr $y + $FontAsc]
  
  #Compute xBase for RtL    
  if {$RtL} {
    source $BdfBidi
    set imgW [image width $img]
    set textLine [bidi $textLine $TwdLang]
    set operator -
    
#TODO: THIS IS NOT CLEAR BUT WORKS....(why marginleft*2 ???)
    set xBase [expr $imgW - ($marginleft*2) - $x]
    
    
  } else {
    set operator +
  }
  
  #Compute indentations
  if {$args=="IND"} {
      #set x [expr $x $operator $ind]
      set xBase [expr $xBase $operator $ind]
    } elseif {$args=="TAB"} {
      set xBase [expr $xBase $operator $tab]
  }
  
  
# T O D O: setzt Kodierung nach Systemkodierung? - GEHT NICHT AUF LINUX!!!- 
# jetzt durch "source -encoding utf8" ersetzt in BdfPrint - JOEL BITTE TESTEN!

  set letterList [split $textLine {}]
  set weight R
  
  foreach letter $letterList {

    #Reset fontweight of next letters: < for I / > for R
    if {$letter == "<"} {
      set weight I
  puts $weight
      continue
      } elseif {$letter == ">"} {
      set weight R
  puts $weight
      continue
    } elseif {$letter == "£"} {
      set weight B
      continue
    }

    set encLetter [scan $letter %c]
    set print_${encLetter} ${weight}::print_${encLetter} 
    
#puts ${weight}::print_${encLetter} 
    
    if {[info exists ${weight}::print_${encLetter}]} {
      array set curLetter [array get ${weight}::print_${encLetter}]

    } else {
      #Print empty space if letter not found in R:: or B:: 
      catch {array get R::print_${encLetter}} res
      catch {array get B::print_${encLetter}} res
      if {$res != ""} {
        array set curLetter $res
        } else {
        array set curLetter [array get "R::print_32"]
      }
    }

    printLetter curLetter $img $xBase $yBase
   
   set ::weight $weight 
#    upvar 2 weight $weight
           
    #sort out Bidi languages
    if {$RtL} {
      set xBase [expr $xBase - $curLetter(DWx)]
      } else {
      set xBase [expr $xBase + $curLetter(DWx)]
    }
    
  } ;#END foreach
  
  #gibt letzte Y-Position an aufrufendes Programm ab
  return [expr $y + $FBBy]

} ;#END printTextLine



#############################################################################
################### extra procs for rare use ################################


# BDF file with path
proc scanBdf {BdfFilePath} {
  global heute fontdir

  set BdfFile [file tail $BdfFilePath]
  
  #Set up files and channels  
  set BdfFontChan [open $BdfFilePath]
  set BdfText [read $BdfFontChan]
  close $BdfFontChan

  # A) SCAN BDF FOR GENERAL INFORMATION 
  
  if {[regexp -line {(^FONT )(.*$)} $BdfText -> name value]} {
    set FontSpec $value
  } else {
    set FontSpec "Undefined"
  }
  
  if {[regexp -line {(^SIZE )(.*$)} $BdfText -> name value]} {
    set FontSize $value
  } else {
    set FontSize "Undefined"
  }
  
  if {[regexp -line {(^FAMILY_NAME )(.*$)} $BdfText -> name value]} {
    set FontName $value
  } else {
    set FontName "Undefined"
  }
  
  if {[regexp -line {(^WEIGHT_NAME )(.*$)} $BdfText -> name value]} {
    set FontWeight $value
  } else {
    set FontWeight "Undefined"
  }

  ##get character width, height and offsets
  regexp -line {^FONTBOUNDINGBOX .*$} $BdfText FBBList
  if {[regexp -line {(^FONT_ASCENT )(.*$)} $BdfText -> name value]} {
    set FontAsc $value
  } else {
    set FontAsc "Undefined"
  }
  
  ##get number of characters  - JOEL WOZU DAS?
  if {[regexp -line {(^CHARS )(.*$)} $BdfText -> name value]} {
    set numChars $value
  } else {
    set numChars "Undefined"
  }
  
  #copyright info
  if {[regexp -line {(^COPYRIGHT )(.*$)} $BdfText -> name value]} {
    set copyright $value
  } else {
    set copyright "Undefined"
  }
  
  #Slant (R/B/I/BI)
  if {[regexp -line {(^SLANT )(.*$)} $BdfText -> name value]} {
    set slant $value
  } else {
    set slant "Undefined"
  }

  #Trying to get sensible name for font file
  foreach i $FontName {append noSpaceFontName $i} 
  append TclFontFile $noSpaceFontName _ $FontWeight _ $slant _ [string range $FontSize 0 1] .tcl
  set TclFontChan [open $fontdir/$TclFontFile w]
  
  # Save general information to TclFontFile
  puts $TclFontChan "\# $fontdir\/$TclFontFile
\# BiblePix font extracted from $BdfFile
\# Font Name: $FontName
\# Font size: $FontSize
\# Font Specification: $FontSpec
\# Copyright: $copyright
\# Created: [clock format [clock seconds] -format "%d-%m-%Y"]

\# FONTBOUNDINGBOX INFO
set FBBx [lindex $FBBList 1]
set FBBy [lindex $FBBList 2]
set FBBxoff [lindex $FBBList 3]
set FBByoff [lindex $FBBList 4]
set FontAsc $FontAsc
set numChars $numChars
"
    
  # B) SCAN BDF FOR SINGLE CHARACTERS

  set indexEndChar 0

  for {set charNo 0} {$charNo < $numChars} {incr charNo} {
    
    #Set next character indices
    set indexBegChar [string first {STARTCHAR} $BdfText $indexEndChar]
    set indexEndChar [expr [string first ENDCHAR $BdfText $indexBegChar] +7]
    
    set charText [string range $BdfText $indexBegChar $indexEndChar]

    # 1. Extract necessary information
    
    ##set Codename (to be used for character name)
    regexp -line {^ENCODING .*$} $charText encList
    set enc [lindex $encList 1]
        
    ##set BBX (for typesetting proc)
    regexp -line {^BBX .*$} $charText BBXList
    
    ##set DW
    regexp -line {^DWIDTH .*$} $charText DWList
        
    ##create BITMAP list 
    set indexBegBMP [expr [string first BITMAP $charText] +6]
    set indexEndBMP [expr [string first ENDCHAR $charText] -1]
    set BMPList [string range $charText $indexBegBMP $indexEndBMP]
    
    #Convert bitmap list to binary
    set binList ""
    foreach line $BMPList {
      lappend binList [hex2bin $line]
    }
    
    #Colour + format binary bitmap list
    set binList [colourBinlist $binList $BBXList]
    
    # 2. Create character array & append to TclFontFile
    puts $TclFontChan "array set print_$enc \{ 
  BBx [expr [lindex $BBXList 1] + 2]
  BBy [expr [lindex $BBXList 2] + 2]
  BBxoff [expr [lindex $BBXList 3] - 1]
  BByoff [expr [lindex $BBXList 4] - 1]
  DWx [expr [lindex $DWList 1] + 2]
  DWy [lindex $DWList 2]
  BITMAP \{ $binList \}
\}
"
  } ;#END LOOP

  close $TclFontChan
  puts "Font successfully parsed to $fontdir/$TclFontFile"

} ;#END scanBdf  

proc hex2bin {hex} {
  binary scan [binary format H* $hex] B* bin
  return $bin
}

proc calcColorLine {sunLine charLine shadeLine BBx} {
  set sunLine1 [string cat $sunLine "00"]
  set sunLine2 [string cat "0" $sunLine "0"]
  set charLine [string cat "0" $charLine "0"]
  set shadeLine1 [string cat "00" $shadeLine]
  set shadeLine2 [string cat "0" $shadeLine "0"]
  
  set colourLine ""
  
  for {set index 0} {$index < [expr $BBx + 2]} {incr index} {
    if {[string index $charLine $index] == "1"} {
      set colourLine [string cat $colourLine "1"]
    } elseif {[string index $sunLine1 $index] == "1"} {
      set colourLine [string cat $colourLine "2"]
    } elseif {[string index $shadeLine1 $index] == "1"} {
      set colourLine [string cat $colourLine "3"]
    } elseif {[string index $sunLine2 $index] == "1"} {
      set colourLine [string cat $colourLine "2"]
    } elseif {[string index $shadeLine2 $index] == "1"} {
      set colourLine [string cat $colourLine "3"]
    } else {
      set colourLine [string cat $colourLine "0"]
    }
  }
  
  return $colourLine
}

# S c h e m a   bei Sonne von links oben:
#   S
#  SS#
# SS###
#  #####
#   ###ss
#    #ss
#     s
       
# Colour a single bitmap character
proc colourBinlist {binList BBXList} {
  set colourList ""
  
  set BBx [lindex $BBXList 1]
  
  set sunLine [string repeat "0" $BBx]
  set charLine [string repeat "0" $BBx]
  
  foreach line $binList {
    set shadeLine $charLine
    set charLine $sunLine
    set sunLine $line
    
    lappend colourList [calcColorLine $sunLine $charLine $shadeLine $BBx]
  }
  
  for {set i 0} {$i < 2} {incr i} {
    set shadeLine $charLine
    set charLine $sunLine
    set sunLine [string repeat "0" $BBx]
    
    lappend colourList [calcColorLine $sunLine $charLine $shadeLine $BBx]
  }
  
  return $colourList
}