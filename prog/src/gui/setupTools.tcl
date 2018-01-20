# ~/Biblepix/prog/src/gui/setupTools.tcl
# Image manipulating procs
# Called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 8dec17

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
    .n.f5.man configure -state normal
    .n.f5.man replace 1.1 end [setReadmeText en]
    .n.f5.man configure -state disabled
    .en configure -relief flat
  }
  bind .en <ButtonRelease> { .en configure -relief raised}

  #Configure Deutsch button
  bind .de <ButtonPress-1> {
    set lang de
    setTexts de
    .n.f5.man configure -state normal
    .n.f5.man replace 1.1 end [setReadmeText de]
    .n.f5.man configure -state disabled
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

proc move {w x y} {
  proc + {a b} {expr {$a + $b}}
  proc - {a b} {expr {$a - $b}}

    set dx [- [$w canvasx $x] $::X]
    set dy [- [$w canvasx $y] $::Y]

    if {$dx < -2} {set dx -2}
    if {$dx > 2} {set dx 2}

    if {$dy < -2} {set dy -2}
    if {$dy > 2} {set dy 2}

  lassign [$w coords mv] subX subY - -

  if {[+ $subX $dx] < 0 } {set dx $subX}
  if {[+ $subY $dy] < 0 } {set dy $subY}

  #move only in one direction if x or y missing (= 0)
  #necessary for areaChooser
  if {$x==0} {
    $w move current 0 $dy
  } elseif {$y==0} {
    $w move current $dx 0
  } else {
    #Normalfall
    $w move current $dx $dy
  }
    set ::X [+ $::X $dx]
    set ::Y [+ $::Y $dy]
}

#called by addPic
proc createPhotoAreaChooser {canv x1 y1 x2 y2} {
  global canvPicMargin
  $canv create rectangle 0 0 [expr $x2 + $canvPicMargin] [expr $y2 + $canvPicMargin] -tags {mv areaChooser}
  $canv itemconfigure areaChooser -outline red -activeoutline yellow -fill {} -width $canvPicMargin
}

#Get current coordinates from PhotoAreaChooser
proc getAreaChooserCoords {} {
  set imgCoords [.imgCanvas bbox areaChooser]
  return $imgCoords
}

##### S E T U P P H O T O S   P R O C S ####################################################

# addPic - called by SetupPhoto
# adds new Picture to BiblePix Photo collection
# setzt Funktion 'origPic' voraus und leitet Subprozesse ein
proc addPic {} {
  global jpegDir lang SetupTexts canvImgFactor
  source $SetupTexts
  setTexts $lang

  set imgName [file tail [origPic conf -file]]

  # Set cutting coordinates for origPic
  set cutImgCoords "[checkImgSize]"
    set CutX1 0
    set CutY1 0
    set CutX2 [lindex $cutImgCoords 0]
    set CutY2 [lindex $cutImgCoords 1]
    set cutEdge [lindex $cutImgCoords 2]

  ##Image is already there (return code 1)
  if {$cutImgCoords==1} {
    NewsHandler::QueryNews $::picSchonDa lightblue
		return 0

  ##Image has right size (return code 0)
  } elseif {$cutImgCoords==0} {
    NewsHandler::QueryNews $::copiedPic lightblue
		return 0
	}

  ##Image size to be changed

#1. hide Photos tab & create temporary tab
	.n hide .n.f6
        catch {frame .n.resizeF}
	.n add .n.resizeF -text "Resize Photo"
        .n insert 4 .n.resizeF
        .n select 4

	catch {button .resizeConfirmBtn}
        catch {button .resizeCancelBtn} 
	.resizeConfirmBtn configure -textvar ::pressToResize -command "doResize $cutEdge"
  	.resizeCancelBtn configure -textvar ::cancel -command "restorePhotosTab"
	pack .imgCanvas -in .n.resizeF
	pack .resizeConfirmBtn .resizeCancelBtn -in .n.resizeF -side right
  
  proc restorePhotosTab {} {
  	.n forget .n.resizeF
  	.n add .n.f6
    	.n select 3
        pack .imgCanvas -in .n.f6.mainf.right.bild -side left
        .imgCanvas delete areaChooser
        }
  
#2.
	# C r e a t e   P h o t o  a r e a  c h o o s e r

	##get coordinates of current Show Pic (tag='img')
	set canvImgCoords [.imgCanvas bbox img]

	set SPx1 [lindex $canvImgCoords 0]
	set SPy1 [lindex $canvImgCoords 1]
	set SPx2 [lindex $canvImgCoords 2]
	set SPy2 [lindex $canvImgCoords 3]



puts "ShowPix X2: $SPx2"
puts "ShowPix Y2: $SPy2"
puts "CutX2: $CutX2 "
puts "CutY2: $CutY2"

	##set cutting coordinates for canvPic
	set canvCutX2 [expr $CutX2 / $canvImgFactor]
	set canvCutY2 [expr $CutY2 / $canvImgFactor]
puts "canvCutX2 $canvCutX2"
puts "canvCutY2 $canvCutY2 "



#Create new top window for Image cutting dialogue


##repack imgCanvas in new Window
pack .imgCanvas -in .n.resizeF
#pack .resizeConfirmBtn -in .n.resizeF -anchor n

	# Create AreaChooser with cutting coordinates
	createPhotoAreaChooser .imgCanvas 0 0 $canvCutX2 $canvCutY2

	##activate chooser (tag='areaChooser') -TODO: Rahmen kann über Bild hinausgehen
	if {$cutEdge=="X"} {
		#limit move capability to x
		set y 0
		set x "%x"
		} elseif {$cutEdge=="Y"} {
		#limit move capability to y
		set x 0
		set y "%y"
	}

	##reconfigure Button -TODO : need new proc(s):
	# change button >doResize - keep message as long as nothing done!
		NewsHandler::QueryNews $::setCutArea yellow
#	.addBtn conf -bg red -command "???doResize $cutEdge" ;#TODO: Funktion geht nicht !!!
#  set ::f6.add "$::pressToResize"

	##
	.imgCanvas bind mv <1> {movestart %W %x %y}
	.imgCanvas bind mv <B1-Motion> "move %W $x $y"


} ;#END addPic


# delPic called by SetupPhoto - TODO: Vars anpassen!!!
proc delPic {imgName} {
  global fileJList jpegDir lang SetupLang
  file delete $imgName
  set fileJList [deleteImg $fileJList .n.f6.mainf.right.bild.c]
  NewsHandler::QueryNews "$picDeleted" red
}

proc doOpen {bildordner c} {
  global imgName

  set localJList [getFileList $bildordner]
  refreshImg $localJList $c

  if {$localJList != ""} {
    pack .addBtn -in .n.f6.mainf.right.unten -side left -fill x
  }
  pack .imgName -in .n.f6.mainf.right.unten -side left -fill x
  pack .n.f6.mainf.right.bar.collect -side left
  pack forget .delBtn

  return $localJList
}

proc doCollect {c} {
  global imgName

  set localJList [refreshFileList]
  refreshImg $localJList $c

  pack .delBtn .imgName -in .n.f6.mainf.right.unten -side left -fill x
  pack forget .addBtn .n.f6.mainf.right.bar.collect

  return $localJList
}

proc step {localJList fwd c} {
  global imgName

  set localJList [jlstep $localJList $fwd]
  refreshImg $localJList $c

  return $localJList
}

proc getFileList {bildordner} {
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
  global imgName

  set fn ""
  if {$localJList != ""} {
    set fn [jlfirst $localJList]
    openImg $fn $c
    } else {
      hideImg $c
  }
  set imgName $fn
}

# openImg - called by refreshImg
#Creates functions 'origPic' and 'canvPic'
##to be processed by all other progs (no vars!)
proc openImg {imgFilePath imgCanvas} {
  global canvPicMargin
  catch {image delete origPic}
  image create photo origPic -file $imgFilePath

  #scale origPic to canvPic
  set imgx [image width origPic]
  set imgy [image height origPic]
  set factor [expr round(($imgx/650)+0.999999)]

  if {[expr $imgy / $factor] > 400} {
    set factor [expr round(($imgy/400)+0.999999)]
  }
  #Export factor
  set ::canvImgFactor $factor

  catch {image delete canvPic}
  image create photo canvPic

  canvPic copy origPic -subsample $factor -shrink
  .imgCanvas create image $canvPicMargin $canvPicMargin -image canvPic -anchor nw -tag img
}

proc hideImg {imgCanvas} {
  .imgCanvas delete img
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
