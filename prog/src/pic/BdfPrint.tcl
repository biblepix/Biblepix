# ~/Biblepix/prog/src/pic/BdfPrint.tcl
# Top level BDF printing prog
# sourced by Image
# Authors: Peter Vollmar & Joel Hochreutener, www.biblepix.vollmar.ch
# Updated: 6jul21 pv
source $TwdTools
source $BdfTools
source $ImgTools

set TwdLang [getTwdLang $TwdFileName]
set RtL [isRtL $TwdLang]
puts $TwdLang

set fw ""
if {$fontweight == "bold"} {
  set fw B
}

# S O U R C E   F O N T S   I N T O   N A M E S P A C E S

##Chinese: (regular_24)
if {$TwdLang == "zh"} {
  set ::prefix Z
  if ![namespace exists Z] {
    namespace eval Z {
      source -encoding utf-8 $ChinaFont
    }
  }
##Thai: (regular_20)
} elseif {$TwdLang == "th"} {
  set ::prefix T
  if ![namespace exists T] {
    namespace eval T {
      source -encoding utf-8 $ThaiFont
    }
  }

##All else: Regular / Bold / Italic
} else {

  if {$fontfamily == "Serif" } {
    set fontfam Times
  } {
    set fontfam Arial
  }

  if {$fontweight == "bold"} {
    set ::prefix B
  } else {
    set ::prefix R
  }

  if {! [namespace exists R] && $fontweight != "bold"} {
  
    catch {unset fontname}  
    append fontname $fontfam $fontsize 
    set fnpath [set $fontname]
    namespace eval R {
      source -encoding utf-8 $::fnpath
    }
  }
  
  #Source Italic for all except Asian
  if ![namespace exists I] {
  
  catch {unset fontname}
  append fontname $fontfam I $fontsize 
    set fnpath [set $fontname]
    namespace eval I {
      source -encoding utf-8 $::fnpath
    }
  }
  
  #Source Bold if $enabletitle OR $fontweight==bold
  if {$enabletitle || $fontweight == "bold"} { 
    if ![namespace exists B] {
    catch {unset fontname}
    append fontname $fontfam B $fontsize 
    set fnpath [set $fontname]
      namespace eval B {
        source -encoding utf-8 $::fnpath
      }
    }
  }

} ;#END source fonts


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

##save image
#TODO testing Win slideshow
if {$platform=="windows"} {  
  $finalImg write $TwdTIF -format TIFF
  $finalImg write $TwdBMP -format BMP
  puts "Saved new image to:\n $TwdTIF" and \n $TwdBMP
  
} elseif {$platform=="unix"} {
  $finalImg write $TwdBMP -format BMP
  $finalImg write $TwdPNG -format PNG
  puts "Saved new images to:\n $TwdBMP\n $TwdPNG"
}

#Cleanup original and final image
image delete $finalImg
