# ~/Biblepix/prog/src/setup/setupTools.tcl
# Procs used in Setup, called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 17may24 pv

source $SetupResizeTools

# setTexts
##sources .msg file from msgdir according to current lang
##loads all text vars into ::msg namespace
##called by SetupMainFrame 
proc setTexts {lang} {
  global msgdir os ExportTextvars TwdTools
  package require msgcat

  #Initiate msgcat  
  source $TwdTools
  set curLang $::lang
  msgcatInit $lang
  namespace import msgcat::mc msgcat::mcset

  #Load msgcat texts & set locale, set global vars for '-textvar' function
  source -encoding utf-8 $ExportTextvars

  ##replace text in Welcome text widget
  catch {fillWelcomeTextWidget .welcomeT}
  
  ##set widget justification (catch in case widgets aren't set at startup)
  if [isRtL $lang] {
  	catch {setWidgetDirection right}
  } else {
   	catch {setWidgetDirection left}
  } 
} ;#END setTexts


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
  
#TODO get rid of JList relicts
source $::JList
    
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

# toggleBtnState
##called by SetupEmail: .sigyes Btn to enable/disable lang checkbuttons
proc toggleBtnstate {} {
  global sigLangBtnList sigyesState
  
  if {![info exists sigLangBtnList] || $sigLangBtnList== ""} {
    return
  }
  foreach cb $sigLangBtnList {
    if $sigyesState {
      $cb conf -state normal
    } else {
      $cb conf -state disabled
    }
  }
}

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

# setFlags
##draws flags & resets texts upon mouseclick
##countries: de en es pt fr ar zh ru pl it)
##called by SetupMainFrame & SetupBuildGui
##Many thanks to Suchenwirth ....
proc setFlags {} {
  source $::Flags

  #Draw flag canvasses
  lappend flagL .de .fr .pl .es .pt .it .ru .ar .zh .en
  flag::show .en -flag {hori blue; x white red; cross white red}
  flag::show .de -flag {hori black red yellow} 
  flag::show .es -flag {hori red gold+ red; circle brown} 
  flag::show .fr -flag {vert blue white red} 
  flag::show .pt -flag {vert green red+ ; circle gold}
  flag::show .pl -flag {hori white red}
  flag::show .ru -flag {hori white blue red}
  flag::show .it -flag {vert green3 white red}
  flag::show .ar -flag {hori red white black; circle gold}
  flag::show .zh -flag {hori red; tlsq red; circle gold}

	#(Re)name Notebook tabs according to lang
	renameNotebookTabs

  proc btnPress {flag} {
    set lang [string range $flag 1 2]
    setTexts $lang
    $flag conf -relief raised -bd 1
    #Name Notebook tabs
    renameNotebookTabs
    #Fill manpage (en or de)
    catch {.manT conf -state normal}
    catch {setManText $lang}
    set ::lang $lang
  }
  proc btnRelease {flag} {
    $flag conf -relief flat -bd 0
    catch {.manT conf -state disabled}
  }
  
  foreach flag $flagL {
    bind $flag <1> "btnPress $flag"
    bind $flag <ButtonRelease-1> "btnRelease $flag"
  }
  
  return $flagL
  
} ;#END setFlags

# renameNotebookTabs
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

# incrFraction
##vergrössert Kommastelle für Textpositionen um $charNo
##called by setManText
proc incrFraction {pos charNo} {
  lassign [split $pos .] fix fraction
  incr fraction $charNo
  set endpos $fix.$fraction
  return $endpos
}

