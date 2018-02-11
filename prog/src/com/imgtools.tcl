# ~/Biblepix/prog/src/pic/imgtools.tcl
# Image manipulating procs
# Called by SetupGui & Image
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 9feb18

#Check for Img package
if { [catch {package require Img} ] } {
  tk_messageBox -type ok -icon error -title "BiblePix Error Message" -message $packageRequireImg
  exit
}

####### Procs for $Hgbild #####################

#called by setShade + setSun
proc rgb2hex {rgb} {
  set rgblist [split $rgb]
  set hex [format "#%02x%02x%02x" [lindex $rgblist 0] [lindex $rgblist 1] [lindex $rgblist 2] ]
  return $hex
}

#called by Hgbild
proc hex2rgb {hex} {
  set rgb [scan $hex "#%2x %2x %2x"]
  foreach i [split $rgb] {
    lappend rgblist $i
  }
  return $rgb
}

proc setShade {rgb} {
#called by ??? - now in Setup, var saved to Config!!! ????
  global shadefactor
  foreach c [split $rgb] {
    lappend shadergb [expr {int($shadefactor*$c)}]
  }
  #darkness values under 0 don't matter   
  set shade [rgb2hex $shadergb]
  return $shade
}

#called by Hgbild
proc setSun {rgb} {
  global sunfactor
  foreach c [split $rgb] {
    lappend sunrgbList [expr {int($sunfactor*$c)}]
  }

  #avoid brightness values over 255
  foreach i $sunrgbList {
    if {$i>255} {set i 255}
    lappend sunrgb $i
  }
  
  set sun [rgb2hex $sunrgb]
  return $sun
}

proc copyAndResizeSamplePhotos {} {
  global exaJpgArray
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
    
  foreach fileName [array names exaJpgArray] {
    set filePath [lindex [array get exaJpgArray $fileName] 1]
    image create photo origJpeg -file $filePath 
    set imgX [image width origJpeg]
    set imgY [image height origJpeg]

    #copy over as JPEG if size OK
    if {$screenX == $imgX && $screeny == $imgy} {
      file copy $fileName [join $jpegdir $fileName]

      } else {
    #else [resize] (no cutting intended)
      set newPic [resize $screenX $screenY origJpeg]
      set pngFileName [getPngFileName $fileName]
      $newPic write [join $jpegdir $pngFileName] -format PNG
    }
  }
} ;#END copyAndResizeSamplePhotos

proc getPngFileName {fileName} {
  if {![regexp png|PNG $fileName]} {
    set fileName "[file rootname $fileName].png"
  }
  return $fileName
}


# doResize
## called by addPic
## organises all resizing processes
proc doResize {c} {
  global jpegDir picPath screenFactor

  set targetPicPath [file join $jpegDir [getPngFileName [file tail $picPath]]]
  
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set origX [image width photosOrigPic]
  set origY [image height photosOrigPic]
  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]
  set canvX [lindex [$c conf -width] end]
  set canvY [lindex [$c conf -height] end]
  
  set screenFactor [expr $screenX. / $screenY]
  set enlargementFactor [expr $origX. / $canvX]
puts "Vergrösserung: $enlargementFactor"
 
 #2.CUT PIC TO CORRECT RATIO
  
  lassign [$c bbox img] canvPicX1 canvPicY1 canvPicX2 canvPicY2
  
  #1. check which edge shouldn't be touched
  
  ##a) pic too high: set fix X values
  if {$imgX == $canvX} {
  puts "imgX = canvX"
    set cutX1 0
    set cutX2 $origX
    
    #set pic specific required Y
    set reqY [expr round($origX / $screenFactor)]
    
    #Adapt Y values:
    #a)Pos oberer Rand
    if {$canvPicY1 == 0} {
    puts a
      set cutY1 0
      set cutY2 $reqY
      
    #b)Pos unterer Rand
      } elseif {[expr $imgY + $canvPicY1] == $imgY} {
      puts b
      set cutY1 [expr $origY - $reqY] 
      set cutY2 [expr $reqY + $cutY1]
    
    #c)Pos dazwischen       
      } else {
      puts c
      set Ydiff [expr 0 - $canvPicY1]
      set cutY1 [expr round($Ydiff * $enlargementFactor) ]
      set cutY2 [expr round($reqY - ($canvPicY1 * $enlargementFactor))]
      }
    #Adapt X alues:
    } elseif {$imgY == $canvY} {
  puts "imgY = canvY"
    set cutY1 0
    set cutY2 $origY
    
    #set pic specific required Y
    set reqX [expr round($origY * $screenFactor)]
    
   
    #a)Pos linker Rand
    if {$canvPicX1 == 0} {
    puts a
      set cutX1 0
      set cutX2 $reqX
      
    #b)Pos rechter Rand - TODO: GEHT NICHT EINWANDFREI
      } elseif {[expr $imgX + $canvPicX1] == $imgX} {
      puts b
      set cutX1 [expr $origX - $reqX] 
      set cutX2 [expr $reqX + $cutX1]
    
    #c)Pos dazwischen       
      } else {
      puts c
      set Xdiff [expr 0 - $canvPicX1]
      set cutX1 [expr round($Xdiff * $enlargementFactor) ]
      set cutX2 [expr round($reqX - ($canvPicX1 * $enlargementFactor))]
    }
  }
  
puts "ReqX: $reqX"
puts "Cuts: $cutX1 $cutY1 $cutX2 $cutY2"

 
  
#TEST1: UNVERGRÖSSERT
#  set cutImg [trimPic photosCanvPic $X1 $Y1 $X2 $Y2]
  
