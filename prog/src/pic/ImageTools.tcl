# ~/Biblepix/prog/src/pic/ImgTools.tcl
# Image manipulating procs
# Sourced by SetupGui & Image
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 16feb21 pv

#Check for Img package
if [catch {package require Img} ] {
  tk_messageBox -type ok -icon error -title "BiblePix Error Message" -message $packageRequireImg
  exit
}

#####################################################################
################ General procs ######################################
#####################################################################

proc getRandomBMP {} {
  #Ausgabe ohne Pfad
  set bmplist [getBMPlist]
  set randIndex [expr {int(rand()*[llength $bmplist])}]
  return [lindex $bmplist $randIndex]
}

proc getRandomPhotoPath	{} {
  #Ausgabe JPG/PNG mit Pfad
  global platform dirlist
  if {$platform=="unix"} {
    set imglist [glob -nocomplain -directory $dirlist(photosDir) *.jpg *.jpeg *.JPG *.JPEG *.png *.PNG]
  } elseif {$platform=="windows"} {
    set imglist [glob -nocomplain -directory $dirlist(photosDir) *.jpg *.jpeg *.png]
  }
  return [ lindex $imglist [expr {int(rand()*[llength $imglist])}] ] 
}

proc setPngFileName {fileName} {
  set fileExt [file extension $fileName]
  if {![regexp png|PNG $fileExt]} {
    set fileName "[file rootname $fileName].png"
  }
  return $fileName
}

proc calcAverage {list} {
  foreach n $list {
    incr sum $n
  }
  set avg [expr $sum / [llength $list]]
  return $avg
}

#############################################################
############### Colour procs ################################
#############################################################

# gradient - Abstufungen einer Standardfarbe von 100% (weiss) bis 0% (schwarz) 
##shadeens or sunens a given RGB hex value by $factor (0.1 - 1.0) 
##Copied from https://wiki.tcl-lang.org/page/Making+color+gradients
##with many thanks and God's blessings to Blaise Montandon
##called by setSun & setShade
proc gradient {rgbhex factor {window .}} {
  #this does the same as lassign [winfo...] r g b
  foreach {r g b} [winfo rgb $window $rgbhex] {break}
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
  set rgbhex \
      [format "#%.${len}X%.${len}X%.${len}X" \
           [expr {($r>$max)?$max:(($r<0)?0:$r)}] \
           [expr {($g>$max)?$max:(($g<0)?0:$g)}] \
           [expr {($b>$max)?$max:(($b<0)?0:$b)}]]

  ### Return the new rgb string
  return $rgbhex
} ;#END gradient

proc hex2rgb {hex} {
  lassign [scan $hex "#%2x %2x %2x"] r g b
  return "$r $g $b"
}

# setFontShades
##computes font shades according to luminance of background colour 
##returns 3 hex values: reg/sun/shade
##called by setCanvasFontColour & BdfPrint & createMovingTextBox
proc setFontShades {fontcolortext} {
  global sunFactor shadeFactor

  lappend colpath colour:: $fontcolortext
  variable fontcol $colpath
   
  #1)Determine colour arrays
  set regHex [set colour::$fontcolortext]
  puts $regHex
  set sunHex [gradient $regHex $sunFactor]
  set shaHex [gradient $regHex $shadeFactor]

  #Reset if PNG luminance info differs from 2
  if [info exists colour::pnginfo(Luminacy)] {
    set lum $colour::pnginfo(Luminacy)
    puts "Luminacy: $lum"
    
    if {$lum == 3} {
      set shaHex [gradient $shaHex $shadeFactor]
      set regHex [gradient $regHex $shadeFactor]
      set sunHex [gradient $sunHex $shadeFactor]
    ##sun
    } elseif {$lum == 1} {
      set sunHex [gradient $sunHex $sunFactor]
      set regHex [gradient $regHex $sunFactor]
      set shaHex [gradient $shaHex $sunFactor]
    }
  }
  #export hex values to colour:: ns (needed by printTwd)
  set colour::regHex $regHex
  set colour::sunHex $sunHex
  set colour::shaHex $shaHex
  
  return "$regHex $sunHex $shaHex"

} ;#END setFontShades