# setManText
## Formats Manual & switches between languages
## called by [bind] above
proc setManText {lang} {
  global ManualD ManualE
  
  .manT conf -state normal -bg beige 

  if {$lang=="de"} {
    set manFile $ManualD
  #set all else to English for now
  } else {
    set manFile $ManualE
  }
  
  set chan [open $manFile]
  chan configure $chan -encoding utf-8
  set manText [read $chan]
  close $chan

  .manT replace 1.0 end $manText
  
  # A ) set H E A D E R S
  set h1 "^# " 
  set h2 "^## "
  set h3 "^### "
  set h4 "^#### "
  set code "^>"
  
  #Configure tags
  .manT tag conf h1 -font {TkHeaderFont 25} -justify left
  .manT tag conf h2 -font {TkHeaderFont 20} -justify left
  .manT tag conf h3 -font {TkCaptionFont 17} -justify left
  .manT tag conf h4 -font {TkCaptionFont 14} -justify left
  .manT tag conf code -background gray90 -lmargin1 20
  .manT tag conf small -foreground grey
  
  #Determine header positions (h1-h4)
  set h1L [.manT search -all -regexp $h1 1.0 end]
  foreach pos $h1L {
    set line [expr int($pos)]
    .manT delete $pos [expr $pos + .1]
    .manT tag add h1 $pos $line.end
  }

  set h2L [.manT search -all -regexp $h2 2.0 end]
  foreach pos $h2L {
    set line [expr int($pos)]
    .manT delete $pos [expr $pos + .2]
    .manT tag add h2 $pos $line.end 
  }
  
  set h3L [.manT search -all -regexp $h3 1.0 end]
  foreach pos $h3L {
    set line [expr int($pos)]
    .manT delete $pos [expr $pos + .3]
    .manT tag add h3 $pos $line.end 
  }

  set h4L [.manT search -all -regexp $h4 1.0 end]
  foreach pos $h4L {
    set line [expr int($pos)]
    .manT delete $pos [expr $pos + .4]
    .manT tag add h4 $pos $line.end 
  }
 
  set codeL [.manT search -all -regexp $code 1.0 end]
  foreach pos $codeL {
    set line [expr int($pos)]
    .manT delete $pos
    .manT tag add code $pos $line.end
  }


# B ) S E T  B O L D

	#1. Set ** array for pairs  
  set boldL [.manT search -all ** 1.0]
  array set boldArr $boldL
  
  #2. Traverse ** list & tag pairs
  foreach arrname [array names boldArr] {
  	lassign [array get boldArr $arrname] a b
  	set pos1 $a
  	set pos2 [incrFraction $b 2]
  	.manT tag add bold $pos1 $pos2
  }

	#3. Delete all **
	proc cmd {pos} {
	  set res [.manT search ** $pos]
	  return $res
  }
	set pos [.manT search ** 1.0 end]
	
	while { ![catch {cmd $pos}] } {
	  set endpos [incrFraction $pos 2]
  	.manT delete $pos $endpos
  	set pos [.manT search ** [incrFraction $endpos 1]]
	}
 	

  # D )  F O O T N O T E S
  
  #Tag & bind footnotes
  ##see www.derekfountain.org/artikles/tktext.pdf
  .manT tag conf fn -foreground red
  ##search footnotes in text, but not in Footnotes!
  set fnL [.manT search -all -regexp {\[\^.\]} 1.0 end]
  foreach pos $fnL {
    set endpos [incrFraction $pos 4]
    .manT tag add fn $pos $endpos
  }
  .manT tag bind fn <Enter> {.manT config -cursor center_ptr}
  .manT tag bind fn <Leave> {.manT config -cursor xterm}
  .manT tag bind fn <1> {.manT yview moveto 0.9}

 	#E ) Set Addenda & Footnotes to grey font (EN/DE)
 	set pos [.manT search -regexp {ERG|ADD} 1.0 end]
  .manT tag add small $pos end
 
  ## clear all extra front spaces
  set spaceL [.manT search -all -regexp {^ } 1.0 end]
  foreach pos $spaceL {
    .manT delete $pos [incrFraction $pos 1]
  }
  
   .manT tag conf bold -font "TkTextFont 14" -foreground maroon
   .manT conf -state disabled

} ;#END setManText


#####################################################################
# S E T U P   M A I L   P R O C S
#####################################################################

# updateMailBtnList
#List language codes of installed TWD files
#called by SetupEmail & SetupInternational 
proc updateMailBtnList {w} {
  global twddir
  	
  set twdList [getTwdList]
  if {$twdList == ""} {return}

  ##files may have been deleted after creating langcodeL!  
  foreach filename $twdList {
    if [file exists $twddir/$filename] {
      lappend codeL [string range $filename 0 1]
    }
  }
  set langcodeL [lsort -decreasing -unique $codeL]
  
  #Create language buttons for each language code
  foreach slave [pack slaves $w] {pack forget $slave}
  foreach code $langcodeL {
    catch {  checkbutton .${code}Btn -text $code -width 5 -selectcolor beige -indicatoron 0 -variable sel${code} }
    pack .${code}Btn -in $w -side right -padx 3 -anchor e
    lappend sigLangBtnL .${code}Btn
  }
#TODO unify var names! > siglangL + siglangBtnL
  set ::langcodeL $langcodeL
  set ::sigLangBtnList $sigLangBtnL

} ;#END updateMailBtnList

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

  if {$c == ".dtTextposC"} {
    $c itemconf canvTxt -font movingTextFont -activefill red
  } elseif {$c == ".reposPhoto.reposCanv"} {
    $c itemconf canvTxt -font movingTextReposFont -activefill orange
  }
} ;#END createMovingTextBox

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

