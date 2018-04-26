# ~/Biblepix/progs/src/pic/image.tcl
# Initiates BdfPrint, called by biblepix.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 26apr18

package require Img

#Load Img/tkimg (part of ActiveTcl, Linux distros need to install separately)

#TODO: gehört das hierher?
#if { [catch {package require Img}] } {
#  source -encoding utf-8 $Texts
#  setTexts $lang
#  tk_messageBox -title BiblePix -type ok -icon error -message $packageRequireImg
#  exit
#}

#Select & create random background JPEG/PNG
set hgfile [getRandomPhoto]
image create photo hgbild -file $hgfile


#printing   B D F 

  puts "Creating BDF picture..."
  
  source $TwdTools
  source $BdfTools
  source $BdfPrint
  
  return
  