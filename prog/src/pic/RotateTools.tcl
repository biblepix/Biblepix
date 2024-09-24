# ~/Biblepix/prog/src/setup/RotateTools.tcl
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Procs for rotating picture, called by SetupRotate
# Updated: 15feb23 pv

# imageRotate
##with many thanks to Richard Suchenwirth!
##from: https://wiki.tcl-lang.org/page/Photo+image+rotation
##added 'update' variable to be set to 1 or 0 for GUI to update during process
##called by SetupRotate
proc imageRotate {img angle update} {
  set rotatedImg [image create photo]
  set angle [expr {fmod($angle, 360.0)}]

  if {$angle < 0} {set angle [expr {$angle + 360.0}]}
  if {$angle} {
    set w [image width  $img]
    set h [image height $img]
    set buf {}
 
    if {$angle == 90} {

      # This would be easier with lrepeat
      set row {}
      for {set i 0} {$i<$h} {incr i} {
        lappend row "#000000"
      }
      for {set i 0} {$i<$w} {incr i} {
        lappend buf $row
      }

      set i $h
      foreach row [$img data] {
        set j 0
        incr i -1
        foreach pixel $row {
          lset buf $j $i $pixel
          incr j

        }      
      }

      $rotatedImg config -width $h -height $w
      $rotatedImg put $buf
    
    } elseif {$angle == 180} {
    
      $rotatedImg copy $img -subsample -1 -1
    
    } elseif {$angle == 270} {
    
      # This would be easier with lrepeat
      set row {}
      for {set i 0} {$i<$h} {incr i} {
        lappend row "#000000"
      }

      for {set i 0} {$i<$w} {incr i} {
        lappend buf $row
      }

      set i 0
      foreach row [$img data] {
        set j $w
        foreach pixel $row {
          incr j -1
          lset buf $j $i $pixel
        }

        incr i
      }

      $rotatedImg config -width $h -height $w
      $rotatedImg put $buf
    
    } else {

      set angle [expr 360 - $angle]
      set a   [expr {atan(1)*8*$angle/360.}]
      set xm  [expr {$w/2.}]
      set ym  [expr {$h/2.}]
      set w2  [expr {round(abs($w*cos($a)) + abs($h*sin($a)))}]
      set xm2 [expr {$w2/2.}]
      set h2  [expr {round(abs($h*cos($a)) + abs($w*sin($a)))}]
      set ym2 [expr {$h2/2.}]

      set rotatedImgUncut [image create photo]
      $rotatedImgUncut config -width $w2 -height $h2
      for {set i 0} {$i<$h2} {incr i} {

        set toX -1
        for {set j 0} {$j<$w2} {incr j} {
          set rad [expr {hypot($ym2-$i,$xm2-$j)}]
          set th  [expr {atan2($ym2-$i,$xm2-$j) + $a}]
          if {
            [set x [expr {$xm-$rad*cos($th)}]] < 0 || $x >= $w ||
            [set y [expr {$ym-$rad*sin($th)}]] < 0 || $y >= $h
          } then {
            continue
          }

          set x0 [expr {int($x)}]
          set x1 [expr {($x0+1)<$w? $x0+1: $x0}]
          set dx_ [expr {1.-[set dx [expr {$x1-$x}]]}]
          set y0 [expr {int($y)}]
          set y1 [expr {($y0+1)<$h? $y0+1: $y0}]
          set dy_ [expr {1.-[set dy [expr {$y1-$y}]]}]

          # This is the fastest way to get the data, because
          # in 8.4 [$photo get] returns a string and not a
          # list. This is horrible, but fast...
          scan "[$img get $x0 $y0] [$img get $x0 $y1]\
            [$img get $x1 $y0] [$img get $x1 $y1]" \
            "%d %d %d %d %d %d %d %d %d %d %d %d" \
            r0 g0 b0  r1 g1 b1  r2 g2 b2  r3 g3 b3
          set r [expr { round($dx*($r0*$dy+$r1*$dy_) + $dx_*($r2*$dy + $r3*$dy_)) }]
          set g [expr { round($dx*($g0*$dy+$g1*$dy_) + $dx_*($g2*$dy + $g3*$dy_)) }]
          set b [expr { round($dx*($b0*$dy+$b1*$dy_) + $dx_*($b2*$dy + $b3*$dy_)) }]
          lappend buf [format "#%02x%02x%02x" $r $g $b]
          if {$toX == -1} {
            set toX $j
          }
        }

        if {$toX>=0} {
          $rotatedImgUncut put [list $buf] -to $toX $i
          set buf {}
          if {$update} { update }
        }
      }
      
      set w3 [expr ($h * $w) / cos($a) / ($h + $w * abs(tan($a)))]
      set h3 [expr ($h * $h) / cos($a) / ($h + $w * abs(tan($a)))]

      set dw [expr $w2 - $w3]
      set dh [expr $h2 - $h3]

      set x1 [expr round($dw / 2)]
      set y1 [expr round($dh / 2)]
      set x2 [expr round($w2 - ($dw / 2))]
      set y2 [expr round($h2 - ($dh / 2))]

      $rotatedImg config -width [expr $x2 - $x1] -height [expr $y2 - $y1]
      $rotatedImg copy $rotatedImgUncut -from $x1 $y1 $x2 $y2
    }

  } else {
    $rotatedImg copy $img
  }

  return $rotatedImg

} ;#END imageRotate

