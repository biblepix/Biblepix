# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 15apr19

#1. SET BASIC VARS
source $TwdTools
source $BdfTools

set TwdLang [getTwdLang $::TwdFileName]
set ::RtL [isRtL $TwdLang]

puts "Loading BdfPrint"
puts "TwdLang: $TwdLang"

#2. SOURCE FONTS INTO NAMESPACES

##Chinese: (regular_24)
if {$TwdLang == "zh"} {
  set ::prefix Z
  if {! [namespace exists Z]} {
    namespace eval Z {
      source -encoding utf-8 $BdfFontPaths(ChinaFont)
    }
  }

##Thai: (regular_20)
} elseif {$TwdLang == "th"} {
  set ::prefix T
  if {! [namespace exists T]} {
    namespace eval T {
      source -encoding utf-8 $BdfFontPaths(ThaiFont)
    }
  }

## All else: Regular / Bold / Italic
} else {

  if {$fontweight == "bold"} {
    set ::prefix B
  } else {
    set ::prefix R
  }

  if {! [namespace exists R] && $fontweight != "bold"} {
    namespace eval R {
puts "sourcing $BdfFontPaths($fontName)"
      source -encoding utf-8 $BdfFontPaths($fontName)
    }
  }
  
  
  #Source Italic for all except Asian
  if {! [namespace exists I]} {
    namespace eval I {
puts "sourcing $BdfFontPaths($fontNameItalic)"
      source -encoding utf-8 $BdfFontPaths($fontNameItalic)
    }
  }
  
  #Source Bold if $enabletitle OR $fontweight==bold
  if {$enabletitle || $fontweight == "bold"} { 
    if {! [namespace exists B]} {
      namespace eval B {
puts "sourcing $BdfFontPaths($fontNameBold)"
        source -encoding utf-8 $BdfFontPaths($fontNameBold)
      }
    }
  }
} ;#END source fonts

puts "Finished loading fonts"

# 3. LAUNCH PRINTING & SAVE IMAGE
set img hgbild

#Compute avarage colours of text section
proc computeColours {} {
puts "Computing colours..."
source $Imgtools

  #TODO: Just testing for now
if {![catch {computeAvColours hgbild}]} {

  puts "Brightness: $rgb::avBrightness"
  if {$rgb::avBrightness >= 200} {

      if {$rgb::maxCol == $rgb::avGreen} {
            set fontcolortext blue
      } else {
            set fontcolortext green
      }

  } else {
      set fontcolortext gold
  }

  puts "Font colour: $fontcolortext"
}

}

set finalImg [printTwd $TwdFileName $img]

if {$platform=="windows"} {  
  $finalImg write $TwdTIF -format TIFF
  puts "Saved new image to $TwdTIF"
} elseif {$platform=="unix"} {
  $finalImg write $TwdBMP -format BMP
  $finalImg write $TwdPNG -format PNG
  puts "Saved new images to $TwdTIF + $TwdPNG"
}

#Cleanup
image delete $finalImg
