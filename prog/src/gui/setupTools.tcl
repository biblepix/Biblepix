# ~/Biblepix/prog/src/gui/setupTools.tcl
# Image manipulating procs
# Called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 25apr17

###### Procs for SetupGUI + SetupDesktop ######################

# F L A G   P R O C S

proc setCanvasText {fontcolor} {
global inttextCanv internationaltext
	set rgb [hex2rgb $fontcolor]
	set shade [setShade $rgb]
	set sun [setSun $rgb]
	$inttextCanv itemconfigure main -fill $fontcolor
	$inttextCanv itemconfigure sun -fill $sun
	$inttextCanv itemconfigure shade -fill $shade
}
#grey out all spinboxes if !$enablepic
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

#grey out Slideshow spinbox if !enableSlideshow
proc setSlideSpin {state} {
global slideSpin slideTxt slideSec slideshow
	
     if {$state==1} { 
     		$slideSpin configure -state normal
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
  
  #Configure Englisch button
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
global screenx screeny marginleft margintop textPosFactor fontsize fontfamily
global fontcolortext gold green blue silver noTWDFilesFound dwtext

	set textPosSubwinX [expr $screenx/20]
	set textPosSubwinY [expr $screeny/30]
	set x1 [expr $marginleft/$textPosFactor]
	set y1 [expr $margintop/$textPosFactor]
	set x2 [expr ($marginleft/$textPosFactor)+$textPosSubwinX]
	set y2 [expr ($margintop/$textPosFactor)+$textPosSubwinY]
	
#	set twdfile [getRandomTWDFile]
#	if {$twdfile == ""} {
#		set bibeltext $noTWDFilesFound
#	} else {
#		set bibeltext [formatImgText $twdfile]
#	}
	
	$textposCanv create text [expr $marginleft/$textPosFactor] [expr $margintop/$textPosFactor] -anchor nw -justify left -tags mv 
	$textposCanv itemconfigure mv -text $dwtext
#	$textposCanv itemconfigure mv -font "TkTextFont -[expr $fontsize/$textPosFactor]" -fill [set $fontcolortext]
$textposCanv itemconfigure mv -font "TkTextFont -[expr $fontsize/$textPosFactor]" -fill steelblue	
$textposCanv itemconfigure mv -activefill red
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
	
    $w move current $dx $dy
    set ::X [+ $::X $dx]
    set ::Y [+ $::Y $dy]     
}


##### Procs for SetupPhotos ####################################################

proc addPic {imgName} {
global news jpegdir lang
	set msg "Copied [file tail $imgName] to [file nativename $jpegdir]"
        set msgDE "[file tail $imgName] nach [file nativename $jpegdir] kopiert"
        if  {$lang=="de"} {set msg $msgDE}
        file copy $imgName $jpegdir
        .news conf -bg lightblue
        set ::news $msg
        after 3000 {.news conf -bg grey}
}

proc delPic {imgName} {
global news fileJList jpegdir lang
	set msg "Deleted [file tail $imgName] from [file nativename $jpegdir]"
        set msgDE "[file tail $imgName] aus [file nativename $jpegdir] gelöscht"
        if  {$lang=="de"} {set msg $msgDE}
        file delete $imgName
	set fileJList [deleteImg $fileJList .n.f6.mainf.right.bild.c]
        .news conf -bg red
        set ::news $msg
        after 3000 {.news conf -bg grey}
}

proc doOpen {bildordner c} {
	global imgName
	
	set localJList [getFileList $bildordner]
	refreshImg $localJList $c
	
	if {$localJList != ""} {
		pack .add -in .n.f6.mainf.right.unten -side left -fill x
	}
	pack .imgName -in .n.f6.mainf.right.unten -side left -fill x
	pack .n.f6.mainf.right.bar.collect -side left
	pack forget .del
	
	return $localJList
}

proc doCollect {c} {
	global imgName
	
	set localJList [refreshFileList]
	refreshImg $localJList $c
	
	pack .del .imgName -in .n.f6.mainf.right.unten -side left -fill x
	pack forget .add .n.f6.mainf.right.bar.collect

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
			set fileNames [glob -nocomplain -directory $folder *.jpg *.jpeg *.JPG *.JPEG]
		} elseif {$tcl_platform(platform) == "windows"} {
			set fileNames [glob -nocomplain -directory $folder *.jpg *.jpeg]
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
	global tcl_platform jpegdir
	set storage ""
	set parted 0
	set localJList ""
	
	if {$tcl_platform(os) == "Linux"} {
		set fileNames [glob -nocomplain -directory $jpegdir *.jpg *.jpeg *.JPG *.JPEG]
	} elseif {$tcl_platform(platform) == "windows"} {
		set fileNames [glob -nocomplain -directory $jpegdir *.jpg *.jpeg]
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

proc openImg {fn imgCanvas} {	
    catch {image delete $im1}
    image create photo im1 -file $fn

	#scale im1 to im2
	set imgx [image width im1]
	set imgy [image height im1]
	set factor [expr round(($imgx/650)+0.999999)]
	
	if {[expr $imgy / $factor] > 400} {
		set factor [expr round(($imgy/400)+0.999999)]
	}
	
	catch {image delete im2}
	image create photo im2
	
	im2 copy im1 -subsample $factor -shrink
	$imgCanvas create image 7 7 -image im2 -anchor nw -tag img    
}

proc hideImg {imgCanvas} {
	$imgCanvas delete img
}

proc deleteImg {localJList c} {
	global imgName
	
	set localJList [jlremovefirst $localJList]
	refreshImg $localJList $c
	
	if {$localJList == ""} {
		pack forget .del
	}
	
	return $localJList
}
