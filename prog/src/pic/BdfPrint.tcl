# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 13sep21 pv
source $TwdTools
source $BdfTools
source $ImgTools
set TwdLang [getTwdLang $TwdFileName]
set RtL [isRtL $TwdLang]
puts $TwdLang

# S O U R C E   F O N T S   I N T O   N A M E S P A C E S

#Add fontfamily to fontname
if {$TwdLang == "zh"} {
  set fontfam Chinafont
} elseif {$TwdLang == "th"} {
  set fontfam Thaifont
} elseif {$fontfamily == "Serif"} {
  set fontfam Times
} elseif {$fontfamily == "Sans"} {
  set fontfam Arial
}

#Add fontweight to fontname
if {$fontweight == "bold"} {
  set ::prefix B
} else {
  set ::prefix R
}

#Set Regular namespace
if { $fontweight != "bold"} {
  namespace eval R {}
  catch {unset fontname}
  append fontname $fontfam $fontsize 
  set R::fontpath [set $fontname]
  
  namespace eval R {
    source -encoding utf-8 $fontpath
  }
}
  
#Set Italic namespace
namespace eval I {}
catch {unset fontname}
if {$TwdLang == "XXzh"} {
  ##Chinese italic = next smaller
 # set I::fontpath [setChinafontItalic $fontsize]  
} else { 
  append fontname $fontfam I $fontsize 
  set I::fontpath [set $fontname]
  namespace eval I {
    source -encoding utf-8 $fontpath
  }
}
#Set Bold namespace
if {$enabletitle || $fontweight == "bold"} { 
  namespace eval B {}
  catch {unset fontname fnpath}
  ##Chinese bold = next bigger
  if {$TwdLang == "zh"} {
     set B::fontpath [setChinafontBold $fontsize]  
  } else { 
    append fontname $fontfam B $fontsize   
    set B::fontpath [set $fontname]
  } 
  namespace eval B {
    source -encoding utf-8 $fontpath
  }
}


# 2) C O M P U T E   C O L O U R S   A N D   M A R G I N S
puts "Computing colours..."
puts $fontcolortext

#Compute avarage colours of text section - to be saved in colour:: as regHex sunHex shaHex
setFontShades $fontcolortext

# 3)  I N I T I A L I S E   P R I N T I N G

puts "Printing TWD text..."

##print image
#set finalImg [bdf::printTwd $TwdFileName hgbild $marginleft $margintop]
set finalImg [bdf::printTwd $TwdFileName hgbild]

##save image:
##BMP for all platforms
$finalImg write $TwdBMP -format BMP
puts "Saved new images to:\n $TwdBMP"
##PNG for unix (may need 2 pics for slideshow)
if {$platform=="unix"} {
  $finalImg write $TwdPNG -format PNG
  puts "Saved new images to:\n $TwdPNG"
}

#Cleanup original and final image
image delete $finalImg