#Avoid showing hidden directories in tk_getOpenFile (only Linux?)
namespace eval ::tk::dialog::file {
  set showHiddenVar 0
}

# step
##moves pic index forward or backward by 1 or 10
# called by < >> << > buttons
proc step {direction} {
	global canvpic::index
	global canvpic::picdir
	global canvpic::picL
	
	#ilength = counting from 0
	##careful: llength counts from 1, lindex from 0 !!!
	set ilength [expr [llength $picL] -1]
	set bigstep 10
		
	#LOOPS A + B:
	## A) 1 step forward: jump to beginning if result empty
	if {$direction == ">"} {
	  incr index 1
	  if {$index > $ilength} {
	    set index 0
	  }
	}

	## B) 1 step back: jump to end if index less than 0
	if {$direction == "<"} {
	  incr index -1
    if {$index < 0} {
      set index $ilength
    }
  }

  #LOOPS C & D:
	## C) bigstep forward
	if {$direction == ">>"} {
		incr index ${bigstep}
		if {$ilength < $bigstep} {
			set index $ilength
		} else {
			if {$index > $ilength} {
				set index [expr $index - $ilength - 1]
			}
		}
	}

	## D) bigstep back
	if {$direction == "<<"} {
	  incr index -${bigstep}
		if {$ilength < $bigstep} {
			set index 0
		} else {
			if {$index < 0} {
				set index [expr $index + $ilength + 1]
			}
		}
	}
		 
 	set canvpic::index $index
 	set canvpic::userI [expr $index + 1]	

	set picname [lindex $picL $index]
	
	showImage $picname
	
} ;#END step

# openFileDialog
##
##saves picL & current pic index to canvpic::
##called by ...
proc openFileDialog {picdir } {
  global picTypes tempdir SetupPicThread
  global canvpic::imgCanv
  global canvpic::picL
 
  #adapt type list to tk_getOpenFile syntax
  foreach t $picTypes {
    lappend typeL ".$t"
  }
  append gofL "{ {" Image files: "} {" $typeL "} }"
	
	set selectedFilePath [tk_getOpenFile -filetypes $gofL -initialdir $picdir]
	
	#return if no result
	if {$selectedFilePath == ""} {
	  return
	}
	
	set selectedFileName [file tail $selectedFilePath]
  
  set canvpic::picdir $picdir
  resetPhotosGUI
  
  showImage $selectedFileName

	#Update picdir & update picL
	set picdir [file dirname $selectedFilePath]
	scanPicdir $picdir

	#Set pic index
	set picL $canvpic::picL
  if [ catch {set index [lsearch $picL $selectedFileName] } err] {
    set index 0
    puts $err
  }
  
  set canvpic::index $index
  set canvpic::userI [expr $index + 1]

	#Start Threading
  loadPicThread
  
} ;#END openFileDialog

# setPhotosCanvSize
##sets canv size after GUI is ready
##called by ShowFirstPhoto
proc setPhotosCanvSize {} {
  
  namespace eval canvpic {
    variable canvX
    variable canvY  
  }
  
  set screenX [winfo screenwidth .]
  set screenY [winfo screenheight .]
  set maxCanvX [expr round([winfo width .] / 1.5)]

 
##TODO? round rather than ceil here?
  #set factor [expr ceil($screenX. / $maxCanvX)]
  set factor [expr round($screenX. / $maxCanvX)]

  set canvX [expr round($screenX / $factor)]
  set canvY [expr round($screenY / $factor)]

  ##export

  set canvpic::canvX $canvX
  set canvpic::canvY $canvY
  
} ;#END setPhotosCanvSize

