# ~/Biblepix/prog/src/setup/setupResizeTools.tcl
# Procs used in Resizing + Repositioning processes
# sourced by SetupPhotos & ???
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 18feb21 pv

# needsResize
##compares photosOrigPic OR rotateOrigPic with screen dimensions
##called by addPic
proc needsResize {pic} {
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width $pic]
  set imgY [image height $pic]

  #Compare img dimensions with screen dimensions
  if {$screenX == $imgX && $screenY == $imgY} {
  #perfect size
    return 0

  #>doResize
  } else {

    set screenX [winfo screenwidth .]
    set screenY [winfo screenheight .]
    set imgX [image width $pic]
    set imgY [image height $pic]
    set imgFactor [expr $imgX. / $imgY]
    set screenFactor [expr $screenX. / $screenY]

    ##only even resizing needed > open repos window
    if {$screenFactor == $imgFactor} {
      return even
    ##cutting + resizing needed > open resize window
    } else {
      return uneven
    }
  }
} ;#END needsResize

# grabCanvSection
##berechnet resizeCanvPic Bildausschnitt für Kopieren nach reposCanvSmallPic
##called by addPic & ?processPngInfo?
proc grabCanvSection {c} {
  lassign [$c bbox img] imgX1 imgY1 imgX2 imgY2
  set canvX [lindex [$c conf -width] end]
  set canvY [lindex [$c conf -height] end]

  set cutX1 0
  set cutY1 0
  set cutX2 $canvX
  set cutY2 $canvY

  ##alles gleich
  if {$imgX2 == $canvX &&
      $imgY2 == $canvY
  } {
    puts "No need for cutting."
    return 0
  }

  ##Breite ungleich
  if {$imgX2 > $canvX} {

    puts "Breite verschieben"
    if {$imgX1 < 0} {
      set cutX1 [expr $imgX1 - ($imgX1 + $imgX1) ]
      set cutX2 [expr $canvX + $cutX1]

    ##nach rechts verschoben
    } else {
      set cutX1 0
      set cutX2 $canvX
    }

  ##Höhe ungleich
  } elseif {$imgY2 > $canvY} {

    puts "Höhe verschieben"
    if {$imgY1 < 0} {
      set cutY1 [expr $imgY1 - ($imgY1 + $imgY1) ]
      set cutY2 [expr $canvY + $cutY1]

    ##nach unten verschoben
    } else {
      set cutY1 0
      set cutY2 $canvY
    }
  }
  return "$cutX1 $cutY1 $cutX2 $cutY2"
} ;#END grabCanvSection

# getCanvSizeFromPic
## return the size of the canvas in ratio to screensize
##returns canvX + canvY
##called by setupResizePhoto for resizeCanv & reposCanv
proc getCanvSizeFromPic {pic} {
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set screenFactor [expr $screenX. / $screenY]

  #Get image dimensions
  set imgX [image width $pic]
  set imgY [image height $pic]
  ##if above remain empty (whyever!), do this:
  if {!$imgX || !$imgY} {
    if [namespace exists resizePic] { 
    set canv $resizePic::c
  } elseif [namespace exists reposPic] {
    set canv $reposPic::canv
  }
  lassign [$canv bbox img] {} {} imgX imgY
  }
  
  puts "$imgX $imgY"
 
  set imgFactor [expr $imgX. / $imgY]

  ##zu hoch
  if {$imgFactor < $screenFactor} {
    puts "Cutting height.."
    set canvX $imgX
    set canvY [expr round($imgX / $screenFactor)]

  ##zu breit
  } elseif {$imgFactor > $screenFactor} {
    puts "Cutting width.."
    set canvX [expr round($imgY * $screenFactor)]
    set canvY $imgY

  ##no cutting needed
  } else  {
    set canvX $imgX
    set canvY $imgY
  }

  return "$canvX $canvY"
} ;#END getCanvSizeFromPic

# setCanvasFontSize
##changes canvas font's size||weight||family on intTextCanv + textposCanv
##called by SetupDesktop 
proc setCanvasFontSize args {
  ##size
  if [string is integer $args] {
    #set size in pt as in BDF
    font conf intCanvFont -size $args
    font conf movingTextFont -size [expr round($args / 3) + 3]
    set ::fontsize $args
  ##weight
  } elseif {$args == "bold" || $args == "normal"} {
    font conf intCanvFont -weight $args
    font conf movingTextFont -weight $args
    set ::fontweight $args
  ##family
  } elseif {$args == "Serif" || $args == "Sans"} {
    font conf intCanvFont -family $args
    font conf movingTextFont -family $args
    set ::fontfamily $args
  }
  return 0
}