# getAreaLuminacy
##computes luminance 1-3 for canvas text section
##called by printTwd & SetupRepos
proc getAreaLuminacy {c item} {
  global colour::pnginfo brightThreshold darkThreshold
  
  puts "Scanning area for luminance..."
puts "Coords: $item"
  
  #Test if "c" is canvas (with .) or image
  if {[string index $c 0] == "."} {
    set object CANVAS
  } else {
    set object IMAGE 
  }

  if {$object == "CANVAS"} {
    #get image name from canvas
    set img [lindex [$c itemconf img -image] end]
    #for Biblepix/BdfPrint: check if pnginfo exists & return
    if [info exists pnginfo(Luminacy)] {
      set lum $pnginfo(Luminacy)
      return $lum
    }
  } elseif {$object == "IMAGE"} {
  
  #  set img $c
  set img hgbild
  }
  
  # Prepare scanning:
  ##for canvas
  if {$object == "CANVAS"} { 
    lassign [$c bbox $item] x1 y1 x2 y2
    set skip 2
  
  ##for image (bigger skip)
  } elseif {$object == "IMAGE"} {
    lassign $item x1 y1 x2 y2
    set skip 6
  }

  #scan given canvas/image area
  for {set yPos $y1} {$yPos < $y2} {incr yPos $skip} {

    for {set xPos $x1} {$xPos < $x2} {incr xPos $skip} {

      #add up r+g+b to sumTotal, dividing sum by 3 for each rgb
      lassign [$img get $xPos $yPos] r g b
      incr sumTotal [expr int($r + $g + $b)]
#  puts $sumTotal
      incr numCols 3
    }
  }

  set avLum [expr int($sumTotal / $numCols)]

proc dataRange {} {
#TODO neuersuch mit data - may have more overhead because of hex2rgb!!!!
set dataL [$img data]
set yRange [lrange [lindex $dataL $y1] [lindex $dataL $y2] ]
set xRange [lrange [lindex ... ??? 

set x2
set y2
foreach row $dataL {
  foreach pix $row {
    lassign [hex2rgb $pix] r g b
    incr avLumL [expr ($r + $g + $b) / 3]
  }
}

set avLum [expr $avLumL / [llength $avLumL]]
}
   
  ##very shade
  if {$avLum <= $darkThreshold} {
    set lum 1
  ##very sun
  } elseif {$avLum >= $brightThreshold} {
    set lum 3
  ##normal
  } else {
    set lum 2
  }
puts "Luminance $lum"
  return $lum
} ;#END getAreaLuminacy

################################################# 
# rgb2hex - OBSOLETE now!
#################################################
##computes r/g/b array into a hex digit
##called by LoadConfig etc.
proc rgb2hex {arrname} {
#  global BlackArr BlueArr GoldArr SilverArr GreenArr
  set level 1
  set cmd [upvar $level $arrname myarr]
  while [catch $cmd] {
    incr level
    $cmd
  }
  puts "Level $level"
puts [parray myarr]
puts [array get myarr]
puts $myarr(r)
puts $myarr(g)
puts $myarr(b)

  set hex [format "#%02x%02x%02x" $myarr(r) $myarr(g) $myarr(b)]
  return $hex
}


################################################################
################# Cutting procs ################################
################################################################

# trimPic
## Reduces pic size by cutting 1 or more edges
## pic must be a function or a variable
## called by doResize
proc trimPic {pic x1 y1 x2 y2} {
  set cutPic [image create photo]
  $cutPic copy $pic -from $x1 $y1 $x2 $y2 -shrink
  return $cutPic
}

# cropPic2Textwidth
##crops RtL image to text width
##works on basis of image data lists
##called by printTwd
proc cropPic2Textwidth {fontcolortext} {
  puts "Cropping text picture..."
  
  set fontcolHex [set colour::$fontcolortext]
puts $fontcolHex

  #read out textbild
  set dataL [textbild data]
  if {$dataL == ""} { return "No data for croppig found" }
  
##TODO testing
set chan [open /tmp/dataL w]
puts $chan "colour::regHex $fontcolHex"
puts $chan $dataL
close $chan
  
#  set empty {#000000}
  #Detect 1st pixel with fontcolour for each pixel line
  foreach row $dataL {
  
    
    set res [lsearch $row $fontcolHex]
    if {$res != "-1"} {
      lappend margL $res
      #puts "$res $fontcolHex"
    }
  }
  
  ##determine leftmost fontcolour pixel
  if {[info exists margL] && $margL != ""} {
    set margL [join $margL ,]
    set minleft [expr min($margL)]
  puts "Minleft $minleft"
  
  } else {
    return "Image not cropped"
  }

  #Recreate Cropbild
  image create photo cropbild
  cropbild copy textbild -from $minleft 0 [image width textbild] [image height textbild]
#TODO testing
cropbild write /tmp/cropbild.ppm
  
  textbild blank
  textbild copy cropbild -shrink
  textbild conf -width [image width cropbild]    
#  return "Created croppic"
} ;#END cropPic2Textwidth

# resizePic
## TODOS: CHANGE NAME? MOVE TO BACKGROUND!!!!
## called for even-sided resizing, after cutting
proc resizePic {src newx newy} { 

 #  Decsription:  Copies a source image to a destination
 #   image and resizes it using linear interpolation
 #
 #  Parameters:   newx   - Width of new image
 #                newy   - Height of new image
 #                src    - Source image
 #
 #  Returns:      destination image
 #  Author: David Easton, wiki.tcl.tk, 2004 - God bless you David, you have saved us a lot of trouble!

 ######## IDEAL FOR EVEN SIDED ZOOMING , else picture is distorted ##########

  set mx [image width $src]
  set my [image height $src]

  set dest [image create photo]

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

      update
    }

    set prevrow $thisrow
    set prow $row

    update
  }

  # Finish off last rows
  while { $ny < $newy } {
    $dest put -to 0 $ny [list $row]
    incr ny
  }
  update
  
  puts $dest
  return $dest
} ;#END resizePic
