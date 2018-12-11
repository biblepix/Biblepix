# ~/Biblepix/progs/src/pic/image.tcl
# Initiates BdfPrint, called by biblepix.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 11dec18

#Load Img/tkimg (part of ActiveTcl, Linux distros need to install separately)
if [catch {package require Img}] {
  package require Tk
  source -encoding utf-8 $Texts
  setTexts $lang
  tk_messageBox -title BiblePix -type ok -icon error -message $packageRequireImg
  exit
}

#Hide Tk window as not needed -todo: MOVE TO Bdfprint?
wm overrideredirect . 1
wm geometry . +0-30
wm withdraw .

#Select & create random background JPEG/PNG
set hgfile [getRandomPhoto]
image create photo hgbild -file $hgfile

#Printing   B D F 
puts "Creating BDF picture..."
source $BdfPrint
return