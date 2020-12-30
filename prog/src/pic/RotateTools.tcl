# ~/Biblepix/prog/src/setup/RotateTools.tcl
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Procs for rotating picture, called by SetupRotate
# Updated: 24oct20

# imageRotate
##with many thanks to Richard Suchenwirth!
##from: https://wiki.tcl-lang.org/page/Photo+image+rotation
##called by SetupRotate
proc imageRotate {img angle} {
  set ::update 0
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
      $rotatedImg config -width $w2 -height $h2
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
          $rotatedImg put [list $buf] -to $toX $i
          set buf {}
          if {$::update} { update }
        }
      }
    }
  } else {
    $rotatedImg copy $img
  }

  return $rotatedImg

} ;#END imageRotate

########################################################################
############# E D G E   C U T T I N G   P R O C S  #####################
########################################################################

set void {#000000}
set offsetMargin 3 ;#where to start scanning

# getImgCorners
##called by cutRotateOrigPic
proc getImgCorners {im} {
  set dataL [$im data]
  set v [scanVertical $dataL]
  set h [scanHorizontal $dataL]
  return "$h $v"
}

# scanVertical
##called by getImgCorners
proc scanVertical {dataL} {
  global void offsetMargin
  set rowNo 0
  
  foreach row $dataL {
    set colour [lindex $row $offsetMargin]
    if {$colour == $void} {
      incr rowNo
    } else {
      return $rowNo
    }
  }
}

# scanHorizontal
##called by getImgCorners
proc scanHorizontal {dataL} {
  global void offsetMargin

  set row [lindex $dataL $offsetMargin]

  for {set i 0} {$i < [llength $row]} {incr i} {
    if {[lindex $row $i] != "$void"} {
      return $i
    }
  }
}

# cutRotated
##cuts uneven sides & returns as new $im
##called by ??? for rotateCanvPic & rotateOrigPic
proc cutRotated {im} {
  global offsetMargin

  #get horizontal & vertical points
  lassign [getImgCorners $im] h v
puts "h:$h v:$v"

  #Skip cutting if corners are "0 0"
  if !{$h} {
    return $im
  }

  #Prepare edge points for cutting
  set imH [image height $im]
  set imW [image width $im]

  #TODO not perfect yet - Joel please help!!!!!!!!!!!
  if {$h < $v} {
    ##Rechtsdrehung
    set x1 $h
    set y1 [expr ($imH - $v) /2]
    set x2 [expr $imW - $h]
    set y2 $v
  } {
    ##Linksdrehung
    set x1 [expr $imW - $h]
    set y1 $v
    set x2 [expr $imW - ($imW - $h)]
    set y2 [expr $imH - $v]
  }

puts "$x1.$y1 $x2.$y2"

  #Recreate rotateCutPic
  set rotateCutPic [image create photo]
  $rotateCutPic copy $im -from $x1 $y1 $x2 $y2
  
  return $rotateCutPic

} ;#end cutRotated

# vorschau
##called by SetupRotate
proc vorschau {im v c} {
  set rotatedImg [imageRotate photosCanvPic $v]
  
  $im blank
  $im copy $rotatedImg
  image delete $rotatedImg
  
#TODO why isn't this working?
  $c conf -height [image height $im] -width [image width $im]
  return 0
}

# doRotateOrig
##coordinates rotating & cutting processes
##creates rotateOrigPic from photosOrigPic
##called by SetupRotate Save button
proc doRotateOrig {pic v} {
  namespace eval addpicture {
    set rotated 1
  }

  #1. rotate (takes a long time!)
  set rotPic [imageRotate $pic $v]

  #2. cut and save
  set addpicture::curPic [cutRotated $rotPic]
}

######################################################
#### R O T A T E   M E T E R   T O O L S #############
######################################################
##### with many thanks to Kevin Kenny! ###############  

# Create a meter 'enabled' canvas
proc makeMeter {} {
  global meter angle mC
        
  for {set i 0;set j 0} {$i<100} {incr i 5;incr j} {
    set meter($j) [$mC create line 100 100 10 100 -fill grey$i -width 3 -arrow last]
  
    set angle($j) 0
    $mC lower $meter($j)
    updateMeterLine $mC 0.2 $j
  }
  $mC create arc 10 10 190 190 -start 0 -extent 180 -style arc -outline red -tags arc
  return $mC
}

# Draw a meter line (and recurse for lighter ones...)
proc updateMeterLine {w a {l 0}} {
  global meter angle pi
  set oldangle $angle($l)
  set angle($l) $a
  set x [expr {100.0 - 90.0*cos($a * $pi)}]
  set y [expr {100.0 - 90.0*sin($a * $pi)}]
  catch {     $w coords $meter($l) 100 100 $x $y }
  incr l
  if [info exist meter($l)] {
    catch {updateMeterLine $w $oldangle $l}
  }
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

# Fade over time
proc updateMeterTimer {} {
  global v
  set v $v
  after 20 updateMeterTimer
} 
