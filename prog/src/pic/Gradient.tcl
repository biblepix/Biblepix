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

#############################################################################
# H S V   m a n i p u l a t e   s a t u r a t i o n   +   b r i g h t n e s s

## The -s option manipulates the saturation:
## a value less than 1.0 reduces the saturation,
## a value greater than 1.0 increases the saturation.

## The -v option manipulates the brightness:
##a value less than 1.0 reduces the brightness,
##a value greater than 1.0 increases the brightness.

##It works by computing and manipulating the HSV components then coming back to RGB.
##KPV For further information, check out Adventures in HSV Space 

################################################################################

namespace eval ::hsv {
    namespace export hsv
    
#variable colour $::colour

    proc hsv args {
        # check args
        if {[llength $args] < 1 || [llength $args] % 2 == 0} {
            return -code error {wrong # args: should be "hsv ?-s saturation? ?-v value?" image}
        }

        set image [lindex $args end]

        foreach {key value} [lrange $args 0 end-1] {
            switch -glob -- $key {
                -s* {
                    if {abs($value - 1.0) > 1.e-5} {
                        set options(saturation) $value
                    }
                }
                -v* {
                    if {abs($value - 1.0) > 1.e-5} {
                        set options(value) $value
                    }
                }
                default {
                    return -code error [format {unknown option "%s": should be -s or -v} $key]
                }
            }
        }

        if {![info exists options(saturation)] && ![info exists options(value)]} {
            return $image
        }

        # get the old image content
        set width [image width $image]
        set height [image height $image]
        if {$width * $height == 0} {
            return -code error "bad image"
        }

        # create corresponding planes
        for {set y 0} {$y < $height} {incr y} {
            set row2 {}

            for {set x 0} {$x < $width} {incr x} {

                foreach {rgb(r) rgb(g) rgb(b)} [$image get $x $y] break

                # convert to HSV
                set min [expr {min($rgb(r), $rgb(g), $rgb(b))}]
                set max [expr {max($rgb(r), $rgb(g), $rgb(b))}]
                set v $max
                set delta [expr {$max - $min}]
                if {$max == 0 || $delta == 0} {
                    set s 0
                    set h -1
                } else {
                    set s [expr {$delta / double($max)}]
                    if {$rgb(r) == $max} {
                        set h [expr {0.0   + ($rgb(g) - $rgb(b)) * 60.0 / $delta}]
                    } elseif {$rgb(g) == $max} {
                        set h [expr {120.0 + ($rgb(b) - $rgb(r)) * 60.0 / $delta}]
                    } else {
                        set h [expr {240.0 + ($rgb(r) - $rgb(g)) * 60.0 / $delta}]
                    }
                }
                if {$h < 0.0} {
                    set h [expr {$h + 360.0}]
                }
                # manipulate HSV components
                if {[info exists options(saturation)]} {
                    set s [expr {$s * $options(saturation)}]
                }
                if {[info exists options(value)]} {
                    set v [expr {$v * $options(value)}]
                }
                # convert to RGB
                if {$s == 0} {
                    foreach c {r g b} {
                        set rgb($c) [expr {int($v)}]
                    }

                } else {
                    set f [expr {$h / 60.0}]
                    set i [expr {int($f)}]
                    set f [expr {$f - $i}]
                    set p [expr {$v * (1 - $s)}]
                    set q [expr {$v * (1 - $s * $f)}]
                    set t [expr {$v * (1 - $s * (1 - $f))}]
                    set vals [subst [lindex {
                        {$v $t $p}
                        {$q $v $p}
                        {$p $v $t}
                        {$p $q $v}
                        {$t $p $v}
                        {$v $p $q}
                    } $i]]
                    foreach c {r g b} v $vals { 
                        set v [expr {int($v)}] 
                        if {$v < 0} {
                            set rgb($c) 0
                        } elseif {$v > 255} {
                            set rgb($c) 255
                        } else {
                            set rgb($c) $v
                        }
                    }
                }
                lappend row2 [format #%02x%02x%02x $rgb(r) $rgb(g) $rgb(b)]
            }
            lappend data2 $row2
        }
        # create the new image
        set image2 [image create photo]
        # fill the new image
        $image2 put $data2
        # return the new image
        return $image2
    }
}


#HSV Demo for above proc
##args should be -v (for brightness) OR -s (for saturation)
##arguments less than 1.0 reduces value
##adapted by pv for bitmap (single colour tests)
proc hsv-demo {colour args} {
  package require Img

  image create photo Photo
  Photo conf -width 50 -height 50
  Photo put $colour -to 0 0 50 50
  
  # -file /home/pv/Biblepix/prog/src/pic/SamplePhotos/eire.jpg

  namespace import ::hsv::hsv
  wm withdraw .
  catch {toplevel .t}
  wm title .t hsv
  catch {canvas .t.c -bd 0 -highlightt 0}
  .t.c conf -bg
  
  set h [image height Photo]
  set w [image width Photo]
  set x() 0
  set y() 0
  set x(-v) $w
  set y(-v) 0
  set x(-s) [expr {2 * $w}]
  set y(-s) 0
  foreach args {{} {-v 0.5} {-v 1.5} {-s 0.5} {-s 1.5}} {
      set image [hsv {*}$args Photo]
      set k [lindex $args 0]
      .t.c create text $x($k) $y($k) -anchor nw -text "Options: $args"
      .t.c create image $x($k) [incr y($k) 20] -anchor nw -image $image
      incr y($k) $h
  }
  lassign [.t.c bbox all] - - width height
  .t.c config -width $width -height $height
  pack .t.c
  bind .t.c <Destroy> exit
}
