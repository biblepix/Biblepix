# ~/Biblepix/prog/src/gui/setupTools.tcl
# Image manipulating procs
# Called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 30jan18

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
    .nb.manual.man configure -state normal
    .nb.manual.man replace 1.1 end [setReadmeText en]
    .nb.manual.man configure -state disabled
    .en configure -relief flat
  }
  bind .en <ButtonRelease> { .en configure -relief raised}

  #Configure Deutsch button
  bind .de <ButtonPress-1> {
    set lang de
    setTexts de
    .nb.manual.man configure -state normal
    .nb.manual.man replace 1.1 end [setReadmeText de]
    .nb.manual.man configure -state disabled
    .de configure -relief flat
  }
  bind .de <ButtonRelease> { .de configure -relief raised}
}


# C A N V A S   M O V E   P R O C S
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

  $textposCanv create text [expr $marginleft/$textPosFactor] [expr $margintop/$textPosFactor] -anchor nw -justify left -tags mv
  $textposCanv itemconfigure mv -text $setupTwdText
  $textposCanv itemconfigure mv -font "TkTextFont -[expr $fontsize/$textPosFactor]" -fill orange  -activefill red
}

proc movestart {w x y} {
    global X Y wt
    set X [$w canvasx $x]
    set Y [$w canvasy $y]
    set item [$w find withtag current]
    if [info exists wt(@$item)] {
        incr wt($wt(@$item)) -$wt($item)
        unset wt(@$item)
    }
}

proc move {w x y maxX maxY} {
  global photosCanvMargin

  proc + {a b} {expr {$a + $b}}
  proc - {a b} {expr {$a - $b}}

    set dx [- [$w canvasx $x] $::X]
    set dy [- [$w canvasx $y] $::Y]

    if {$dx < -2} {set dx -2}
    if {$dx > 2} {set dx 2}

    if {$dy < -2} {set dy -2}
    if {$dy > 2} {set dy 2}

  lassign [$w coords mv] subX1 subY1 subX2 subY2

  if {[+ $subX1 $dx] < [expr $photosCanvMargin / 2] } {set dx [expr $subX1 - ($photosCanvMargin / 2)]}
  if {[+ $subY1 $dy] < [expr $photosCanvMargin / 2] } {set dy [expr $subY1 - ($photosCanvMargin / 2)]}
  if {[+ $subX2 $dx] > [expr $maxX + (1.5 * $photosCanvMargin)] } {set dx [expr $maxX + (1.5 * $photosCanvMargin) - $subX2]}
  if {[+ $subY2 $dy] > [expr $maxY + (1.5 * $photosCanvMargin)] } {set dy [expr $maxY + (1.5 * $photosCanvMargin) - $subY2]}

  $w move current $dx $dy
  
  set ::X [+ $::X $dx]
  set ::Y [+ $::Y $dy]
}

##### S E T U P P H O T O S   P R O C S ####################################################
proc needsResize {} {
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]

  set imgX [image width photosCurrOrigPic]
  set imgY [image height photosCurrOrigPic]
  
  #Compare img dimensions with screen dimensions
  if {$screenX == $imgX && $screenY == $imgY} {
    return 0
  } else {
    return 1
  }
}

# addPic - called by SetupPhoto
# adds new Picture to BiblePix Photo collection
# setzt Funktion 'photosCurrOrigPic' voraus und leitet Subprozesse ein
proc addPic {} {
  global picPath jpegDir picSchonDa
  
  set targetPicPath [file join $jpegDir [getPngFileName [file tail $picPath]]]
  
  if { [file exists $targetPicPath] } {
    NewsHandler::QueryNews $picSchonDa lightblue
    return
  }
  
  if {[needsResize]} {
    openResizeWindow
  } else {
    photosCurrOrigPic write $targetPicPath -format PNG
    NewsHandler::QueryNews "[copiedPic $picPath]" lightblue
  }
} ;#END addPic

proc delPic {c} {
  global fileJList picPath
  file delete $picPath
  set fileJList [deleteImg $fileJList $c]
  NewsHandler::QueryNews "[deletedPic $picPath]" red
}

proc doOpen {bildordner c} {
  set localJList [openFileDialog $bildordner]
  refreshImg $localJList $c

  if {$localJList != ""} {
    pack .addBtn -in .nb.photos.mainf.right.unten -side left -fill x
  }
  pack .picPath -in .nb.photos.mainf.right.unten -side left -fill x
  pack .nb.photos.mainf.right.bar.collect -side left
  pack forget .delBtn

  return $localJList
}

proc doCollect {c} {
  set localJList [refreshFileList]
  refreshImg $localJList $c

  pack .delBtn .picPath -in .nb.photos.mainf.right.unten -side left -fill x
  pack forget .addBtn .nb.photos.mainf.right.bar.collect

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
#Creates functions 'photosCurrOrigPic' and 'photosCanvPic'
##to be processed by all other progs (no vars!)
proc openImg {imgFilePath imgCanvas} {
  global photosCanvMargin photosCanvX photosCanvY
  image create photo photosCurrOrigPic -file $imgFilePath

  #scale photosCurrOrigPic to photosCanvPic
  set imgX [image width photosCurrOrigPic]
  set imgY [image height photosCurrOrigPic]
  set factor [expr round(($imgX / $photosCanvX)+0.999999)]

  if {[expr $imgY / $factor] > $photosCanvY} {
    set factor [expr round(($imgY / $photosCanvY)+0.999999)]
  }

  catch {image delete photosCanvPic}
  image create photo photosCanvPic

  photosCanvPic copy photosCurrOrigPic -subsample $factor -shrink
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
  global Twdtools noTWDFilesFound

  if {[info procs getRandomTwdFile] == ""} {
    source $Twdtools
  }

  set twdFileName [getRandomTwdFile]

  if {$twdFileName == ""} {
    $twdWidget conf -fg black -bg red
    $twdWidget conf -activeforeground black -activebackground orange
    set twdText $noTWDFilesFound
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