# scaleFactor (for pic on canvas)
## scales original pic down to canvas size
## called by openImg for each pic
proc scaleFactor {pic} {
    
  global canvpic::imgCanv canvpic::canvX canvpic::canvY 
 
  #make sure canv size up-to-date
  if {$canvX < 500} {
    setPhotosCanvSize
  }
  
  set imgX [image width $pic]
  set imgY [image height $pic]
  set factor [expr int(ceil($imgX. / $canvX))]
  if {[expr $imgY / $factor] > $canvY} {
    set factor [expr int(ceil($imgY. / $canvY))]
  }

  return $factor
}

# scanPicdir
##returns list of file names without paths
##called by openFileDialog
proc scanPicdir {picdir} {
	global picTypes
	
	#create type list with pic endings & glob syntax
	foreach i $picTypes {
		lappend typeL .$i
	}
  append globL * \{ [join $typeL ,] \} *

  set picL [glob -nocomplain -tails -directory $picdir $globL]

  #set picdir & picL vars in ::canvpic
  namespace eval canvpic {
    variable picdir
    variable picL 
  }
  set canvpic::picdir $picdir
  set canvpic::picL $picL
	set ::numPhotos [llength $picL]
	
	return $picL
	
} ;#END scanPicdir

# showImage
# Creates 'photosCanvPic' from original pic
##to be processed by all other progs (no vars!)
##called by 'step' & 
proc showImage {img} {

  global os photosdir 
  global canvpic::imgCanv
  global canvpic::picdir
  
  set imgPath [file join $picdir $img]
  set dirname [file tail $picdir]
  
  ##für Anzeige
  set ::picPath $imgPath
  
  
  namespace eval canvpic {
    variable curpic
  }
  set canvpic::curpic $img
   
	#retrieve thumb data 
	if ![catch { set picdata [tsv::get $dirname $img] } ] {
    
    puts "Creating $img from thumblist..."
    image create photo thumb
    thumb put $picdata

	#OR create pic from original 
	} else { 
	
    puts "Creating $imgPath from directory..."
		if [catch { image create photo orig -file $imgPath } ] {
			NewsHandler::QueryNews "$img: Picture format not recognised. Skipping." red
			return 1
		}
		   
	  set factor [scaleFactor orig]
    image create photo thumb	  
    thumb copy orig -subsample $factor -shrink

    orig blank
  }
    
  #Create canvas pic from thumb
  $imgCanv delete img
  $imgCanv create image 0 0 -image thumb -anchor nw -tag img
	
} ;#END showImage

# showFirstPhoto
## displays 1st pic as soon as Photos tab opens
## picL made previously in SetupPhotos
## called as a bind event in SetupMainFrame 
proc showFirstPhoto {} {

#TODO unnecessary now
  #this is set when first called to avoid multiple photosdir threads
  ##i.e. if SetupPhotos is visisted more than once nothing happens and
  ##the old pics series from photosdir is still present
#  if [info exists ::firstPhotoDone] {
#    return 1
#  }
#  set ::firstPhotoDone 1
  
  global canvpic::picL
  global canvpic::imgCanv
  global canvpic::canvX canvpic::canvY
  
  #Set canv size 
  setPhotosCanvSize
  $imgCanv conf -width $canvX -height $canvY
  
  #Load thumbs in background
  loadPicThread
  
  #Show pic in canvas
  set picname [lindex $picL 0]
  showImage $picname

} ;#END showFirstPhoto

# loadPicThread
##loads Thread extension
##called by openFileDialog & SetupPhotos for 1st display of photosdir
proc loadPicThread {} {

  global SetupPicThread
  
  if {  ! [catch {package require Thread}] } {
    source $SetupPicThread
  } else {
    NewsHandler::QueryNews "For faster image viewing: [mc packageRequireMissing 'thread']" red
  }
  
} ;#END loadPicThread

proc resetPhotosGUI {} {
  global canvpic::picdir photosdir
  global canvpic::picL
  global canvpic::index
  set ::numPhotos [llength $picL]
  
  # 1) Pack permanents
  pack .phCountNum .phCountTxt .phPicindexL .phPicindexTxt -in .phBotF -side right

  # 2) Pack BiblePix photos mode
  if {$picdir == $photosdir} {
    pack .phDelBtn  -in .phBotF1 -side left -anchor w
    pack .phPicpathL .phPicnameL -in .phBotF2 -anchor n
    pack forget .phAddBtn .phShowCollectionBtn .phRotateBtn 
  
  # 3) Pack "Add new" mode
  } else {
    pack .phShowCollectionBtn -in .phBarF -side left
    pack .phAddBtn -in .phBotF1 -side left -anchor w
    pack .phRotateBtn -in .phBotF1 -side left -anchor w
    pack .phPicpathL .phPicnameL -in .phBotF2
    pack forget .phDelBtn 
  }
  
} ;#END resetPhotosGUI

