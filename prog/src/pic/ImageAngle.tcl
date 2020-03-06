#!/usr/bin/tclsh
#with thanks to Kevin Kenny

package require Tk
 set ::pi 3.1415927 ;# Good enough accuracy for gfx...

 # Create a meter 'enabled' canvas
 proc makeMeter {} {
     global meter angle
     canvas .c -width 200 -height 110 -borderwidth 2 -relief sunken -bg white
     for {set i 0;set j 0} {$i<100} {incr i 5;incr j} {
         set meter($j) [.c create line 100 100 10 100 \
                 -fill grey$i -width 3 -arrow last]
         set angle($j) 0
         .c lower $meter($j)
         updateMeterLine .c 0.2 $j
     }
     .c create arc 10 10 190 190 -extent 108 -start 36 -style arc -outline red
     return .c
 }

 # Draw a meter line (and recurse for lighter ones...)
 proc updateMeterLine {w a {l 0}} {
     global meter angle pi
     set oldangle $angle($l)
     set angle($l) $a
     set x [expr {100.0 - 90.0*cos($a * $pi)}]
     set y [expr {100.0 - 90.0*sin($a * $pi)}]
     $w coords $meter($l) 100 100 $x $y
     incr l
     if {[info exist meter($l)]} {updateMeterLine $w $oldangle $l}
 }

 # Convert variable to angle on trace
 proc updateMeter {name1 name2 op} {
     upvar #0 $name1 v
     set min [.s cget -from]
     set max [.s cget -to]
     set pos [expr {($v - $min) / ($max - $min)}]
     updateMeterLine .c [expr {$pos*0.6+0.2}]
 }

 # Fade over time
 proc updateMeterTimer {} {
     global v
     set v $v
     after 20 updateMeterTimer
 }

 grid [makeMeter]
 grid [scale .s -orient h -from 0 -to 360 -variable v]
 trace variable v w updateMeter
 updateMeterTimer
