set tol 5

namespace eval colour {

proc scanRow {img y} {
  set tol 10  
  set x 1000
  set imgX [expr [image width $img] - 5]
  
  #pretend prev array for 1st run
  array set prev {r 0 g 0 b 0}
  set L simlist$y
  
  #Run through row pixels from 1 less to 1 less at margins
  
for {set x 100} {$x < $imgX} {incr x} {
  
    set c [$img get $x $y]
    set r [lindex $c 0]
    set g [lindex $c 1]
    set b [lindex $c 2]
puts "$r $g $b"    

    array set cur "r $r g $g b $b"
    
    set maxr [::tcl::mathfunc::max $cur(r) $prev(r)]
    set minr [::tcl::mathfunc::min $cur(r) $prev(r)]
    set maxg [::tcl::mathfunc::max $cur(g) $prev(g)]
    set ming [::tcl::mathfunc::min $cur(g) $prev(g)]
    set maxb [::tcl::mathfunc::max $cur(b) $prev(b)]
    set minb [::tcl::mathfunc::min $cur(b) $prev(b)]
    
    #B) move curr to $simxy if equal OR within tolerance
    if {
      
      [expr $maxr - $minr] < $tol &&
      [expr $maxg - $ming] < $tol &&
      [expr $maxb - $minb] < $tol
    
    } {
 
      lappend [namespace current]::$L $x
      puts "Adding $x to L ..."
    }
  
    array set prev "r $r g $g b $b"
    
parray prev
  
  } ;#END for loop 

} ;# END scanRow

} ;#END ::colour namespace


# scanSimlist
##scans simlist for fake sections (with spaces over $spacetol pixels) 
scanList {simlist spacetol} {
  
  set prev 0
  
  foreach cur $simlist {
    
    if {[expr $cur - $prev] > $spacetol } {
      continue
  
    } else {
      
      lappend $simlist_ok $cur   
    }
  }
} ;#END scanSimlist


# determineSimilarColourArea
##evaluates $simlist_ok lists for suitably large areas (minwidth=? / maxheight=?)
proc determineSimilarColourArea {img minwidth minheight} {

  if ! [array exists colour::sim.0] {
    puts "No similar colours array found!"
    return 1
  }

  #Compare first and last positions of rows
  foreach simlist [info vars colour::simlist.*] {
    set beg [lindex $simlist 0]
    set end [lindex $simlist end]
    
    lappend $beg beginlist
    lappend $end endlist
  

  }
 
 #Compute average start positions   
  foreach pos $beginlist {
    incr beginTotal $pos
    incr beginCount
  }
  set beginAverage [expr $beginTotal / $beginCount]
    
  #Compute average end positions


#A) Eliminate fake ranges with a min. of ?500? consecutive pixels     

#B) List consecutive rows from A)
  
  
  #C Return coords
  set x1 ... ...
  lappend area $x1 $y1 $x2 $y2
  return $area

} ;#END determineSimilarColourArea


namespace delete colour
