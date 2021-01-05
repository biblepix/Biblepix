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

# SOURCE FONTS INTO NAMESPACES
#TODO testing: - why is this not loaded by Globals????????????
source $LoadConfig

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



# 3. LAUNCH PRINTING & SAVE IMAGE

#Compute avarage colours of text section
puts "Computing colours..."
namespace eval colour {}

#Compute sun & shade arrays
##set regArr, copying fontcolour array
set curArrname [string tolower $fontcolortext 0]
array set regArr [array get $curArrname]
set regHex [rgb2hex regArr]
set sunHex [setSun regArr hex]
set shaHex [setShade regArr hex] 

#TODO these need reworking (s. from line 110)
#A) If PNG info present
if [info exists colour::Luminacy] {

  ##copy arrays in shifted order & export to ::colour NS
  if {$colour::luminacy == 1} {

    array set colour::shaArr [array get regArr]
    array set colour::regArr [array get sunArr]
    lassign [setSun sunArr] sunR sunG sunB
    array set colour::sunArr "r $sunR g $sunG b $sunB"

  } elseif {$colour::Luminacy == 2} {  
    array set colour::regArr [array get regArr]
    array set colour::shaArr [array get shaArr]
    array set colour::sunArr [array get sunArr]
    
  } elseif {$colour::Luminacy == 3} {
    array set colour::sunArr [array get regArr]
    array set colour::regArr [array get shaArr]
    lassign [setShade shaArr] shadeR shadeG shadeB
    array set colour::shaArr "r $shadeR g $shadeG b $shadeB"
  }
  

#B) If no PNG info found: export above standards to ::colour NS
} else {
  
  #Set hex vars for Bdf Print
  set colour::regHex $regHex
  set colour::sunHex $sunHex
  set colour::shaHex $shaHex
#  set reg [rgb2hex regArr]
#  set sun [rgb2hex sunArr]
#  set sha [rgb2hex shaArr]
  
#  array set colour::regArr [array get regArr]
#  array set colour::shaArr [array get shaArr]
#  array set colour::sunArr [array get sunArr]
}
return "$regHex $sunHex $shaHex"




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
