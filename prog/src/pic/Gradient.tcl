    # gradient
    #
    #    adjusts a color to be "closer" to either white or black
    #
    # Usage:
    #
    #    gradient color factor ?window?
    #
    # Arguments:
    #
    #    color   - standard tk color; either a name or rgb value
    #              (eg: "red", "#ff0000", etc)
    #    factor  - a number between -1.0 and 1.0. Negative numbers
    #              cause the color to be adjusted towards black;
    #              positive numbers adjust the color towards white.
    #    window  - a window name; used internally as an argument to
    #              [winfo rgb]; defaults to "."
package require Tk

#Copied from https://wiki.tcl-lang.org/page/Making+color+gradients, with many thanks and God's blessings to Blaise Montandon
#Please visit our project website www.bible2.net > BiblePix 
    proc gradient {rgb factor {window .}} {

        foreach {r g b} [winfo rgb $window $rgb] {break}

        ### Figure out color depth and number of bytes to use in
        ### the final result.
        if {($r > 255) || ($g > 255) || ($b > 255)} {
            set max 65535
            set len 4
        } else {
            set max 255
            set len 2
        }

        ### Compute new red value by incrementing the existing
        ### value by a value that gets it closer to either 0 (black)
        ### or $max (white)
        set range [expr {$factor >= 0.0 ? $max - $r : $r}]
        set increment [expr {int($range * $factor)}]
        incr r $increment

        ### Compute a new green value in a similar fashion
        set range [expr {$factor >= 0.0 ? $max - $g : $g}]
        set increment [expr {int($range * $factor)}]
        incr g $increment

        ### Compute a new blue value in a similar fashion
        set range [expr {$factor >= 0.0 ? $max - $b : $b}]
        set increment [expr {int($range * $factor)}]
        incr b $increment

        ### Format the new rgb string
        set rgb \
            [format "#%.${len}X%.${len}X%.${len}X" \
                 [expr {($r>$max)?$max:(($r<0)?0:$r)}] \
                 [expr {($g>$max)?$max:(($g<0)?0:$g)}] \
                 [expr {($b>$max)?$max:(($b<0)?0:$b)}]]


        ### Return the new rgb string
        return $rgb
    }

#Rainbow gradients demo
proc rainbow {} {
  package require Tk
  foreach c {red orange yellow green blue purple violet} {
   frame .$c -width 100
   pack .$c -side left
   set count 0
   for {set f -1.0} {$f <= 1.0} {set f [expr {$f + 0.005}]} {
     set frame .$c.f[incr count]
     frame $frame -background [gradient $c $f] -height 1 -width 100
     pack $frame -fill x
   }
 }
}


proc 3xwelchefarbe? {} {
set im [image create photo -width 600 -height 768]

#Was sind die Ausgangsfarben???????????????????
        for {set i 1} {$i < 256} {incr i} {
        set col [format "%2.2XFFFF" $i]        
        $im put "#$col" -to 0 $i 600 [expr {$i + 1}]
        }

        for {set i 1} {$i < 256} {incr i} {
        set col [format "FF%2.2XFF" $i]        
        set yi [expr {$i + 256}]
        $im put "#$col" -to 0 $yi 600 [expr {$yi + 1}]
        }

        for {set i 1} {$i < 256} {incr i} {
        set col [format "FFFF%2.2X" $i]        
        set yi [expr {$i + 512}]
        $im put "#$col" -to 0 $yi 600 [expr {$yi + 1}]
        }
        
  #Pick your rgb with the mouse!
  pack [canvas .c -bd 0 -height 768 -width 600] 
  .c create image 300 384 -image $im -tag im
  .c bind im <Button-1> {puts [$im get %x %y]}
}
