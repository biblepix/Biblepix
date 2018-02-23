# ~/Biblepix/prog/src/gui/setupTools.tcl
# Image manipulating procs
# Called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 12feb18

source $JList

###### Procs for News handling ######################

namespace eval NewsHandler {
  namespace export QueryNews

  variable queryTextJList ""
  variable queryColorJList ""
  variable counter 0
  variable isShowing 0

  proc QueryNews {text color} {
    variable queryTextJList
    variable queryColorJList
    variable counter

    set queryTextJList [jappend $queryTextJList $text]
    set queryColorJList [jappend $queryColorJList $color]

    incr counter

    ShowNews
  }

  proc ShowNews {} {
    variable queryTextJList
    variable queryColorJList
    variable counter
    variable isShowing

    if {$counter > 0} {
      if {!$isShowing} {
        set isShowing 1

        set text [jlfirst $queryTextJList]
        set queryTextJList [jlremovefirst $queryTextJList]

        set color [jlfirst $queryColorJList]
        set queryColorJList [jlremovefirst $queryColorJList]

        incr counter -1

        .news configure -bg $color
        set ::news $text

        after 7000 {
          NewsHandler::FinishShowing
        }
      }
    }
  }

  proc FinishShowing {} {
    variable isShowing

    .news configure -bg grey
    set ::news "biblepix.vollmar.ch"
    set isShowing 0

    ShowNews
  }
}


###### Procs for SetupGUI + SetupDesktop ######################

# Set International Canvas Text
proc setIntCanvasText {fontcolor} {
  global inttextCanv internationaltext
  set rgb [hex2rgb $fontcolor]
  set shade [setShade $rgb]
  set sun [setSun $rgb]
  $inttextCanv itemconfigure main -fill $fontcolor
  $inttextCanv itemconfigure sun -fill $sun
  $inttextCanv itemconfigure shade -fill $shade
}

# Grey out all spinboxes if !$enablepic
proc setSpinState {imgyesState} {
global showdateBtn slideBtn slideSpin fontcolorSpin fontsizeSpin fontweightBtn fontfamilySpin
  if {$imgyesState} {
    set com normal
  } else {
    set com disabled
  }
  lappend widgetlist $showdateBtn $slideBtn $slideSpin $fontcolorSpin $fontsizeSpin $fontweightBtn $fontfamilySpin

  foreach i $widgetlist {
    $i configure -state $com
  }
}

# Grey out Slideshow spinbox if !enableSlideshow
proc setSlideSpin {state} {
global slideSpin slideTxt slideSec slideshow

     if {$state==1} {
         $slideSpin configure -state normal
    #set standard if changed from 0
    if {$slideshow==0} {
      set slideshow 300
    }
    $slideSpin set $slideshow
         $slideTxt conf -fg black
    $slideSec conf -fg black
  } else {
    $slideSpin configure -state disabled
    $slideSpin set 0
    $slideTxt conf -fg grey
    $slideSec conf -fg grey
  }
}

proc setFlags {} {
global Flags
  #Configure language flags
  source $Flags
  flag::show .en -flag {hori blue; x white red; cross white red}
  flag::show .de -flag {hori black red yellow}
  .en config -relief raised
  .de config -relief raised

  #Configure English button
  bind .en <ButtonPress-1> {
    set lang en
    setTexts en
    .manualF.man configure -state normal
    .manualF.man replace 1.1 end [setReadmeText en]
    .manualF.man configure -state disabled
    .en configure -relief flat
  }
  bind .en <ButtonRelease> { .en configure -relief raised}

  #Configure Deutsch button
  bind .de <ButtonPress-1> {
    set lang de
    setTexts de
    .manualF.man configure -state normal
    .manualF.man replace 1.1 end [setReadmeText de]
    .manualF.man configure -state disabled
    .de configure -relief flat
  }
  bind .de <ButtonRelease> { .de configure -relief raised}
}


# C A N V A S   M O V E   P R O C S

# dragCanvasItem
##called by movingTextBox & dlgCanvas
proc dragCanvasItem {c item newX newY} {
  ###adapted from a proc by ...THANKS TO  ...
  set xDiff [expr {$newX - $::x}]
  set yDiff [expr {$newY - $::y}]

  #test before moving
  if {[checkItemInside $c $item $xDiff $yDiff]} {
    $c move $item $xDiff $yDiff
  }
  set ::x $newX
  set ::y $newY
}

