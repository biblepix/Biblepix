# ~/Biblepix/progs/src/pic/image.tcl
# Initiates BdfPrint, called by biblepix.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 29dec20

source $ImgTools
source $AnnotatePng
namespace eval colour {}
  
#Load Img/tkimg (part of ActiveTcl, Linux distros need to install separately)
if [catch {package require Img}] {
  package require Tk
  source -encoding utf-8 $Texts
  setTexts $lang
  tk_messageBox -title BiblePix -type ok -icon error -message $packageRequireImg
  exit
}

#Hide Tk window as not needed
wm overrideredirect . 1
wm geometry . +0-30
wm withdraw .

#Select & create random background PNG
set picPath [getRandomPhotoPath]
image create photo hgbild -file $picPath

#TODO this blocks any further processing!!!!!!!!!!!!!!!!!!
#Extract any info from PNG & export to ::colour ns
#if {[readPngComment $picPath] != ""} {
#  lassign [evalPngComment $picPath] colour::marginleft colour::margintop colour::luminacy
#}

#Printing   B D F 
puts "Creating BDF picture..."
source $BdfPrint
