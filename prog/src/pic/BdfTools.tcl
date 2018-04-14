# ~/Biblepix/prog/src/pic/BdfTools.tcl
#T E S T P H A S E 
#Updated 5apr18

#####################################################################
# FONTBOUNDINGBOX = Gesamtgrösse/Maximalgrösse eines Zeichens 
# Breite | Höhe | Abstand von links | Abstand von unten (Nulllinie)

# BBOX = Position des Zeichens in der Font Boundingbox
# Breite | Höhe | Abstand von links | Abstand von unten

#####################################################################

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

## test ##
#scanBdf timR24.bdf
#scanBdf timB24.bdf
#scanBdf timBI24.bdf


#### R E S E R V E #############################################################

#Zeichengrösse multiplizieren oder verkleinern - NOT NEEDED :-)
proc resizeBdfChar {binlist} {
  #1. in Breite: jedes Zeichen verdoppeln
  foreach pix [split $binlist {}] {
    append doubleSpaceBinlist [string repeat $pix 2]
  }

  #2. Add sun and shade pixels here
  set doubleSpaceBinlist [addSunAndShade]
  
  
#### bis hier gehts - $doubleSpaceBinlist is proper list!


  #3. in Höhe: jede Zeile verdoppeln
  foreach line $doubleSpaceBinlist {
    lappend doubledBinlist $line
    lappend doubledBinlist $line
  }

#TODO - keine Liste mehr!
puts $doubledBinlist
return

  #c) Add sun line before first sunny line (symbol=2) -TODO: eliminate 0000 lines!
  ##find first line with 2
  for {set index 0} {$index<=[llength $doubleSpaceBinlist]} {incr index} {
    if {[regexp 2 [lindex $doubleSpaceBinlist $index]]} {
      return $index}
    }
  ##insert new line (hardly first!) - TODO don't add line (s.u.)
  #set newList [linsert $double??List $index $sunline]
  
  set sunLine [lindex $doubledBinlist $index]
  ##1 nach links versetzen
  set sunLine [string replace $firstLine 0 0 {}]
  set sunLine [string replace $firstLine end end {00}]
  set newSunline [string map {1 2} $firstLine]  
  
  ##add line at top - TODO NO!
  set doubledBinlist [lappend doubledBinlist $newFirstline $doubledBinlist]
##### TODO: REPLACE SUN-LINE WITH 1 LINE PREVIOUS TO INDEXED LINE !!!




  #d) Add shade line at bottom - TODO : no! S.O.
  set lastLine [lindex $doubledBinlist end]
  set newLastline [string map {1 3} $lastLine]
  ##1 nach rechts versetzen
  string replace $newLastline 0 0 {00}
  string replace $newLastline end end {}
  ##add line at end
  lappend doubledBinlist $newLastline

}; #END double



# P r e p a r e   p r i n t   p r o c

proc printChar {bitmap image} {
#Zeilenweise Pixelpositionen in Listen speichern
  set 1 black
  set 2 yellow
  set 3 grey
  
  set zeilenmenge [llength $bitmap]
  set linelength [llength $pixlist]
  set linelength [llength [split 
  
  #TODO: Joel das funktioniert nicht, weiss nicht warum
  #wichtig für dich: du kannst mit [set 1] z.B. einen Variablentausch vornehmen
  for {set x 0} {$x<[llength [lindex  $bitmap} {incr x} {
  
    for {set y 0} {$y<$zeilenmenge} {incr y} {
      set zeile 
      set pixlist [split $zeile {}]      
      if {[set pix]!=0} {
        $image put [set $pix] -to $x $y
      }
    }
  }

  
} ;#END PROC
