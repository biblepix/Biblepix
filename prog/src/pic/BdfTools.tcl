# ~/Biblepix/prog/src/pic/BdfTools.tcl
#T E S T P H A S E 
#Updated 19apr18

#####################################################################
# FONTBOUNDINGBOX = Gesamtgrösse/Maximalgrösse eines Zeichens 
# Breite | Höhe | Abstand von links | Abstand von unten (Nulllinie)

# BBOX = Position des Zeichens in der Font Boundingbox
# Breite | Höhe | Abstand von links | Abstand von unten

#####################################################################


#TODO: write proc that comprises the below procs & finishes the actual image
#already have it - it's printText!!!
proc printTwdToImg {?TwdFileName ?img} {
    
  extractTwdTextParts
  processTwdTextParts
  
  return $img
}


#extractTwdTextParts
## prepares Twd nodes for processing
## calls processTwdTextParts
## TODO: compare command with processTwdTextParts & FINALILIZE !!!
proc extractTwdTextParts {} { 
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

# processTwdTextParts
## called by BdfPrint main process
## calls printTextLine per line
proc processTwdTextParts {text x y img } {

  global RtL Bidi TwdFileName TwdLang sharedir
  
  # 1. P r e p a r e   t e x t   p a r t s

#move to TwdTools? -aready in setTodaysTwdNodes!!!
  set twdDomDoc [parseTwdFileDomDoc $TwdFileName]
  set twdTodayNode [getDomNodeForToday $twdDomDoc]
  
  #set Title
  if {$twdTodayNode == ""} {
    set text1 "No Bible text found for today."
    
  } else {
    if {$enabletitle} {
      set twdTitle [getTwdTitle $twdTodayNode $TwdLang]
  }


#SEE SEparate proc above!!!    
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
    set y [printTextline $line $x $y $img]
  }

  set y [printTextline $title ...]
  
  #set Intros + Refs to Italic <>
  if {$intro1 != ""} {
    set y [printTextline "$ind <$intro1>" $x $y $img]
  }

printTextline "$ind $text1" $x $y $img

  #MAKE tab available as arg for RtL!!!
  set Ref1 "$tab <$ref1>"
	set Tab ""
  if {$RtL} {
		set Ref1 <$ref1>
		set Tab "RightTab"
	}
  
  set y [printTextline $Ref1 $x $y $img $Tab]

  if {$intro2 != ""} {
    printTextline "$ind <$intro2>" $x $y $img
  }

  printTextline "$ind $text2" $x $y $img
  printTextline "$tab <$ref2>" $x $y $img
  
  return $y
  
} ;#END processTwdTextParts


# printLetter - prints single letter to $img
## called by printTexTLine
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


# printTextLine - prints 1 line of text to $img
## Called by writeText
## use args for right tab in ref line if RtL
proc printTextLine {textLine x y img args} {
	
  global mark print_32??? TwdLang marginleft Bidi RtL tab
  
  upvar 2 FontAsc fontAsc
  upvar 2 FBBy FBBy
  set xBase $x
  set yBase [expr $y + $fontAsc]
      
  if {$RtL} {
    set imgW [image width $img]
    set textLine [bidiBdf $textLine $TwdLang]
    set xBase [expr $imgW - ($marginleft*2) - $x]
		if {$args=="RightTab"} {
			set xBase [expr $xBase - $tab]
		}
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

