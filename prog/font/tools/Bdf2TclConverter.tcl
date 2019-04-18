# ~/Biblepix/prog/src/com/Bdf2TclConverter.tcl
# Tools to provide new fonts for BiblePix BDF version
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 12Apr19

################ To convert TTF fonts follow these steps: ##################
# 1. convert TTF to OTF online (https://onlinefontconverter.com: click just OTF, then Select files...)
# 2. run otf2bdf (found on Linux)
# 3. run ConvertBdf2Tcl
############################################################################

set fontToolsDir [file dirname [file normalize [info script]]]

# BDF file with path
proc ConvertBdf2Tcl {BdfFilePath fontDir} {
  global fontToolsDir

  # read BdfText
  set BdfFontChan [open $BdfFilePath]
  set BdfText [read $BdfFontChan]
  close $BdfFontChan

  # get tcl file name
  set BdfFile [file tail $BdfFilePath]
  set TclFontFileName [string cat [file rootname $BdfFile] ".tcl"]
  set TclFontFile [file join $fontDir $TclFontFileName]

  # scan bdf for general information
  writeGeneralInformation $BdfText $BdfFile $TclFontFile

  # scan bdf for single characters
  convertCharacters $BdfText $TclFontFile

  # fix Arabic shadows
 
  set ArabicShadowTool [file join $fontToolsDir ArabicShadowTool.tcl]
  source $ArabicShadowTool
  fixArabicShadows $TclFontFile

  puts "Font successfully parsed to $TclFontFile"
}

proc writeGeneralInformation {BdfText BdfFile TclFontFile} {
  if {![regexp -line {(^FAMILY_NAME )(.*$)} $BdfText -> name FontName]} {
    set FontName "Undefined"
  }

  if {![regexp -line {(^SIZE )(.*$)} $BdfText -> name FontSize]} {
    set FontSize "Undefined"
  }

  if {![regexp -line {(^FONT )(.*$)} $BdfText -> name FontSpec]} {
    set FontSpec "Undefined"
  }

  if {![regexp -line {(^COPYRIGHT )(.*$)} $BdfText -> name copyright]} {
    set copyright "Undefined"
  }

  # get default character width, height and offsets
  if {![regexp -line {(^FONTBOUNDINGBOX )(.*) (.*) (.*) (.*$)} $BdfText -> name FBBx FBBy FBBxoff FBByoff]} {
    set FBBx "Undefined"
    set FBBy "Undefined"
    set FBBxoff "Undefined"
    set FBByoff "Undefined"
  }

  if {![regexp -line {(^FONT_ASCENT )(.*$)} $BdfText -> name FontAsc]} {
    set FontAsc "Undefined"
  }

  # get number of characters
  if {![regexp -line {(^CHARS )(.*$)} $BdfText -> name numChars]} {
    set numChars "Undefined"
  }

  # Write to the file
  set TclFontChan [open $TclFontFile w]

  puts $TclFontFile
  
  puts $TclFontChan "\# $TclFontFile
\# BiblePix font extracted from $BdfFile
\# Font Name: $FontName
\# Font size: $FontSize
\# Font Specification: $FontSpec
\# Copyright: $copyright
\# Created: [clock format [clock seconds] -format "%d-%m-%Y"]

\# FONTBOUNDINGBOX INFO
set FBBx $FBBx
set FBBy $FBBy
set FBBxoff $FBBxoff
set FBByoff $FBByoff
set FontAsc $FontAsc
set numChars $numChars
"

  close $TclFontChan
}

proc convertCharacters {BdfText TclFontFile} {
  if {![regexp -line {(^CHARS )(.*$)} $BdfText -> name numChars]} {
    error "number of characters is not defined in the BDF file"
  }

  set TclFontChan [open $TclFontFile a]

  set indexEndChar 0

  for {set charNo 0} {$charNo < $numChars} {incr charNo} {

    # Set next character indices
    set indexBegChar [string first {STARTCHAR} $BdfText $indexEndChar]
    set indexEndChar [expr [string first ENDCHAR $BdfText $indexBegChar] +7]

    set charText [string range $BdfText $indexBegChar $indexEndChar]

    # 1. Extract necessary information

    ##get character encoding (to be used for character name)
    if {![regexp -line {(^ENCODING )(.*$)} $charText -> name enc]} {
      puts "skip character, no encoding value"
      continue
    }

    ##get boundingbox
    if {![regexp -line {(^BBX )(.*) (.*) (.*) (.*$)} $charText -> name BBx BBy BBxoff BByoff]} {
      puts "skip character, faulty boundingbox"
      continue
    }

    ##get DW
    if {![regexp -line {(^DWIDTH )(.*) (.*$)} $charText -> name DWx DWy]} {
      puts "skip character, faulty dWidth"
      continue
    }

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
    set binList [colourBinlist $binList $BBx]

    # 2. Create character array & append to TclFontFile
    puts $TclFontChan "array set print_$enc \{ 
  BBx [expr $BBx + 2]
  BBy [expr $BBy + 2]
  BBxoff $BBxoff
  BByoff [expr $BByoff - 1]
  DWx [expr $DWx + 2]
  DWy $DWy
  BITMAP \{ $binList \}
\}
"
  }

  close $TclFontChan
}

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
#    SSSSS
#   SS####S
#  SS######S
# SS###ss###S
# S###ss S###
# S###s  S###s
#  ###s SS###s
#  s###SS###ss
#   s######ss
#    s####ss
#     sssss

# Colour a single bitmap character
proc colourBinlist {binList BBx} {
  set colourList ""

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

# ConvertBdf2Tcl "E:/Projekte/BiblePix/prog/font/bdf/Arial15I.bdf" "E:/Projekte/BiblePix/prog/font/bdf"
# exit