#TODO: VARIABELN FÜR movingTextBox anpassen
proc checkItemInside {c item xDiff yDiff} {
##called by dragCanvasItem

  lassign [$c bbox $item] - - can(maxx) can(maxy)
 
  set imgX [image width photosCanvPic]
  set imgY [image height photosCanvPic]
  set canvX [winfo width $c]
  set canvY [winfo height $c]
  
  set can(miny) 0
  set can(minx) 0
#  set can(maxy) [$c itemcget $item -height]
#  set can(maxx) [$c itemcget $item -width]

  if {$imgX > $canvX} {
    set can(minx) [expr $canvX - $imgX]
    set can(maxy) 0
    set can(maxx) 0
    
  } elseif {$imgY > $canvY} {
      
    set can(miny) [expr $canvY - $imgY]
    set can(maxy) 0
    set can(maxx) 0
  }

#item coords
  set item [$c coords $item]
  #check min values
  foreach {x y} $item {
    set x [expr $x + $xDiff]
    set y [expr $y + $yDiff]
    if {$x < $can(minx)} {
      return 0
    }
    if {$y < $can(miny)} {
      return 0
    }
    if {$x > $can(maxx)} {
      return 0
    }
    if {$y > $can(maxy)} {
      return 0
    }
  }
  return 1
  }

proc createMovingTextBox {textposCanv} {
global marginleft margintop textPosFactor fontsize setupTwdText

  set screenx [winfo screenwidth .]
  set screeny [winfo screenheight .]

  set textPosSubwinX [expr $screenx/20]
  set textPosSubwinY [expr $screeny/30]
  set x1 [expr $marginleft/$textPosFactor]
  set y1 [expr $margintop/$textPosFactor]
  set x2 [expr ($marginleft/$textPosFactor)+$textPosSubwinX]
  set y2 [expr ($margintop/$textPosFactor)+$textPosSubwinY]

  $textposCanv create text [expr $marginleft/$textPosFactor] [expr $margintop/$textPosFactor] -anchor nw -justify left -tags {canvTxt mv}
  $textposCanv itemconfigure canvTxt -text $setupTwdText
  $textposCanv itemconfigure canvTxt -font "TkTextFont -[expr $fontsize/$textPosFactor]" -fill orange  -activefill red
  
  $textposCanv itemconfigure canvTxt -width 
}

##### S E T U P P H O T O S   P R O C S ####################################################

proc needsResize {} {
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]

  set imgX [image width photosOrigPic]
  set imgY [image height photosOrigPic]
  
  #Compare img dimensions with screen dimensions
  if {$screenX == $imgX && $screenY == $imgY} {
    return 0
  } else {
    return 1
  }
}

# addPic - called by SetupPhoto
# adds new Picture to BiblePix Photo collection
# setzt Funktion 'photosOrigPic' voraus und leitet Subprozesse ein
proc addPic {} {
  global picPath jpegDir
  
  set targetPicPath [file join $jpegDir [getPngFileName [file tail $picPath]]]
  
  if { [file exists $targetPicPath] } {
    NewsHandler::QueryNews $::picSchonDa lightblue
    return
  }
  
  if [needsResize] {
    source $::SetupResizePhoto
    openResizeWindow
  } else {
    photosOrigPic write $targetPicPath -format PNG
    NewsHandler::QueryNews "[copiedPic $picPath]" lightblue
  }
} ;#END addPic

proc delPic {} {
  global fileJList picPath
  file delete $picPath
  set fileJList [deleteImg $fileJList .imgCanvas]
  NewsHandler::QueryNews "[deletedPic $picPath]" red
}

proc doOpen {bildordner c} {
  set localJList [openFileDialog $bildordner]
  refreshImg $localJList $c

  if {$localJList != ""} {
    pack .addBtn -in .photosF.mainf.right.unten -side left -fill x
  }
  pack .picPath -in .photosF.mainf.right.unten -side left -fill x
  pack .photosF.mainf.right.bar.collect -side right -fill x
  pack forget .delBtn

  return $localJList
}

proc doCollect {c} {
  set localJList [refreshFileList]
  refreshImg $localJList $c

  pack .delBtn .picPath -in .photosF.mainf.right.unten -side left -fill x
  pack forget .addBtn .photosF.mainf.right.bar.collect

  return $localJList
}

proc step {localJList fwd c} {
  set localJList [jlstep $localJList $fwd]
  refreshImg $localJList $c

  return $localJList
}

