# ~/Biblepix/prog/src/share/imgtools.tcl
# Image manipulating procs
# Called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 13nov16 

###### Procs for SetupGUI + SetupDesktop ######################

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


####### Procs for $Hgbild ####################################################

proc cutx {src diff} {
	puts "Cutting X $diff ..."
	#regsub {\-} $diff {} diff
	#set diffhalb [expr $diffx/2]
	
	set imgx [image width $src]
	set imgy [image height $src]
	
	image create photo ausschnitt
	ausschnitt blank
	#rechts ausschneiden
	ausschnitt copy $src -from 0 0 [expr $imgx-$diff] $imgy -shrink
	
	$src blank 
	$src copy ausschnitt -shrink
	
	#$src conf -width 0 -height 0
}

proc cuty {src diff} {	
	puts "Cutting Y $diff ..."
	regsub {\-} $diff {} diff
	set diffhalb [expr $diff/2]
	
	set imgx [image width $src]
	set imgy [image height $src]
	
	#oben+unten ausschneiden:
	image create photo ausschnitt
	ausschnitt blank
	ausschnitt copy $src -from 0 $diffhalb $imgx [expr $imgy - $diffhalb] -shrink
	$src blank
	$src copy ausschnitt -shrink
	
	#$src conf -width $screenx -height $screeny
	#set imgy $screeny
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
	set fileJList [deleteImg $fileJList .n.f6.content.left.bild.c]
        .news conf -bg red
        set ::news $msg
        after 3000 {.news conf -bg grey}
}

proc doOpen {bildordner c} {
	global imgName
	
	set localJList [getFileList $bildordner]
	refreshImg $localJList $c
	
	if {$localJList != ""} {
		pack .add -in .n.f6.content.left.unten -side left -fill x
	}
	pack .imgName -in .n.f6.content.left.unten -side left -fill x
	pack .n.f6.content.left.bar.collect -side left
	pack forget .del
	
	return $localJList
}

proc doCollect {c} {
	global imgName
	
	set localJList [refreshFileList]
	refreshImg $localJList $c
	
	pack .del .imgName -in .n.f6.content.left.unten -side left -fill x
	pack forget .add .n.f6.content.left.bar.collect

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

###############################################################################

#Proc called 1x in Hgbild for even-sided resizing

proc resize {src newx newy {dest ""} } { 
 #  Decsription:  Copies a source image to a destination
 #                image and resizes it using linear interpolation
 #
 #  Parameters:   newx   - Width of new image
 #                newy   - Height of new image
 #                src    - Source image
 #                dest   - Destination image (optional)
 #
 #  Returns:      destination image
 #  Author: David Easton, wiki.tcl.tk, 2004

#only works for even-sided zooming!
	
	set mx [image width $src]
	set my [image height $src]
	
	puts "Resizing from $mx $my to $newx $newy" 
	
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

