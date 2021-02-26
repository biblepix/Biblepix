# ~/Biblepix/progs/src/pic/image.tcl
# Initiates BdfPrint, called by biblepix.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 10feb21 pv

source $ImgTools
source $AnnotatePng
namespace eval colour {}
package require Tk
    
#Load Img/tkimg (part of ActiveTcl, Linux distros need to install separately)
if [catch {package require Img}] {
  source -encoding utf-8 $Texts
  setTexts $lang
  if [catch {tk_messageBox -title BiblePix -type ok -icon error -message $packageRequireImg} {
    return -error "Packages Tk and Img cannot be loaded. Exiting."
  }
}

#Hide Tk window as not needed
wm overrideredirect . 1
wm geometry . +0-30
wm withdraw .

#Select & create random background PNG
set picPath [getRandomPhotoPath]
image create photo hgbild -file $picPath

#get random fontcolour if activated
if {$enableRandomFontcolor} {
  set fontcolortext [getRandomFontcolor]
}

namespace eval bdf {
  variable marginleft
  variable margintop
  variable luminacy
  variable picPath $::picPath

  source $::Config


  #Extract any info from PNG & export pngInfo to ::colour ns
  puts "\nReading PNG info from [file tail $picPath] ..."

  #A) Use Config values ??later
  if [catch {evalPngComment $picPath}] {
    puts "*No PNG info found*"
    set luminacy 0
    set marginleft 0
    set margintop 0

  #B) Use pnginfo values 
  } else {

    lassign [evalPngComment $picPath] marginleft margintop luminacy  
    if !$marginleft {
      set marginleft $::marginleft
    }
    if !$margintop {
      set margintop $::margintop
    }
  }

puts "bdfLum  $bdf::luminacy"
puts "bdfLeft $bdf::marginleft"
puts "bdfTop  $bdf::margintop"
}
#Printing   B D F 
#puts "Creating BDF picture..."
source $BdfPrint
