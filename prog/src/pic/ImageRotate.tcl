# ~/Biblepix/prog/src/setup/ImageRotate.tcl
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Procs for rotating picture, called by SetupRotate
# with many thanks to Richard Suchenwirth!
# from: https://wiki.tcl-lang.org/page/Photo+image+rotation
# Updated: 19sep2020 pv

proc makeRotateTopwin {} {
  global picdir C

#Picture & buttons
      source $picdir/ImageRotate.tcl

      toplevel .rotateW -width 600 -height 400
 
      button .rotateW.okBtn -text "Vorschau berechnen"
      button .rotateW.cancelBtn -text Abbruch -command {destroy .rotateW; return 0}
      
      set angle 1
      button .rotateW.saveBtn -text Abspeichern -command "image_rotate photosOrigPic $angle"
           
     catch  {  canvas $C -width 600 -height 400}
      $C create image 0 0 -image photosCanvPic -anchor nw
      
     
  #Meter
  source $picdir/ImageAngle.tcl      
  pack .rotateW.rotateC .rotateW.okBtn .rotateW.cancelBtn .rotateW.saveBtn
  pack [makeMeter]
  #scale
  pack [scale $s -orient h -length 300 -from -90 -to 90 -variable v]
  trace variable v w updateMeter
  updateMeterTimer
  
    set im photosCanvPic
    set im2 [image create photo]
    $im2 copy $im
    set C .rotateW.rotateC
    
$C create image 50  90 -image $im
$C create image 170 90 -image $im2
entry $C.e -textvar angle -width 4
    set angle 99
    bind $C.e <Return> {
        $im2 config -width [image width $im] -height [image height $im]
        $im2 copy $im
        wm title . [time {image_rotate $im2 $::angle}]
    }
$C create window 5 5 -window $C.e -anchor nw
    checkbutton $C.cb -text Update -variable update
    set ::update 1
    $C create window 40 5 -window $C.cb -anchor nw

    bind . <Escape> {exec wish $argv0 &; exit}

} ;#END makeRotateTopwin

#.rotateW.okBtn conf -command "image_rotate photosCanvPic $::v"

proc image_rotate {img angle} {
  global C
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
          set r [expr {
            round($dx*($r0*$dy+$r1*$dy_)+$dx_*($r2*$dy+$r3*$dy_))
          }]
          set g [expr {
            round($dx*($g0*$dy+$g1*$dy_)+$dx_*($g2*$dy+$g3*$dy_))
          }]
          set b [expr {
            round($dx*($b0*$dy+$b1*$dy_)+$dx_*($b2*$dy+$b3*$dy_))
          }]
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
}
 
# rotateOrigPic
##called by .rotateW.okBtn
##Bild wird in Funktion 'rotateOrigPic' geklont zur Weiterbearbeitung in setupResize/setupRepos
proc rotateOrigPic {img} {
  global v
  set rotatedOrigPic [image_rotate $img $v]
  #Create function from var
  image create photo rotateOrigPic
  rotateOrigPic copy $rotatedOrigPic
}

