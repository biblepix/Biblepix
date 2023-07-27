# ~/Biblepix/progs/src/pic/image.tcl
# Initiates BdfPrint, called by biblepix.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 27jul23 pv

source $ImgTools
source $AnnotatePng
namespace eval colour {}
package require Tk
    	
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

  #Extract any info from PNG & export pngInfo to ::colour ns
  puts "\nReading PNG info from [file tail $picPath] ..."
  set pngmargins 1
   
  #A) Use Config values ??later
  catch {evalPngComment $picPath} res 
    
    if {$res == 0} {
       puts "*No PNG info found*"
      set luminacy 0
      
    source $::Config
    set marginleft $marginleft
    set margintop $margintop
    set pngmargins 0
    
    } else {   
    
      lassign $res marginleft margintop luminacy  
      ##margin info may be missing from png!
      if !$marginleft {
        puts "*No PNG margin info found!"
        source $::Config
        set marginleft $marginleft
        set margintop $margintop
        set pngmargins 0  
      } 
  }
}

#Printing   B D F 
#puts "Creating BDF picture..."
source $BdfPrint
