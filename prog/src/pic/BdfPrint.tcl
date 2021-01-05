# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 5jan21
source $TwdTools
source $BdfTools
source $ImgTools
set TwdLang [getTwdLang $::TwdFileName]
set ::RtL [isRtL $TwdLang]
puts "Loading BdfPrint"

# S O U R C E   F O N T S   I N T O   N A M E S P A C E S

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
##All else: Regular / Bold / Italic
} else {

  if {$fontweight == "bold"} {
    set ::prefix B
  } else {
    set ::prefix R
  }

  if {! [namespace exists R] && $fontweight != "bold"} {
    namespace eval R {
      puts "sourcing $BdfFontPaths($fontname)"
      source -encoding utf-8 $BdfFontPaths($fontname)
    }
  }
  
  #Source Italic for all except Asian
  if {! [namespace exists I]} {
    namespace eval I {
      puts "sourcing $BdfFontPaths($fontnameItalic)"
      source -encoding utf-8 $BdfFontPaths($fontnameItalic)
    }
  }
  
  #Source Bold if $enabletitle OR $fontweight==bold
  if {$enabletitle || $fontweight == "bold"} { 
    if {! [namespace exists B]} {
      namespace eval B {
        puts "sourcing $BdfFontPaths($fontnameBold)"
        source -encoding utf-8 $BdfFontPaths($fontnameBold)
      }
    }
  }
} ;#END source fonts



# L A U N C H   P R I N T I N G  &  S A V E   I M A G E

#Compute avarage colours of text section
puts "Computing colours..."
namespace eval colour {}

#Compute reg/sun/shade hex & export to ::colour NS
set curArrname [string tolower $fontcolortext 0]
array set regArr [array get $curArrname]
set regHex [rgb2hex regArr]
##set sun rgb & hex
lassign [setSun regArr] sunR sunG sunB
array set sunArr "r $sunR g $sunG b $sunB"
set sunHex [setSun regArr hex]
##set shade rgb & hex
lassign [setShade regArr] shaR shaG shaB
array set shaArr "r $shaR g $shaG b $shaB"
set shaHex [setShade regArr hex]

##Export general colour hex values (=PNG value 2)
set colour::regHex $regHex
set colour::sunHex $sunHex
set colour::shaHex $shaHex

#Reset if PNG lumiance info differs from 2
if [info exists colour::Luminacy] {
  ##1) dark bg: increase font colour luminance
  if {$colour::luminacy == 1} {
    set colour::regHex $sunHex
    set colour::shaHex $regHex
    set colour::sunHex [setSun sunArr ashex]
  ##2) bright bg: reduce font colour luminance
  } elseif {$colour::Luminacy == 3} {
    set colour::regHex $shaHex
    set colour::sunHex $regHex
    set colour::shaHex [setShade shaArr ashex]
  }
}

puts "Printing TWD text..."
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
