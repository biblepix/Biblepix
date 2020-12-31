# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 29dec20

source $TwdTools
source $BdfTools
#source $ImgTools

set TwdLang [getTwdLang $::TwdFileName]
set ::RtL [isRtL $TwdLang]
puts "Loading BdfPrint"

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

#Compute avarage colours of text section
puts "Computing colours..."

#Compute sun & shade
set rgb [hex2rgb $fontcolor]
set sun [setSun $rgb]
set shade [setShade $rgb]

#A) PNG info present:
if [info exists colour::luminacy] {
  if {$colour::luminacy == 1} {
    set colour::shade $rgb
    set colour::rgb $sun
    set colour::sun [setSun $sun]
  } elseif {$colour::luminacy == 2} {
    set colour::rgb $rgb
    set colour::shade $shade
    set colour::sun $sun  
  } elseif {$colour::luminacy == 3} {
    set colour::sun $rgb
    set colour::rgb $shade
    set colour::shade [setShade $shade]
  }

#B) No PNG info found:
} else {
  set colour::rgb $rgb
  set colour::shade $shade
  set colour::sun $sun  
}

set finalImg [printTwd $TwdFileName hgbild]

if {$platform=="windows"} {  
  $finalImg write $TwdTIF -format TIFF
  puts "Saved new image to:\n $TwdTIF"
} elseif {$platform=="unix"} {
  $finalImg write $TwdBMP -format BMP
  $finalImg write $TwdPNG -format PNG
  puts "Saved new images to:\n $TwdBMP\n $TwdPNG"
}

#Cleanup original and final image
image delete $finalImg
