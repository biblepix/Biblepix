# ~/Biblepix/prog/src/pic/BdfTools.tcl
#T E S T P H A S E 
#Updated 19apr18

#####################################################################
# FONTBOUNDINGBOX = Gesamtgrösse/Maximalgrösse eines Zeichens 
# Breite | Höhe | Abstand von links | Abstand von unten (Nulllinie)

# BBOX = Position des Zeichens in der Font Boundingbox
# Breite | Höhe | Abstand von links | Abstand von unten

#####################################################################


# printTwd
##toplevel printing proc
proc printTwd {TwdFileName img} {
  global marginleft margintop

  parseTwdTextParts $TwdFileName
  set finalImg [printTwdTextParts $marginleft $margintop $img]
  
  return $finalImg
}


# parseTwdTextParts
## prepares Twd nodes for processing
##called by printTwd
proc parseTwdTextParts {TwdFileName} {

  global RtL TwdLang sharedir enabletitle
  puts $TwdFileName
  
  set TwdLang [getTwdLang $TwdFileName]

  #A: Set Twd Node names
  
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
#puts $refNode1

  set refNode2 [$parolNode2 selectNodes ref]
#puts $refNode2    

  set textNode1 [$parolNode1 selectNodes text]
  set textNode2 [$parolNode2 selectNodes text]

  #B: Extract Text Parts

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

  ##texts with any <em> tags
  lappend emNodes "[$textNode1 selectNodes em/text()]" "[$textNode2 selectNodes em/text()]"
  
puts $emNodes
  
  if [regexp {[:graph:]} $emNodes] {
    foreach i $emNodes {
      set nodeText [$i nodeValue]
#      catch {$i nodeValue [join "< $nodeText >" {}]}
      catch {$i nodeValue \<$nodeText\> {} }
    }
  }

  ##extract including any tagged texts
  set ::text1 [$textNode1 asText]
  set ::text2 [$textNode2 asText]
  
    
} ;#END proc extractTwdTextParts
  
  
# printTwdTextParts  
##called by printTwd
proc printTwdTextParts {x y img} {
  global enabletitle 
  global title intro1 intro2 text1 text2 ref1 ref2 ind tab RtL
  
  #Set indentation - TODO. IS THERE A BETTER WAY OF PASSING THIS ON TO printLetter????? (change offset rather than printing spaces!)
  if {$RtL} {
    set ind ""
    set tab ""
  }
  
  ############## begin PRINTING ###############################
  ## supply "tab" or "ind" as supplementary last argument for printTextLine
  
  # 1. Print Title
  if {$enabletitle} {
    set y [printTextLine $title $x $y $img]
  }
  
  #Print intro1 in Italics
  if [info exists intro1] {
    set y [printTextLine \<$intro1\> $x $y $img $ind]
  }
  
  #Print text1
  set textLines [split $text1 \n]
  foreach line $textLines {
    set y [printTextLine $line $x $y $img $ind]
  }
  
  #Print ref1
  set y [printTextLine <$ref1> $x $y $img $tab]

  #Print intro2 in Italics
  if [info exists intro2] {
    set y [printTextLine \<$intro2\> $x $y $img $ind]
  }
  
  #Print text2
  set textLines [split $text2 \n]
  foreach line $textLines {
    set y [printTextLine $line $x $y $img $ind]
  }

  #Print ref2
  set y [printTextLine \<$ref2\> $x $y $img $tab]

  ########## END printing #################################

  #TODO: old image is returned!!!!!!!!!!¨¨¨
  return $img
  
} ;#END printTwdTextParts


# printLetter
##prints single letter to $img
##called by printTextLine
proc printLetter {letterName img x y} {
  global sun shade color mark FBBx RtL

  upvar $letterName curLetter
      
  set BBxoff $curLetter(BBxoff)
  set BBx $curLetter(BBx)
  
  #TODO: this dosn't work for Italic font!
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


# printTextLine - prints 1 line of text to $img
## Called by printTwd
# calls printLetter
## use args for right tab in ref line if RtL
proc printTextLine {textLine x y img args} {
  global mark TwdLang marginleft RtL tab ind BdfBidi FontAsc FBBy
  
  set xBase $x
  set yBase [expr $y + $FontAsc]
  
  #Compute xBase for RtL    
  if {$RtL} {
    source $BdfBidi
    set imgW [image width $img]
    set textLine [bidi $textLine $TwdLang]
    set operand +
    
#TODO: THIS IS NOT CLEAR BUT WORKS....
    set xBase [expr $imgW - ($marginleft*2) - $x]
    
  } else {
    set operand -
  }
  
  #Compute indentations
  if {$args=="ind"} {
      set x [expr $x $operand $ind]
    } elseif {$args=="tab"} {
      set x [expr $x $operand $tab]
  }
  
  
# T O D O: setzt Kodierung nach Systemkodierung? -finger weg! -TODO: GEHT NICHT AUF LINUX!!!- TODO
#  set textLine [encoding convertfrom utf-8 $textLine] - sollte man "source fontFile -encoding utf8" versuchen?

  set letterList [split $textLine {}]
  set weight R
  
  foreach letter $letterList {

    #set fontweight: < for I / > for R
    #set weight R
    
    if {$letter == "<"} {
      set weight I
  puts $weight
      continue
      } elseif {$letter == ">"} {
      set weight R
  puts $weight
      continue
    }

    set encLetter [scan $letter %c]
    
    
    #global weight
#    upvar 3 $weight::print_$encLetter print_$encLetter

    set print_${encLetter} ${weight}::print_${encLetter} 
    
puts ${weight}::print_${encLetter} 
    
    if {[info exists ${weight}::print_${encLetter}]} {
      array set curLetter [array get ${weight}::print_${encLetter}]
      
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
#set logfile [open /tmp/logfile.tcl w]

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

