# ~/Biblepix/prog/src/pic/annotatePng.tcl
# Sourced by SetupResizePhoto & Image
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 17jul26 pv

package require png

# writePngComment
##writes BiblePix comment if args, removes any previous comments
##called by SetupResizePhoto
proc writePngComment {args} {
  
  set keywd "BiblePix"
  set text "$args"
   
  #1. remove any previous comments
  set filepath  $::addpicture::targetPicPath 
  ::png::removeComments $filepath
  
  #2. add {x y lum} if present
  if {$args == ""} {
    return 1
  }

  #write ?list with keyword + 3 digits
  ::png::addComment $filepath $keywd $text
}


# readPngComment
##must consist of X Y Lum
##returns 3 digit text or nothing
##called by Image
proc readPngComment {file} {
  
  set text [::png::getComments $file]

  #parse & check text for correctness
  if [string first "Pix" $text] {
    catch {set digs [lindex [join $text] 1]}

    if {[llength $digs] == 3} {
      foreach e $digs {lappend diglist $e}
    }
  }

  if { [info var diglist] == "" } {
    return ""
  }

  return $diglist

} ;#END readPngComment