#TEST2: VERGRÖSSERT
  set cutImg [trimPic photosOrigPic $cutX1 $cutY1 $cutX2 $cutY2]
  
  $cutImg write /tmp/trimmed.bmp -format BMP
  return

#END TEST

#3. RESIZE PIC TO SCREEN SIZE
 set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  
  #2.resize pic to screen dimensions
  set finalImage [resize $cutImg $screenX $screenY]
  image delete $cutImg

  #3.Save new image to Photos directory
  $finalImage write $targetPicPath -format PNG
  image delete $finalImage

  NewsHandler::QueryNews "[copiedPic $picPath]" lightblue
} ;#END doResize

# trimPic - reduces $pic size by cutting 1 or 2 edges
## $pic must be a function or a variable
proc trimPic {pic x1 y1 x2 y2} {
  set cutPic [image create photo]
  $cutPic copy $pic -from $x1 $y1 $x2 $y2 -shrink
  return $cutPic
}

proc resize {src newx newy {dest ""} } { 
#Proc called for even-sided resizing, after cutting
 #  Decsription:  Copies a source image to a destination
 #   image and resizes it using linear interpolation
 #
 #  Parameters:   newx   - Width of new image
 #                newy   - Height of new image
 #                src    - Source image
 #                dest   - Destination image (optional)
 #
 #  Returns:      destination image
 #  Author: David Easton, wiki.tcl.tk, 2004 - God bless you David, you have saved us a lot of trouble!

 ######## IDEAL FOR EVEN SIDED ZOOMING ############# pv

  global resizingPic
  catch {NewsHandler::QueryNews "$resizingPic" orange}

  set mx [image width $src]
  set my [image height $src]

  if { "$dest" == ""} {
    set dest [image create photo]
  }
  
  $dest configure -width $newx -height $newy

  # Check if we can just zoom using -zoom option on copy
  if { $newx % $mx == 0 && $newy % $my == 0} {
    set ix [expr {$newx / $mx}]
    set iy [expr {$newy / $my}]
    $dest copy $src -zoom $ix $iy
    return $dest
  }

  set ny 0
  set ytot $my

  for {set y 0} {$y < $my} {incr y} {

    #
    # Do horizontal resize
    #

    foreach {pr pg pb} [$src get 0 $y] {break}

    set row [list]
    set thisrow [list]
    
    set nx 0
    set xtot $mx

    for {set x 1} {$x < $mx} {incr x} {
      # Add whole pixels as necessary
      while { $xtot <= $newx } {
        lappend row [format "#%02x%02x%02x" $pr $pg $pb]
        lappend thisrow $pr $pg $pb
        incr xtot $mx
        incr nx
      }

      # Now add mixed pixels

      foreach {r g b} [$src get $x $y] {break}

      # Calculate ratios to use

      set xtot [expr {$xtot - $newx}]
      set rn $xtot
      set rp [expr {$mx - $xtot}]

      # This section covers shrinking an image where
      # more than 1 source pixel may be required to
      # define the destination pixel

      set xr 0
      set xg 0
      set xb 0

      while { $xtot > $newx } {
        incr xr $r
        incr xg $g
        incr xb $b

        set xtot [expr {$xtot - $newx}]
        incr x
        foreach {r g b} [$src get $x $y] {break}
      }

      # Work out the new pixel colours

      set tr [expr {int( ($rn*$r + $xr + $rp*$pr) / $mx)}]
      set tg [expr {int( ($rn*$g + $xg + $rp*$pg) / $mx)}]
      set tb [expr {int( ($rn*$b + $xb + $rp*$pb) / $mx)}]

      if {$tr > 255} {set tr 255}
      if {$tg > 255} {set tg 255}
      if {$tb > 255} {set tb 255}

      # Output the pixel

      lappend row [format "#%02x%02x%02x" $tr $tg $tb]
      lappend thisrow $tr $tg $tb
      incr xtot $mx
      incr nx

      set pr $r
      set pg $g
      set pb $b
    }

    # Finish off pixels on this row
    while { $nx < $newx } {
      lappend row [format "#%02x%02x%02x" $r $g $b]
      lappend thisrow $r $g $b
      incr nx
    }

    #
    # Do vertical resize
    #

    if {[info exists prevrow]} {
      set nrow [list]

      # Add whole lines as necessary
      while { $ytot <= $newy } {
        $dest put -to 0 $ny [list $prow]

        incr ytot $my
        incr ny
      }

      # Now add mixed line
      # Calculate ratios to use

      set ytot [expr {$ytot - $newy}]
      set rn $ytot
      set rp [expr {$my - $rn}]

      # This section covers shrinking an image
      # where a single pixel is made from more than
      # 2 others.  Actually we cheat and just remove 
      # a line of pixels which is not as good as it should be

      while { $ytot > $newy } {
        set ytot [expr {$ytot - $newy}]
        incr y
        continue
      }

      # Calculate new row

      foreach {pr pg pb} $prevrow {r g b} $thisrow {
        set tr [expr {int( ($rn*$r + $rp*$pr) / $my)}]
        set tg [expr {int( ($rn*$g + $rp*$pg) / $my)}]
        set tb [expr {int( ($rn*$b + $rp*$pb) / $my)}]

        lappend nrow [format "#%02x%02x%02x" $tr $tg $tb]
      }

      $dest put -to 0 $ny [list $nrow]

      incr ytot $my
      incr ny
    }

    set prevrow $thisrow
    set prow $row

    update idletasks
  }

  # Finish off last rows
  while { $ny < $newy } {
    $dest put -to 0 $ny [list $row]
    incr ny
  }
  update idletasks

  return $dest
}
