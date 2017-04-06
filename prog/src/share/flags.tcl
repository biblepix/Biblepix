# ~/Biblepix/prog/src/share/flags.tcl
# Sourced by Setup
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 6apr2017

#Thanks to Richard Suchenwirth, wiki.tcl.tk
#Usage: flag::show canvas args    
# for example:
# flag::show .gb -flag {hori blue; x white red; cross white red}

 namespace eval flag {
    proc show {c args} {
        array set opt [concat {-x 0 -y 0 -w 0 -h 0 -flag {}} $args]
        foreach i {w h x y} {set $i [set opt(-$i)]}
        if {$w && !$h} {
            set h [expr $w/1.5]
        } elseif {$h && !$w} {
            set w [expr $h*1.5]
        } elseif {!$w && !$h} {
            set w 39; set h 26
        }
        foreach i [split $opt(-flag) ";"] {
            if [regexp " *set " $i] {eval $i}
        } ;# do changes in geometry before creation
        if ![winfo exists $c] {
            canvas $c -width $w -height $h -bg white -relief raised\
                -borderwidth 1
        }
        set b [$c cget -borderwidth]
        eval $opt(-flag)
        set c
    }
    proc circle color {
        upvar c c x x y y w w h h
        set r [expr $h*0.3]
        set xm [expr ($x+$w)/2]
        set ym [expr ($y+$h)/2+2]
        $c create oval [expr $xm-$r] [expr $ym-$r]\
            [expr $xm+$r] [expr $ym+$r] -fill $color -outline $color
    }
    proc hori args {
        upvar b b c c x x y y w w h h
        regsub -all {([A-Za-z0-9]+)[+]} $args {\1 \1} args
        set n [llength $args]
        set dy [expr $h/$n.]
        set y0 [expr $y+2+$b]
        foreach i $args {
            $c create rect $x $y0 [expr $x+$w+2*$b]\
                [expr round($y0+$dy)] -fill $i -outline $i
            set y0 [expr $y0+$dy]
        }
    }
    proc vert args {
        upvar c c x x y y w w h h
        regsub -all {([A-Za-z0-9]+)[+]} $args {\1 \1} args
        set n [llength $args]
        set dx [expr $w/$n.]
        set x0 [expr $x+2]
        foreach i $args {
            $c create rect $x0 $y [expr round($x0+$dx)] [expr $y+$w]\
                -fill $i -outline $i
            set x0 [expr $x0+$dx]
        }
    }
    proc cross args {
        upvar b b c c x x y y w w h h
        set x1 [expr $x+$b+$w*0.4]
        set x2 [expr $x+$b+$w*0.6]
        set y1 [expr $y+$h*0.4+2]
        set y2 [expr $h*0.6+1]
        foreach i $args {
            $c create rect $x $y1 [expr $x+$w+2*$b] $y2\
                -fill $i -outline $i
            $c create rect $x1 $y $x2 [expr $y+$h+2]\
                -fill $i -outline $i
            set x1 [expr $x1*1.1]
            set x2 [expr $x2/1.1]
            set y1 [expr $y1*1.1]
            set y2 [expr $y2/1.1]
        }
    }
    proc ncross args {
        upvar b b c c x x y y w w h h
        set y1 [expr $h*0.4+2]
        set y2 [expr $h*0.6]
        foreach i $args {
            $c create rect $x $y1 [expr $x+$w+2*$b] $y2\
                -fill $i -outline $i
            $c create rect $y1 $y $y2 [expr $y+$h+1]\
                -fill $i -outline $i
            set y1 [expr $y1*1.1]
            set y2 [expr $y2/1.1]
        }
    }
    proc scross color {
        upvar b b c c x x y y w w h h
        set x0 [expr $x+$h*0.2+2+$b]
        set x1 [expr $x+$h*0.4+2+$b]
        set x2 [expr $x+$h*0.6]
        set x3 [expr $x+$h*0.8]
        set y0 [expr $y+$h*0.2+2+$b]
        set y1 [expr $y+$h*0.4+2+$b]
        set y2 [expr $y+$h*0.6]
        set y3 [expr $y+$h*0.8]
        $c create rect $x0 $y1 $x3 $y2\
                -fill $color -outline $color
        $c create rect $x1 $y0 $x2 $y3\
                -fill $color -outline $color
    }
    proc x args {
        upvar c c x x y y w w h h
        set width [expr round($w/10.)]
        foreach i $args {
            $c create line $x [expr $y+2] [expr $x+$w] [expr $y+$h]\
                -fill $i -width $width
            $c create line $x [expr $y+$h] [expr $x+$w] [expr $y+2] \
                -fill $i -width $width
            set width [expr int($width/2.)]
        }
    }
    proc stars {n color} {#to be implemented}
    proc stripes {n c0 c1} {
        upvar b b c c x x y y w w h h
        set dy [expr $h/$n.]
        set y0 [expr $y+2+$b]
        for {set i 0} {$i<$n} {incr i} {
            set color [set c[expr $i%2]]
            $c create rect $x $y0 [expr $x+$w+2*$b] \
                [expr round($y0+$dy)]\
                -fill $color -outline $color
            set y0 [expr $y0+$dy]
        }
    }
    proc sun color {
        upvar b b c c x x y y w w h h
        set x0 [expr $x+$w/2.+2]
        set y0 [expr $y+$h/2.+2]
        set r [expr round($h/2.25)]
        $c create oval [expr $x0-$r/2.] [expr $y0-$r/2.]\
            [expr $x0+$r/2.] [expr $y0+$r/2.]\
            -fill $color
        foreach i [geom::sunrays $x0 $y0 $r] {
            eval $c create poly $i -fill $color
        }
    }
    proc tlq color {
        upvar b b c c x x y y w w h h
        set x1 [expr $x+$w/2]
        set y1 [expr $y+$b+$h/2]
        $c create rect $x $y $x1 $y1 -fill $color -outline $color
        set h [expr $y1-$y]
        set w [expr $x1-$x]
    }
    proc tlsq color {
        upvar b b c c x x y y w w h h
        set x1 [expr $x+$h/2]
        set y1 [expr $y+$b+$h/2]
        $c create rect $x $y $x1 $y1 -fill $color -outline $color
        set h [expr $y1-$y]
        set w [expr $x1-$x]
    }
    proc triangle color {
        upvar c c x x y y w w h h
        set x1 [expr sqrt(3*($h/2.)*($h/2.))]
        $c create poly $x $y $x1 [expr ($y+$h)/2.+2] $x [expr $y+$h+2]\
            -fill $color
    }
    proc left amount {upvar w w; set w [expr $w*$amount]}
    proc moon color {
        upvar b b c c x x y y w w h h
        set x0 [expr $x+$w/2.+2]
        set y0 [expr $y+$h/2.+2]
        set item [$c find closest $x0 $y0]
        set bg [$c itemcget $item -fill]
        set r [expr round($h/4.)]
        $c create oval [expr $x0-$r] [expr $y0-$r] \
            [expr $x0+$r] [expr $y0+$r] -fill $color -outline $color
        set x1 [expr $x0+$w/12.+1]
        set r [expr $r/1.25]
        $c create oval [expr $x1-$r] [expr $y0-$r] \
            [expr $x1+$r] [expr $y0+$r] -fill $bg -outline $bg
    }
 }