########################################################################
############# E D G E   C U T T I N G   P R O C S  #####################
########################################################################

# vorschau
##called by SetupRotate
proc vorschau {im angle canv} {
  
	$::rotatepb start

  set rotatedImg [imageRotate photosCanvPic $angle 1]

  $im blank
  $im config -height [image height $rotatedImg] -width [image width $rotatedImg]
  $im copy $rotatedImg
  image delete $rotatedImg

  catch {$canv conf -height [image height $im] -width [image width $im]}

	$::rotatepb stop
}

# doRotateOrig
##coordinates rotating & cutting processes
##creates rotateOrigPic from photosOrigPic
##'update' variable must be 1 or 0, for updating GUI window during process
##called by SetupRotate Save button

setclsh
 proc doRotateOrig {pic angle update} {

  #get path of thumb
  set thumbpath [file join $canvpic::picdir $canvpic::curpic]
  image create photo origPic -file $thumbpath

  #1. rotate (takes a long time!)
  set rotatedOrigPic [imageRotate origPic $angle $update]

  #2. prepare for cutting and saving
  namespace eval addpicture {
    variable curPic
  }
  set addpicture::curPic $rotatedOrigPic
}

######################################################
#### R O T A T E   M E T E R   T O O L S #############
######################################################
##### with many thanks to Kevin Kenny! ###############  

# Create a meter 'enabled' canvas
proc makeMeter {} {
  global meter angle mC
  
  set meter [$mC create line 100 100 10 100 -fill black -width 3 -arrow last]

  $mC lower $meter
  updateMeterLine $mC 0.5
  
  $mC create arc 10 10 190 190 -start 60 -extent 60 -style arc -outline red -tags arc
  return $mC
}

# Draw a meter line
proc updateMeterLine {w a} {
  global meter pi
  set x [expr {100.0 - 90.0*cos(($a + 1) / 3 * $pi)}]
  set y [expr {100.0 - 90.0*sin(($a + 1) / 3 * $pi)}]
  catch { $w coords $meter 100 100 $x $y }
}

# Convert variable to angle on trace
proc updateMeter {name1 name2 op} {
  global mC from to
  upvar #0 $name1 v
  set min $from 
  set max $to
  set pos [expr {($v - $min) / ($max - $min)}]
  updateMeterLine $mC [expr {$pos}]
}

proc updateAngle {name1 name2 op} {
  upvar #0 $name1 v
  set rotatepic::angle $v
}