proc openFileDialog {bildordner} {
  global types tcl_platform

  set storage ""
  set parted 0
  set localJList ""

  set selectedFile [tk_getOpenFile -filetypes $types -initialdir $bildordner]
  if {$selectedFile != ""} {
    set pos [string last "/" $selectedFile]
    set folder [string range $selectedFile 0 [expr $pos - 1]]

    if {$tcl_platform(os) == "Linux"} {
      set fileNames [glob -nocomplain -directory $folder *.jpg *.jpeg *.JPG *.JPEG *.png *.PNG]
    } elseif {$tcl_platform(platform) == "windows"} {
      set fileNames [glob -nocomplain -directory $folder *.jpg *.jpeg *.png]
    }

    foreach fileName $fileNames {
      if { [file exists $fileName] } {
        set localJList [jappend $localJList $fileName]
      } else {
        if {$parted} {
          append storage " " $fileName
          if { [file exists $storage] } {
            set parted 0
            set localJList [jappend $localJList $storage]
          }
        } else {
          set parted 1
          set storage $fileName
        }
      }
    }

    set fn [string range [jlfirst $localJList] [expr $pos + 1] end]
    set selectedFN [string range $selectedFile [expr $pos + 1] end]

    while {![string equal $fn $selectedFN]} {
      set localJList [jlstep $localJList 1]
      set fn [string range [jlfirst $localJList] [expr $pos + 1] end]
     }
  }

  return $localJList
}

proc refreshFileList {} {
  global tcl_platform jpegDir
  set storage ""
  set parted 0
  set localJList ""

  if {$tcl_platform(os) == "Linux"} {
    set fileNames [glob -nocomplain -directory $jpegDir *.jpg *.jpeg *.JPG *.JPEG *.png *.PNG]
  } elseif {$tcl_platform(platform) == "windows"} {
    set fileNames [glob -nocomplain -directory $jpegDir *.jpg *.jpeg *.png]
  }

  foreach fileName $fileNames {
    if { [file exists $fileName] } {
      set localJList [jappend $localJList $fileName]
    } else {
      if {$parted} {
        append storage " " $fileName
        if { [file exists $storage] } {
          set parted 0
          set localJList [jappend $localJList $storage]
        }
      } else {
        set parted 1
        set storage $fileName
      }
    }
  }

  return $localJList
}

proc refreshImg {localJList c} {
  global picPath

  set fn ""
  if {$localJList != ""} {
    set fn [jlfirst $localJList]
    openImg $fn $c
    } else {
      hideImg $c
  }
  set picPath $fn
}

# openImg - called by refreshImg
#Creates functions 'photosOrigPic' and 'photosCanvPic'
##to be processed by all other progs (no vars!)
proc openImg {imgFilePath imgCanvas} {
  global photosCanvMargin photosCanvX photosCanvY
  image create photo photosOrigPic -file $imgFilePath

  #scale photosOrigPic to photosCanvPic
  set imgX [image width photosOrigPic]
  set imgY [image height photosOrigPic]
  set factor [expr round(($imgX / $photosCanvX)+0.999999)]

  if {[expr $imgY / $factor] > $photosCanvY} {
    set factor [expr round(($imgY / $photosCanvY)+0.999999)]
  }

set ::OrigFactor $factor

  catch {image delete photosCanvPic}
  image create photo photosCanvPic

  photosCanvPic copy photosOrigPic -subsample $factor -shrink
  $imgCanvas create image $photosCanvMargin $photosCanvMargin -image photosCanvPic -anchor nw -tag img
}

proc hideImg {imgCanvas} {
  $imgCanvas delete img
}

proc deleteImg {localJList c} {
  global imgName

  set localJList [jlremovefirst $localJList]
  refreshImg $localJList $c

  if {$localJList == ""} {
    pack forget .delBtn
  }

  return $localJList
}


##### Procs for SetupWelcome ####################################################

proc fillWidgetWithTodaysTwd {twdWidget} {
  global Twdtools

  if {[info procs getRandomTwdFile] == ""} {
    source $Twdtools
  }

  set twdFileName [getRandomTwdFile]

  if {$twdFileName == ""} {
    $twdWidget conf -fg black -bg red
    $twdWidget conf -activeforeground black -activebackground orange
    set twdText $::noTwdFilesFound
  } else {
    if {[isRtL [getTwdLanguage $twdFileName]]} {
      $twdWidget conf -justify right
    } else {
      $twdWidget conf -justify left
    }

    set twdText [getTodaysTwdText $twdFileName]
  }

  $twdWidget conf -text $twdText
}
