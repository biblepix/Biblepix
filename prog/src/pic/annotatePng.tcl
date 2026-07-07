# ~/Biblepix/prog/src/pic/annotatePng.tcl
# Sourced by SetupResizePhoto
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 7jul26 pv

package require png

# writePngComment
##writes BiblePix comment if args, removes any previous comments
##called by SetupResizePhoto
proc writePngComment {args} {
  #lappend text $x $y $lum
  lassign $args text
   
  #1. remove any previous comments
  set filepath  $::addpicture::targetPicPath 
  ::png::removeComments $filepath
  
  #2. add {x y lum} if present
  if {$args == ""} {
    return 1
  }

  #write list with 2 positions
  lappend text $args
  ::png::addComment $filepath BiblePix $text
}


# readPngComment
##called by ...
proc readPngComment {file} {
  
  set s [::png::getComments $file]
  
  if {$s == ""} {
    #Clean any wrong comments
    ::png::removeComments $file    
    return 0
  }
   
  #2. Position 1 von $s hat "BiblePix", Position 2 hat 3 Zahlen 
  #set text [lindex $s 1]
  
  #Check correctness of text
  if { [lindex $s 0 0] != "BiblePix"} {
    #Clean any wrong comments 
    puts "faulty PNG comment, deleting comments in $file"
    ::png::removeComments $file
    return 0
  }

  puts "Processing margin info found in $file..."

  #3 Zahlen
  set x [lindex $s 0 1]
  set y [lindex $s 0 2]
  set lum [lindex $s 0 3]

  return [list $x $y $lum]
  
} ;#END readPngComment

 
# evalPngComment
##evaluates result of readPngComment
##returns Marginleft & Marginright & Luminacy as list
##called by Image 
#proc evalPngComment {file} {
#  set T [readPngComment $file]
#  #Check keyword & exit if missing
#  if ![regexp BiblePix $T] {
#    return -code error 0
#  }
#  #Extract X, Y and L from data string
#  set X [string range [regexp -inline {X[0-9]*} $T] 1 end]
#  set Y [string range [regexp -inline {Y[0-9]*} $T] 1 end]
#  set L [string index [regexp -inline {L[0-9]} $T] end]
#  #return as array
#  return [list $X $Y $L]
#}

##################################################################
# Below procs have been copied from: https://wiki.tcl-lang.org
# With thanks and God's blessings to AF!
##################################################################

# readPngComment
#adapted from: https://wiki.tcl-lang.org/page/Writing+PNG+Comments
##reads the comment blocks from a PNG file. This functionality is also present in the tcllib png module.
##currently only supports uncompressed comments. Does not attempt to verify checksum.
##returns "X Y L" or 0
##called by Image
#proc ALT-readPngComment {file} {
#  set fh [open $file r]
#  fconfigure $fh -encoding binary -translation binary -eofchar {}
#  if {[read $fh 8] != "\x89PNG\r\n\x1a\n"} { close $fh; return }
#  set text {}
#
#  while {[set r [read $fh 8]] != ""} {
#      binary scan $r Ia4 len type
#      set r [read $fh $len]
#      if {[eof $fh]} { close $fh; return }
#      if {$type == "tEXt"} {
#          lappend text [split $r \x00]
#      } elseif {$type == "iTXt"} {
#          set keyword [lindex [split $r \x00] 0]
#          set r [string range $r [expr {[string length $keyword] + 1}] end]
#          binary scan $r cc comp method
#          if {$comp == 0} {
#              lappend text [linsert [split [string range $r 2 end] \x00] 0 $keyword]
#          }
#      }
#      seek $fh 4 current
#  }
#  close $fh
#  
#  if {$text != ""} {
#    return $text
#  } {
#    return 0
#  }
#}

# writePngComment
##adapted from: https://wiki.tcl-lang.org/page/Reading+PNG+Comments
##reads the comment blocks from a PNG file. This functionality is also present in the tcllib png module.
##called by processPngComment


#proc ALTwritePngComment {filePath text} {
#
#  set keyword "BiblePix"
#  
#  set fh [open $file r+]
#  fconfigure $fh -encoding binary -translation binary -eofchar {}
#
#  if {[read $fh 8] != "\x89PNG\r\n\x1a\n"} { close $fh; return }
#
#    while {[set r [read $fh 8]] != ""} {
#
#      binary scan $r Ia4 len type
#
#      if {$type ==  "IDAT"} {
#        seek $fh -8 current
#        set pos [tell $fh]
#        set data [read $fh]
#        seek $fh $pos start
#        set size [binary format I [string length "${keyword}\x00${text}"]]
#        puts -nonewline $fh "${size}tEXt${keyword}\x00${text}\x00\x00\x00\x00$data"
#        close $fh
#        return
#      }
#      seek $fh [expr {$len + 4}] current
#    }
#    close $fh
#    return -code error "no data section found"
#} ;#END writePngComment
#
## processPngComment
###called by reposPhoto OK btn
###Keyword added by writePngComment
#proc processPngComment {x y lum} {
#  #Text format: X1345 Y1234 L[1-3]
##  append text X $x Y $y L $lum
#set file $::addpicture::targetPicPath
#append text $x $y $lum
#::png::removeComments $file
#::png::addComment $file BiblePix $text
#
##  writePngComment $file $text
#  return 0
#}
