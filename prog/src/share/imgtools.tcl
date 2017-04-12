# ~/Biblepix/prog/src/share/imgtools.tcl
# Image manipulating procs
# Called by SetupGui
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 12apr17

####### Procs for $Hgbild #####################

proc rgb2hex {r g b} {
#called by setShade + setSun
	set hex [format "#%02x%02x%02x" $r $g $b]
	return $hex
}

proc hex2rgb {hex} {
#called by Hgbild 
#A: calculate into 3-fold string
	set rgb [scan $hex "#%2x%2x%2x"]

#B: calculate into 3 separate strings (0x=hex for expr)
	set rx "0x[string range $hex 1 2]"
	set gx "0x[string range $hex 3 4]"
	set bx "0x[string range $hex 5 6]"
	set ::r [expr $rx]
	set ::g [expr $gx]
	set ::b [expr $bx]
	return $rgb
	#return "$::r $::g $::b"
}

proc setShade {r g b} {
#called by Hgbild
global shadefactor
	#darkness values under 0 don't matter 
	set rsh [expr {int($r*$shadefactor)}]
	set gsh [expr {int($g*$shadefactor)}]
	set bsh [expr {int($b*$shadefactor)}]
	set shade [rgb2hex $rsh $gsh $bsh]
	return $shade
}

proc setSun {r g b} {
#called by Hgbild
global sunfactor
	set rsun [expr {int($r * $sunfactor)}]
	set gsun [expr {int($g * $sunfactor)}]
	set bsun [expr {int($b * $sunfactor)}]
	#avoid brightness values over 255
	if {$rsun>255} {set rsun 255}
	if {$gsun>255} {set gsun 255}
	if {$bsun>255} {set bsun 255}
	set sun [rgb2hex $rsun $gsun $bsun]
	return $sun
}
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

