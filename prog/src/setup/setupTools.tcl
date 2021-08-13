# ~/Biblepix/prog/src/setup/setupTools.tcl
# Procs used in Setup, called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 9aug21 pv
source $SetupResizeTools
source $JList

# setTexts
##sources .msg file from msgdir according to current lang
##loads all text vars into ::msg namespace
##called by SetupMainFrame 
proc setTexts {lang} {
  global msgdir os all_msg
  package require msgcat
  namespace import msgcat::mc msgcat::mcset
  ##replace msgcat text variables
  msgcat::mclocale $lang
  msgcat::mcload "$msgdir"
  source -encoding utf-8 $all_msg
  ##replace text in Welcome text widget
  catch {fillWelcomeTWidget .welcomeT}
}


# addPic
##adds new Picture to BiblePix Photo collection
##setzt Funktion 'photosOrigPic' / 'rotateCutPic' voraus und leitet Subprozesse ein
##called by SetupPhotos
proc addPic {origPicPath} {
  global photosdir v
  source $::SetupResizePhoto
  source $::SetupResizeTools

  #Set path & exit if already there
  set targetPicPath [file join $photosdir [setPngFileName [file tail $origPicPath]]]
  if [file exists $targetPicPath] {
    NewsHandler::QueryNews $msg::picSchonDa red
    return 1
  }
  
  #POPULATE ::addpicture namespace
  namespace eval addpicture {}
  set addpicture::targetPicPath $targetPicPath

  if ![info exists addpicture::curPic] {
    set addpicture::curPic photosOrigPic
  }

  #DETERMINE NEED FOR RESIZING 

  ## expect 0 / even / uneven
  set resize [needsResize $addpicture::curPic]
  
  #A): right dimensions, right size: save pic
  if {$resize == 0} {
    $addpicture::curPic write $targetPicPath -format PNG
    NewsHandler::QueryNews "$msg::copiedPicMsg $origPicPath" lightgreen
    openReposWindow $addpicture::curPic

  #B) right dimensions, wrong size: start resizing & open reposWindow
  } elseif {$resize == "even"} {

    set screenX [winfo screenwidth .]
    set screenY [winfo screenheight .]
    NewsHandler::QueryNews "$msg::resizingPic" orange

    set newpic [resizePic $addpicture::curPic $screenX $screenY]
    set addpicture::curPic $newpic

    $newpic write $targetPicPath -format PNG
    NewsHandler::QueryNews "$msg::copiedPicMsg $origPicPath" lightgreen

    openReposWindow $newpic

  #C) open resize window, resize later
  } else {
    openResizeWindow
  }
  set ::numPhotos [llength [glob $photosdir/*]]
} ;#END addPic

# delPic
##deletes picture from photo collection
##called by SetupPhotos
proc delPic {c} {
  global photosdir fileJList picPath
  file delete $picPath
  set fileJList [deleteImg $fileJList $c]
  NewsHandler::QueryNews "msg::deletedPicMsg $picPath" orange
  set ::numPhotos [llength [glob $photosdir/*]]
}

#######################################################################
###### P r o c s   f o r   N e w s   h a n d l i n g ##################
#######################################################################

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
    .news conf -fg black -bg #bab86c ;#light olive
    set ::news "biblepix.vollmar.ch"
    set isShowing 0
    ShowNews
  }
}

##########################################################################
###### P r o c s   f o r   S e t u p G U I   +   S e t u p D e s k t o p #
##########################################################################


# Grey out all spinboxes if !$enablepic
proc setSpinState {imgyesState} {
  if $imgyesState {
    set com normal
  } else {
    set com disabled
  }
  lappend widgetlist .showdateBtn .slideBtn .slideSpin .fontcolorSpin .fontsizeSpin .fontweightBtn .fontfamilySpin .randomfontcolorCB
  foreach i $widgetlist {
    $i configure -state $com
  }
}

# Grey out Slideshow spinbox if !enableSlideshow
proc setSlideSpin {state} {
  global slideshow

  if {$state==1} {
    .slideSpin conf -state normal
    #set standard if changed from 0
    if {$slideshow==0} {
      set slideshow 300
    }
    .slideSpin set $slideshow
    .slideTxt conf -fg black
    .slideSecTxt conf -fg black
  } else {
    .slideSpin conf -state disabled
    .slideSpin set 0
    .slideTxt conf -fg grey
    .slideSecTxt conf -fg grey
  }
}

# renameTabs
##resets Notebook tab names according to lang
##note: Notebook doesn't accept text variables
##called by setFlags
proc renameNotebookTabs {} {
  .nb tab .welcomeF -text $msg::welcome
  .nb tab .internationalF -text $msg::bibletexts
  .nb tab .desktopF -text $msg::desktop
  .nb tab .photosF -text $msg::photos
  .nb tab .emailF -text $msg::email
  if [winfo exists .terminalF] {
    .nb tab .terminalF -text $msg::terminal
  }
  .nb tab .manualF -text $msg::manual
}

# setFlags
##draws flags & resets texts upon mouseclick
##called by SetupBuildGui
proc setFlags {} {
  global Flags
  
  #Configure language flags
  source $Flags
  flag::show .en -flag {hori blue; x white red; cross white red}
  flag::show .de -flag {hori black red yellow}
  flag::show .es -flag {hori red gold red}
  .en config -relief raised
  .de config -relief raised
  .es conf -relief raised
  
  #Configure English button
  bind .en <ButtonPress-1> {
    set lang en
    setTexts en
    renameNotebookTabs
    .manualF.man configure -state normal
    .manualF.man replace 1.1 end [setManText en]
    .manualF.man configure -state disabled
    .en configure -relief flat
  }
  
  bind .en <ButtonRelease> { .en configure -relief raised}

  #Configure Deutsch button
  bind .de <ButtonPress-1> {
    set lang de
    setTexts de
    renameNotebookTabs
    .manualF.man configure -state normal
    .manualF.man replace 1.1 end [setManText de]
    .de configure -relief flat
  }
  bind .de <ButtonRelease> { .de configure -relief raised}

#TODO testing spanish
  bind .es <ButtonPress-1> {
    set lang es
    setTexts es
    renameNotebookTabs
    .manualF.man configure -state normal
    .manualF.man replace 1.1 end [setManText en]
    .es configure -relief flat
  }
  bind .es <ButtonRelease> { .de configure -relief raised}

}

# setManText
## Formats Manual & switches between languages
## called by [bind] above
proc setManText {lang} {
  global ManualD ManualE

  set manW .manualF.man
  $manW configure -state normal

  if {$lang=="de"} {
    set manFile $ManualD
  } elseif {$lang=="en"} {
    set manFile $ManualE
  }

  set chan [open $manFile]
  chan configure $chan -encoding utf-8
  set manText [read $chan]
  close $chan

  $manW replace 1.0 end $manText

  #Determine & tag headers
  set numLines [$manW count -lines 1.0 end]

  for {set line 1} {$line <= $numLines} {incr line} {

    ##Level H3 (all caps header) if min. 2 caps at beg. of line
    if { [$manW search -regexp {^[[:upper:]]{2}} $line.0 $line.end] != ""} {
      $manW tag add H3 $line.0 $line.end

    ##Level H2 (1x spaced Header)
    } elseif { [$manW search -regexp {^[[:upper:]] [[:upper:]]} $line.0 $line.end] != ""} {
      $manW tag add H2 $line.0 $line.end

    ##Level H1 (2x spaced Header)
    } elseif { [$manW search -regexp {^[[:upper:]]  [[:upper:]]} $line.0 $line.end] != ""} {
      $manW tag add H1 $line.0 $line.end

    ##Level Addenda (dash at line start > all following in small script)
    } elseif { [$manW search -regexp {^-} $line.0 $line.end] != ""} {
      $manW tag add Addenda $line.0 end
    }
  }


  #Configure font tags
  $manW tag conf H1 -font "TkCaptionFont 20 bold"
  $manW tag conf H2 -font "TkHeadingFont 16 bold"
  $manW tag conf H3 -font "TkSmallCaptionFont 14 bold"
  $manW tag conf Addenda -font "TkTooltipFont"
  ##tabs in pixels?
  $manW configure -tabs 30
  $manW configure -state disabled

}
#####################################################################
# S E T U P   M A I L   P R O C S
#####################################################################

# updateMailBtnList
#List language codes of installed TWD files
#called here & in SetupInternational 
proc updateMailBtnList {window} {
  global twddir
  set twdList [getTwdList]
  if {$twdList == ""} {return}
  
  foreach e $twdList {
    #files may have been deleted after creating langcodeL!
    if [file exists $twddir/$e] {
      lappend codeL [string range $e 0 1]
    }
  }
  set langcodeL [lsort -decreasing -unique $codeL]
  #Create language buttons for each language code
  foreach slave [pack slaves $window] {pack forget $slave}
  foreach code $langcodeL {
    catch {  checkbutton .${code}Btn -text $code -width 5 -selectcolor beige -indicatoron 0 -variable sel${code} }
    pack .${code}Btn -in .emailF.topF.f2.rightF -side right -padx 3
    lappend sigLangBtnList .${code}Btn
  }
  set ::langcodeL $langcodeL
  set ::sigLangBtnList $sigLangBtnList
  #return $sigLangBtnList
}
# updateSelectedMailBtnList
#Lists selected sigLangBtn's
##called by Save
proc updateSelectedMailBtnList {} {
  global lang langcodeL
  if {![info exists langcodeL] || $langcodeL == ""} {
    return $lang
  }
  foreach code $langcodeL {
    set varname "sel${code}" 
    if [set ::$varname] {
      lappend sigLanglist $code
    }
  }
  if ![info exists sigLanglist] {
    puts "No signature languages selected. Saving default."
    set sigLanglist $lang
  }
  return $sigLanglist
}


#########################################################################
##### C A N V A S   M O V E   P R O C S #################################
#########################################################################

# createMovingTextBox
##Creates textbox with TW text on canvas $c
##Called by SetupDesktop & SetupResizePhoto
proc createMovingTextBox {c} {
  global FilePaths sunFactor shadeFactor fontcolortext
  global textPosFactor fontcolorHex fontsize fontfamily fontweight setupTwdText
  global colour::marginleft colour::margintop

  #Create movingTextFont here, to be configured later (setCanvFontSize)
  catch {font create movingTextFont}
  catch {font create movingTextReposFont}

  set screenx [winfo screenwidth .]
  set screeny [winfo screenheight .]
  set x1 [expr $marginleft/$textPosFactor]
  set y1 [expr $margintop/$textPosFactor]
  set shadeX [expr $x1 + 1]
  set shadeY [expr $y1 + 1]
  set sunX [expr $x1 - 1]
  set sunY [expr $y1 - 1]

  #Fill with medium colours (luminance code = 2)
  set regHex [set colour::$fontcolortext]
  set sunHex [gradient $regHex $sunFactor]
  set shaHex [gradient $regHex $shadeFactor]
  
  $c create text $shadeX $shadeY -anchor nw -justify left -tags {canvTxt txt mv shade} -fill $shaHex
  $c create text $sunX $sunY -anchor nw -justify left -tags {canvTxt txt mv sun} -fill $sunHex
  $c create text $x1 $y1 -anchor nw -justify left -tags {canvTxt txt mv main} -fill $regHex
  $c itemconf canvTxt -text $setupTwdText
  if [isBidi $setupTwdText] {
    $c itemconf canvTxt -justify right
    font conf movingTextFont -family Luxi
  } 

  if {$c == ".textposCanv"} {
    $c itemconf canvTxt -font movingTextFont -activefill red
  } elseif {$c == ".reposPhoto.reposCanv"} {
    $c itemconf canvTxt -font movingTextReposFont -activefill orange
  }
} ;#END createMovingTextBox

# isBidi
##checks test range for bidi characters & sets widget to justify=right
##called by various Setup procs
proc isBidi s {
  if [regexp {[\u05D0-\u06FC]} $s] {
    #$widget conf -justify right
    return 1
  } else {
    return 0
  }
}

# dragCanvasItem
##adapted from a proc by ? ...THANKS TO  ...
##called by SetupDesktop & setupRespositionText
proc dragCanvasItem {c item newX newY args} {
  set xDiff [expr {$newX - $::x}]
  set yDiff [expr {$newY - $::y}]

  #test margins before moving
  if {![info exists args]} {set args ""}

  if [checkItemInside $c $item $xDiff $yDiff $args] {
    $c move $item $xDiff $yDiff
  }
  set ::x $newX
  set ::y $newY
  
  set ::move 1
}

# checkItemInside
## makes sure movingItem stays inside canvas
## called by setupResizePhoto (tag: img) & setupDesktop moving text (tag: txt)
## 'args' is for compulsory margin for text item
proc checkItemInside {c item xDiff yDiff args} {
  set canvX [lindex [$c conf -width] end]
  set canvY [lindex [$c conf -height] end]

  #A) Image (resizePic)
  if {$item == "img"} {

    set imgname [lindex [$c itemconf img -image] end]
    set itemX [image width $imgname]
    set itemY [image height $imgname]

    set can(maxx) 0
    set can(maxy) 0
    set can(minx) [expr ($canvX - $itemX)]
    set can(miny) [expr ($canvY - $itemY)]

  #B) Text (moving Text)
  } elseif {$item == "txt"} {

    lassign [$c bbox canvTxt] x1 y1 x2 y2
    set itemY [expr $y2 - $y1]
    set itemX [expr $x2 - $x1]

    set can(maxx) [expr $canvX - $itemX - $args]
    set can(maxy) [expr $canvY - $itemY - $args]
    set can(minx) $args
    set can(miny) $args
  }

  #item coords
  set itemPos [$c coords $item]

  #check min values
  foreach {x y} $itemPos {
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

} ;#END checkItemInside


##########################################################################
###### P r o c s   f o r   S e t u p P h o t o s #########################
##########################################################################

proc doOpen {bildordner canv} {
  set localJList [openFileDialog $bildordner]
  refreshImg $localJList $canv

  if {$localJList != ""} {
    pack .addBtn -in .photosF.mainf.right.unten -side left -fill x
  }

  pack .picPathL -in .photosF.mainf.right.unten -side left -fill x
  pack .photosF.mainf.right.bar.collect -side right -fill x
  pack forget .delBtn .photosF.mainf.right.bar.count1 .photosF.mainf.right.bar.count2

  #Add Rotate button
  pack .rotateBtn -in .photosF.mainf.right.unten -side right

  return $localJList
}

proc doCollect {canv} {
  set localJList [refreshFileList]
  set localJList [step $localJList 0 $canv]
  refreshImg $localJList $canv

  pack .delBtn .picPathL -in .photosF.mainf.right.unten -side left -fill x
  pack .photosF.mainf.right.bar.count1 .photosF.mainf.right.bar.count2 -side right
  pack forget .addBtn .photosF.mainf.right.bar.collect .rotateBtn

  return $localJList
}

proc step {localJList fwd canv} {
  set localJList [jlstep $localJList $fwd]
  refreshImg $localJList $canv

  return $localJList
}

proc openFileDialog {bildordner} {
  global types platform

  set storage ""
  set parted 0
  set localJList ""

  set selectedFile [tk_getOpenFile -filetypes $types -initialdir $bildordner]
  if {$selectedFile != ""} {
    set pos [string last "/" $selectedFile]
    set folder [string range $selectedFile 0 [expr $pos - 1]]

    if {$platform == "unix"} {
      set fileNames [glob -nocomplain -directory $folder *.jpg *.jpeg *.JPG *.JPEG *.png *.PNG]
    } elseif {$platform == "windows"} {
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
  global platform photosdir
  set storage ""
  set parted 0
  set localJList ""

  if {$platform == "unix"} {
    set fileNames [glob -nocomplain -directory $photosdir *.jpg *.jpeg *.JPG *.JPEG *.png *.PNG]
  } elseif {$platform == "windows"} {
    set fileNames [glob -nocomplain -directory $photosdir *.jpg *.jpeg *.png]
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

proc refreshImg {localJList canv} {
  global picPath

  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set maxCanvX [expr round([winfo width .] / 1.5)]
  set factor [expr ceil($screenX. / $maxCanvX)]

  set canvX [expr round($screenX / $factor)]
  set canvY [expr round($screenY / $factor)]

  $canv conf -width $canvX -height $canvY

  set fn ""
  if {$localJList != ""} {
    set fn [jlfirst $localJList]
    openImg $fn $canv
    } else {
      hideImg $canv
  }
  set picPath $fn
}

# openImg - called by refreshImg
#Creates functions 'photosOrigPic' and 'photosCanvPic'
##to be processed by all other progs (no vars!)
proc openImg {imgFilePath imgCanvas} {
  image create photo photosOrigPic -file $imgFilePath

  set canvX [lindex [$imgCanvas configure -width] end]
  set canvY [lindex [$imgCanvas configure -height] end]
  
  #scale photosOrigPic to photosCanvPic
  set imgX [image width photosOrigPic]
  set imgY [image height photosOrigPic]
  set factor [expr int(ceil($imgX. / $canvX))]

  if {[expr $imgY / $factor] > $canvY} {
    set factor [expr int(ceil($imgY. / $canvY))]
  }

  catch {image delete photosCanvPic}
  image create photo photosCanvPic
  photosCanvPic copy photosOrigPic -subsample $factor -shrink
  $imgCanvas create image 0 0 -image photosCanvPic -anchor nw -tag img
  
  namespace eval addpicture {}
  set addpicture::curPic photosOrigPic
} ;#END openImg

proc hideImg {imgCanvas} {
  $imgCanvas delete img
}

proc deleteImg {localJList canv} {
  global imgName

  set localJList [jlremovefirst $localJList]
  refreshImg $localJList $canv

  if {$localJList == ""} {
    pack forget .delBtn
  }

  return $localJList
}

# copyAndResizeSamplePhotos
## copies sample Jpegs to PhotosDir unchanged if size OK
## else calls [resizePic]
## no cutting intended because these pics can be stretched
## called by BiblepixSetup
proc copyAndResizeSamplePhotos {} {
  global sampleJpgL photosdir sampleJpgDir
  source $::ImgTools
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]

  foreach filePath $sampleJpgL {
    set fileName [file tail $filePath]
    set origJpgPath $filePath
    set newJpgPath [file join $photosdir $fileName]
    set newPngPath [setPngFileName $newJpgPath]

    #Skip if JPG or PNG found in $photosdir
    if { [file exists $newJpgPath] || [file exists $newPngPath] } {
      puts "Skipping $fileName"
      continue
    }

    #Copy over as JPG if size OK
    image create photo origJpeg -file $origJpgPath
    set imgX [image width origJpeg]
    set imgY [image height origJpeg]

    if {$screenX == $imgX && $screenY == $imgY} {
      puts "Copying $fileName unchanged"
      file copy $origJpgPath $newJpgPath
    #else resize & save as PNG
    } else {

      puts "Resizing $origJpgPath"
      set newPic [resizePic origJpeg $screenX $screenY]
      $newPic write $newPngPath -format PNG
    }
  } ;#END foreach
  
} ;#END copyAndResizeSamplePhotos


################################################################################
##### P r o c s   f o r   S e t u p W e l c o m e  #############################
################################################################################

# fillWelcomeTWidget
##sets & resets .WelcomeT text acc. to language
##called by SetupWelcome & setTexts
proc fillWelcomeTWidget {T} {
  global platform
  $T delete 1.0 end
  $T insert 1.0 $msg::welcTxt2

  #delete "Terminal" line if not Unix
  if {$platform=="windows"} {
    $T delete 6.0 end
  }
  $T tag conf bold -font TkCaptionFont

  #Set keywords: to bold
  set lines [$T count -lines 1.0 end]
  for {set line 1} {$line <= $lines} {incr line} {
    set colon [$T search : $line.0 $line.end]
    $T tag add bold $line.0 $colon 
  }
}

# insertTodaysTwd
##inserts text into text widget
##called by SetupWelcome
proc insertTodaysTwd {twdWidget} {
  global TwdTools twddir

  if {[info procs getRandomTwdFile] == ""} {
    source $TwdTools
  }
  
  set twdFileName [getRandomTwdFile]
  if {$twdFileName == ""} {
    $twdWidget conf -activebackground orange
    set twdText $::noTwdFilesFound
    return
  }

  set twdText [getTodaysTwdText $twdFileName]

  #insert new text
  $twdWidget delete 1.0 end
  $twdWidget insert 1.0 $twdText

  ##locate & format Head
  $twdWidget tag add head 1.0 1.end
  ##locate + format reflines
  set refindices [$twdWidget search -all \u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0 3.0 end]
  lassign [split $refindices] ref1 ref2
  ##get plain line numbers before dot
  set refline1 [regsub {([0-9]?)(\..*$)} $ref1 {\1}]
  set refline2 [regsub {([0-9]?)(\..*$)} $ref2 {\1}]
  $twdWidget tag add ref $refline1.0 $refline1.end
  $twdWidget tag add ref $refline2.0 $refline2.end
  ##locate + format text blocks
  lappend text1 2.0 [expr $refline1 - 1].end
  lappend text2 [expr $refline1 + 1.0] [expr $refline2 - 1].end
  $twdWidget tag add text [lindex $text1 0] [lindex $text1 1]
  $twdWidget tag add text [lindex $text2 0] [lindex $text2 1]

  if [isBidi $twdText] {
    $twdWidget tag conf text -justify right
    $twdWidget tag conf head -justify right
    $twdWidget tag conf ref -justify left
  } else {
    $twdWidget tag conf text -justify left
    $twdWidget tag conf head -justify left
    $twdWidget tag conf ref -justify right
  }
    
  ##export for other Setup widgets
  set ::setupTwdText $twdText
}

# deleteOldStuff
##Removes stale prog files & dirs not listed in Globals
##called by Setup
proc deleteOldStuff {} {
  global dirPathL filePathL fontPathL progdir srcdir piddir confdir

  #combine all file & font lists
  set filePathL [list {*}$filePathL {*}$fontPathL]
  
  # 1. D e l e t e   s t a l e   d i r e c t o r i e s

  #1.List current directory paths starting from progdir&srcdir
  foreach path [glob -directory $progdir -type d *] {
    ##exempt piddir & confdir
    if {$path != "$piddir" && $path != "$confdir"} {
      lappend curFolderList $path
    }
  }
  foreach path [glob -directory $srcdir -type d *] {
    lappend curFolderList $path
  }

  #remove piddir from folderlist
  set index [lsearch $piddir $curFolderList]
  set curFolderList [lreplace $curFolderList $index $index]

  #Delete stale dir paths
  foreach path $curFolderList {
    catch {lsearch -exact $dirPathL $path} res
    if {$res == -1} {
      file delete -force $path
      NewsHandler::QueryNews "Deleted obsolete folder: $path" orange
    }
  }

  # 2. D e l e t e   s t a l e   s i n g l e   f i l e s

  ##list all immediate subdirs of $srcdir
  foreach dir [glob -directory $srcdir -type d *] {
    lappend curFolderList $dir
  }

  ##list all files in immediate subdirs
  foreach dir $curFolderList {
    foreach f [glob -nocomplain $dir/*] {
      lappend curFileList $f
    }
  }

  ##delete any obsolete files
  foreach path $curFileList {
    catch {lsearch -exact $filePathL $path} res
    if {$res == -1 && [file isfile $path]} {
      file delete $path
      NewsHandler::QueryNews "Deleted obsolete file: $path" orange
    }
  }

#  NewsHandler::QueryNews "$::uptodateHttp" lightgreen

} ;#END deleteOldStuff