# setCanvasFontColour
##changes canvas' font's colour in Hex
##shades got from setFontShades
##args = luminacy, as needed for textPosCanv
##called by SetupDesktop for inttextCanv & SetupResize for .textposCanv
proc setCanvasFontColour {c fontcolortext args} {
  global sunFactor shadeFactor
  #global colour::${fontcolortext}
  # variable colour::$fontcolortext
   
   #TODO do we need this? 
  #set luminance = 2 if no args
  if {$args == ""} {
    set lum 2
  } {
    set lum $args
  }
  
  
  #TODO use proc...
  lassign [setFontShades $fontcolortext] regHex sunHex shaHex
#  set regHex [set "colour::$fontcolortext"]
#  set sunHex [gradient $regHex $sunFactor]
#  set shaHex [gradient $regHex $shadeFactor]

  #fill canvas colours
  $c itemconf main -fill $regHex
  $c itemconf sun -fill $sunHex
  $c itemconf shade -fill $shaHex
  
  return 0
}

proc getResizeScalefactor {} {
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set maxCanvX [expr round([winfo width .] / 2.5)]
  set factor [expr floor($screenX. / $maxCanvX)]

  set canvX [expr round($screenX / $factor)]
  set canvY [expr round($screenY / $factor)]

  set imgX [image width $addpicture::curPic]
  set imgY [image height $addpicture::curPic]

  set factor [expr int(floor($imgX. / $canvX))]
  if {$factor > 0 && [expr $imgY / $factor] < $canvY} {
    set factor [expr int(floor($imgY. / $canvY))]
  }
  return $factor
}

proc getReposScalefactor {} {
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set maxCanvX [expr round([winfo width .] / 1.5)]
  set factor [expr ceil($screenX. / $maxCanvX)]

  set canvX [expr round($screenX / $factor)]
  set canvY [expr round($screenY / $factor)]

  set imgX [image width $addpicture::curPic]
  set imgY [image height $addpicture::curPic]

  set factor [expr int(ceil($imgX. / $canvX))]

  if {$factor > 0 && [expr $imgY / $factor] > $canvY} {
    set factor [expr int(ceil($imgY. / $canvY))]
  }
  return $factor
}

# doResize
## organises all resizing processes
## called by openResizeWindow
proc doResize {canv scaleFactor} {
  global dirlist picPath
  global addpicture::curPic

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set screenFactor [expr $screenX. / $screenY]

  set imgX [image width $curPic]
  set imgY [image height $curPic]
  set imgFactor [expr $imgX. / $imgY]

  set canvX [lindex [$canv conf -width] end]
  set canvY [lindex [$canv conf -height] end]
  
  #A) needs even resizing
  if {$screenFactor == $imgFactor} {
    set cutImg $curPic

  #B) needs cutting + resizing
  } else {
  
    lassign [$canv bbox img] canvPicX1 canvPicY1
    set cutX1 [expr int(max(($canvPicX1 * -1 * $scaleFactor), 0))]
    set cutY1 [expr int(max(($canvPicY1 * -1 * $scaleFactor), 0))]
    set cutX2 [expr int(min(($canvX * $scaleFactor + $cutX1), $imgX))]
    set cutY2 [expr int(min(($canvY * $scaleFactor + $cutY1), $imgY))]

    puts cutting
    puts "$canvPicX1, $canvPicY1"
    puts "$cutX1, $cutY1, $cutX2, $cutY2"

    set cutImg [trimPic $curPic $cutX1 $cutY1 $cutX2 $cutY2]
  }

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]

  NewsHandler::QueryNews "$::resizingPic" orange

  set finalImage [resizePic $cutImg $screenX $screenY]

  ##update addpicture current pic var
  set addpicture::curPic $finalImage

  $finalImage write $addpicture::targetPicPath -format PNG

  NewsHandler::QueryNews "[copiedPicMsg $picPath]" lightblue
  
  return $finalImage
} ;#END processResize
