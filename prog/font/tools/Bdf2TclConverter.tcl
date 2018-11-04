# ~/Biblepix/prog/src/com/Bdf2TclConverter.tcl
# Tools to provide new fonts for BiblePix BDF version
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 14jun18

################ To convert TTF fonts follow these steps: ##################
# 1. convert TTF to OTF online (https://everythingfonts.com/ttf-to-otf)
# 2. run otf2bdf (found on Linux)
# 3. run ConvertBdf2Tcl
############################################################################

# BDF file with path
proc ConvertBdf2Tcl {BdfFilePath} {
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