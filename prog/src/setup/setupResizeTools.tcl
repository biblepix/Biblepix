# ~/Biblepix/prog/src/setup/setupResizeTools.tcl
# Procs used in Resizing + Repositioning processes
# sourced by SetupPhotos & ???
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 25nov20 pv

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

# fitPic2Canv
##fits ill-dimensioned photo into screen-dimensioned canvas, hiding over-dimensioned side
##called by setupResizePhoto for .resizePhoto.resizeCanv & .reposPhoto.reposCanv
##returns cutX + cutY
proc fitPic2Canv {c} {
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width $addpicture::curPic]
  set imgY [image height $addpicture::curPic]

  #TODO nur canvas hat korrekte Dimensionen
  set canvImgName [lindex [$c itemconf img -image] end]

  set canvImgX [image width $canvImgName]
  set canvImgY [image height $canvImgName]

  set screenFactor [expr $screenX. / $screenY]
  set origImgFactor [expr $imgX. / $imgY]

  $c conf

  ##zu hoch
  if {$origImgFactor < $screenFactor} {
    puts "Cutting height.."
    set canvCutY [expr round($canvImgX / $screenFactor)]
    set canvCutX [expr round($canvCutY * $screenFactor)]

  ##zu breit
  } elseif {$origImgFactor > $screenFactor} {
    puts "Cutting width.."
    set canvCutX [expr round($canvImgX / $screenFactor)]
    set canvCutY $canvImgY

  ##no cutting needed
  } else  {
    set canvCutX $imgX
    set canvCutY $imgY
  }

  return "$canvCutX $canvCutY"

} ;#END fitPic2Canv

# setpic2CanvScalefactor
##sets scale factor in 'addpicture' namespace
##for largest possible display size
##called by ?addPic & openResizeWindow & openReposWindow
proc setPic2CanvScalefactor {} {
#  if ![namespace exists addpicture] {
#      
#  }
  
#  #Check which original pic to use
#  if [catch {image inuse rotateOrigPic}] {
#    set origPic photosOrigPic
#  } else {
#    set origPic rotateOrigPic
#  }

#this var is set by addPic
set origPic $addpicture::curPic

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set imgX [image width $origPic]
  set imgY [image height $origPic]

  set maxX [expr $screenX - 200]
  set maxY [expr $screenY - 200]

  ##Reduktionsfaktor ist Ganzzahl
  set scaleFactor 1
  while { $imgX >= $maxX && $imgY >= $maxY } {
    incr scaleFactor
    set imgX [expr $imgX / 2]
    set imgY [expr $imgY / 2]
  }

  #export scaleFactor to 'addpicture' namespace
  set addpicture::scaleFactor $scaleFactor

} ;#END setPic2CanvScalefactor


#setupResizeHandler
##called by SetupResize
namespace eval ResizeHandler {
 #TODO Joel export ist nicht nötig, wenn Prog mit namespace-Pfad aufgerufen wird
  namespace export QueryResize
  namespace export Run

  variable queryCutImgJList ""
  variable counter 0
  variable isRunning 0

  proc QueryResize {cutImg} {
    variable queryCutImgJList
    variable counter
    set queryCutImgJList [jappend $queryCutImgJList $cutImg]
    incr counter
  }

  proc Run {} {
    variable queryCutImgJList
    variable counter
    variable isRunning

    if {$counter > 0} {
      if {!$isRunning} {
        set isRunning 1
        set cutImg [jlfirst $queryCutImgJList]
        set queryCutImgJList [jlremovefirst $queryCutImgJList]
        incr counter -1
        processResize $cutImg
        ResizeHandler::FinishRun
      }
    }
  }

  proc FinishRun {} {
    variable isRunning
    set isRunning 0
    ResizeHandler::Run
  }
}

# doResize
## organises all resizing processes
## called by openResizeWindow
proc doResize {c} {
  global addpicture::scaleFactor
  global addpicture::curPic

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set screenFactor [expr $screenX. / $screenY]

  set imgX [image width $curPic]
  set imgY [image height $curPic]
  set imgFactor [expr $imgX. / $imgY]
  
  #A) needs even resizing
  if {$screenFactor == $imgFactor} {
    set cutImg $curPic

  #B) needs cutting + resizing
  } else {
  
    lassign [$c bbox img] canvPicX1 canvPicY1 canvPicX2 canvPicY2
    set cutX1 [expr int($canvPicX1 * -1 * $scaleFactor)]
    set cutY1 [expr int($canvPicY1 * -1 * $scaleFactor)]
    set cutX2 [expr int($canvPicX2 * $scaleFactor + $cutX1)]
    set cutY2 [expr int($canvPicY2 * $scaleFactor + $cutY1)]
    set cutImg [trimPic $curPic $cutX1 $cutY1 $cutX2 $cutY2]
  
  #unsetting needed for openReposWindow
#    namespace eval addpicture {
#      unset curPic
#    }

  }
  

  # Send (cut) pic to final resizing
  ResizeHandler::QueryResize $cutImg
  after idle {
    ResizeHandler::Run
  }
  
} ;#END doResize

# processResize
##resizes $cutpic , (re)saves to disk & rewrites addpicture::curPic var
##called by ResizeHandler::Run
proc processResize {cutImg} {
  global dirlist picPath SetupResizePhoto

source $SetupResizePhoto

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]

  NewsHandler::QueryNews "$::resizingPic" orange

  #Save finalImage, copy to cutOrigPic for further processing
  set finalImage [resizePic $cutImg $screenX $screenY]



#TODO try this is great - but thy is the canvas pic so small?
openReposWindow $finalImage
return 


  image create photo cutOrigPic
  cutOrigPic copy $finalImage

  ##update addpicture current pic var
  set addpicture::curPic $finalImage

# set new var for vwait in SetupResizePhoto
  set addpicture::resizedPic $finalImage
  
  $finalImage write $addpicture::targetPicPath -format PNG

#TODO WHY THIS?
#  image delete $finalImage

  NewsHandler::QueryNews "[copiedPicMsg $picPath]" lightblue

} ;#END processResize
