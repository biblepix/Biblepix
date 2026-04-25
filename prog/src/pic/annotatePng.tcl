# ~/Biblepix/prog/src/pic/annotatePng.tcl
# Sourced by SetupResizePhoto
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 17apr26 pv

package require png

proc writePngComment {file x y lum} {
  lappend text $x $y $lum
   
  ::png::removeComments $file
  ::png::addComment $file BiblePix $text
}

proc readPngComment {file} {
  
  set s [::png::getComments $file]
  
  if {$s == ""} {
    return "No margin info found to process in $file.\nYou can change this by deleting and re-adding this picture to the BiblePix photo collection."
  }
   
   
   #2. Position = 3 Zahlen TODO Was stimmt bei Bedingung nicht ????
  set t [lindex $s 1]
puts $t
  
  if { [lindex $t 0] != "BiblePix" ||
       [llength $t]  != "2" 
      
  } { puts "No usable margin info found in $file. For now we are positioning text as set in Setup>Photos.\nYou can change the text position of this picture by deleting and re-adding it to the BiblePix photo collection."
      
  } else {
  
    puts "Processing margin info found in $file..."

  #3 Zahlen
    set x [lindex $t 0]
    set y [lindex $t 1]
    set lum [lindex $t 2]

    return [list $x $y $lum]
  
  }
#  return "Nothing done."
  
} ;#END readPngComment



 
# evalPngComment
##evaluates result of readPngComment
##returns Marginleft & Marginright & Luminacy as list
##called by Image 
proc evalPngComment {file} {
  set T [readPngComment $file]
  #Check keyword & exit if missing
  if ![regexp BiblePix $T] {
    return -code error 0
  }
  #Extract X, Y and L from data string
  set X [string range [regexp -inline {X[0-9]*} $T] 1 end]
  set Y [string range [regexp -inline {Y[0-9]*} $T] 1 end]
  set L [string index [regexp -inline {L[0-9]} $T] end]
  #return as array
  return [list $X $Y $L]
}

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
proc readPngComment {file} {
  set fh [open $file r]
  fconfigure $fh -encoding binary -translation binary -eofchar {}
  if {[read $fh 8] != "\x89PNG\r\n\x1a\n"} { close $fh; return }
  set text {}

  while {[set r [read $fh 8]] != ""} {
      binary scan $r Ia4 len type
      set r [read $fh $len]
      if {[eof $fh]} { close $fh; return }
      if {$type == "tEXt"} {
          lappend text [split $r \x00]
      } elseif {$type == "iTXt"} {
          set keyword [lindex [split $r \x00] 0]
          set r [string range $r [expr {[string length $keyword] + 1}] end]
          binary scan $r cc comp method
          if {$comp == 0} {
              lappend text [linsert [split [string range $r 2 end] \x00] 0 $keyword]
          }
      }
      seek $fh 4 current
  }
  close $fh
  
  if {$text != ""} {
    return $text
  } {
    return 0
  }
}

# writePngComment
##adapted from: https://wiki.tcl-lang.org/page/Reading+PNG+Comments
##reads the comment blocks from a PNG file. This functionality is also present in the tcllib png module.
##called by processPngComment

#TODO write 3 keywords with text at 1 go!
#Vorschlag: keyword=BiblePix text="$X $Y $Nuance"
proc addPngComment {file} {}

proc writePngComment {file text} {

  set keyword "BiblePix"
  
  set fh [open $file r+]
  fconfigure $fh -encoding binary -translation binary -eofchar {}

  if {[read $fh 8] != "\x89PNG\r\n\x1a\n"} { close $fh; return }

    while {[set r [read $fh 8]] != ""} {

      binary scan $r Ia4 len type

      if {$type ==  "IDAT"} {
        seek $fh -8 current
        set pos [tell $fh]
        set data [read $fh]
        seek $fh $pos start
        set size [binary format I [string length "${keyword}\x00${text}"]]
        puts -nonewline $fh "${size}tEXt${keyword}\x00${text}\x00\x00\x00\x00$data"
        close $fh
        return
      }
      seek $fh [expr {$len + 4}] current
    }
    close $fh
    return -code error "no data section found"
} ;#END writePngComment

# processPngComment
##called by reposPhoto OK btn
##Keyword added by writePngComment
proc processPngComment {file x y lum} {
  #Text format: X1345 Y1234 L[1-3]
#  append text X $x Y $y L $lum
append text $x $y $lum
::png::removeComments $file
::png::addComment $file BiblePix $text

#  writePngComment $file $text
  return 0
}