# addPic
##adds new Picture to BiblePix Photo collection
##setzt Funktion 'photosOrigPic' / 'rotateCutPic' voraus und leitet Subprozesse ein
##called by SetupPhotos
proc addPic {} {
  global photosdir v
  global canvpic::curpic
  global canvpic::picdir

  #Create original pic for processing
  set origPicPath [file join $picdir $curpic]
  image create photo photosOrigPic -file $origPicPath

  source $::SetupResizePhoto
  source $::SetupResizeTools

  #Set path & exit if already there
  set targetPicPath [file join $photosdir $curpic]
  if [file exists $targetPicPath] {
    NewsHandler::QueryNews $msg::picSchonDa red
    return 1
  }
  
  #POPULATE ::addpicture namespace
  namespace eval addpicture {}
  set addpicture::targetPicPath $targetPicPath
  set addpicture::curPic photosOrigPic
  

  #DETERMINE NEED FOR RESIZING 

  ## expect 0 / even / uneven
  set resize [needsResize $addpicture::curPic]
  
  #A): right dimensions, right size: save pic
  if {$resize == 0} {
    $addpicture::curPic write $targetPicPath -format PNG
    NewsHandler::QueryNews "[mc copiedPicMsg] $origPicPath" lightgreen
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
  #Reset standards & cleanup
  .phAddBtn conf -bg #d9d9d9
  namespace delete addpicture
  
} ;#END addPic

# deletePhoto
##deletes 1 pic from Photosdir & updates vars
##called by .phDelBtn in SetupPhotos 
proc deletePhoto {} {
  global canvpic::curpic
  global canvpic::picL
  global canvpic::index
  global photosdir
  
  file delete [file join $photosdir $curpic]
  NewsHandler::QueryNews "$curpic has been removed from BiblePix Photo collection." lightblue
  
  #Cleanup
  scanPicdir $photosdir 
  showImage [lindex $picL [incr index]] 
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


###################################################
##### P r o c s   f o r   S e t u p W e l c o m e  ###################################################
################################################################################

# fillWelcomeTextWidget
##sets & resets .WelcomeT text acc. to language
##called by SetupWelcome & setTexts
proc fillWelcomeTextWidget {w} {
  global platform lang
  
  #Insert text, deleting any previous
  set msg $msg::welcTxt2
  $w delete 1.0 end
  $w insert 1.0 $msg 
  
  #set Bidi justification to right
  if [isBidi $msg] {
    $w tag conf dir -justify right
    $w tag add dir 1.0 end
  }

  #delete "TERMINAL" line if not Unix
  if {$platform=="windows"} {
    $w delete 6.0 end
  }

} ;#END fillWelcomeTextWidget

# insertTodaysTwd
##inserts text into text widget
##called by SetupWelcome & "Next" btn
proc insertTodaysTwd {twdWidget} {
  global TwdTools twddir enabletitle

  if {[info procs getRandomTwdFile] == ""} {
    source $TwdTools
  }
  
  set twdFileName [getRandomTwdFile]
  if {$twdFileName != ""} {
    set twdText [getTodaysTwdText $twdFileName]
  } else {
    $twdWidget conf -fg red
    set twdText "[mc noTwdFilesFound]"
  }
  
  #insert new text
  $twdWidget delete 1.0 end
  $twdWidget insert 1.0 $twdText

  ##locate + format Head (even if !enabletitle)
  $twdWidget tag add head 1.0 1.end

  ##locate + format reflines (searching ?geschützte Leerzeichen? from 2nd line)
  set refindices [$twdWidget search -all \u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0 2.0 end]
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
  
} ;#END insertTodaysTwd

# deleteOldStuff
##Removes stale prog files & dirs not listed in Globals
##called by Setup
proc deleteOldStuff {} {
  global dirPathL filePathL fontdir fontPathL progdir srcdir piddir confdir

  #Delete any obsolete Asian font dirs - all files now in fontdir
  file delete -force $fontdir/asian $fontdir/china $fontdir/thai

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

} ;#END deleteOldStuff
