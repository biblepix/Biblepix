# ~/Biblepix/progs/src/pic/hgbild.tcl
# Creates background picture, called by image.tcl
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 7mai2017

source $Imgtools  

proc fgbild>hgbild {hgfile bmpfile} {
#Puts text picture on background image, adding Sun & Shade pixels
global Config platform TwdTIF TwdPNG TwdBMP screenx fontcolor fgrgb
	
	#Source config to reset marginleft (rtl/ltr)
	source $Config
	puts "Copying text to background picture..."
		
	fgbild blank
	fgbild read $bmpfile
	hgbild blank
	hgbild read $hgfile	
	
	set imgx [image width fgbild]
	set imgy [image height fgbild]
	set bmpname [file tail $bmpfile]
		
	#Reset marginleft for Arabic & Hebrew
	if {	[string range $bmpname 0 1] == "he" ||
		[string range $bmpname 0 1] == "fa" ||
		[string range $bmpname 0 1] == "ar" ||
		[string range $bmpname 0 1] == "ur"
	} {
		set marginleft [expr $screenx-$imgx-$marginleft]
	}

	#Set fontcolor $rgb & sun/shade only once - CAN'T BECAUSE THESE ARE FLEETING VARS!
	#if {![info exists rgb]} {
		set rgb [hex2rgb $fontcolor]
	#}
	#if {![info exists sunhex]} {
		set sunhex [setSun $rgb] 
	#}
	#if {![info exists shadehex]} {
		set shadehex [setShade $rgb]
	#}

	# 1.Copy sun pixels -1
	for {set x 0; set zx [expr $marginleft - 1]} {$x<$imgx} {incr x; incr zx} {
		for {set y 0; set zy [expr $margintop - 1]} {$y<$imgy} {incr y; incr zy} {
			set colour [fgbild get $x $y]
			if {$colour==$fgrgb} {
				hgbild put $sunhex -to $zx $zy
			}
		}
	}

	# 2. Copy shade pixels +1
	for {set x 0; set zx [expr $marginleft + 1]} {$x<$imgx} {incr x; incr zx} {
		for {set y 0; set zy [expr $margintop + 1]} {$y<$imgy} {incr y; incr zy} {
			set colour [fgbild get $x $y]
			if {$colour==$fgrgb} {
				hgbild put $shadehex -to $zx $zy
			}
		}
	}
    
	# 3. Copy fontcolour pixels 0
	for {set x 0; set zx $marginleft} {$x<$imgx} {incr x; incr zx} {
		for {set y 0; set zy $margintop} {$y<$imgy} {incr y; incr zy} {
			set colour [fgbild get $x $y]
			if {$colour==$fgrgb} {
				hgbild put $fontcolor -to $zx $zy
			}
		}
	}
	
	#Save hgbild as TIFF for Win
	if {$platform=="windows"} {	
		hgbild write $TwdTIF -format TIFF
	
	#Save hagbild as PNG & BMP for Unix (KDE/GNOME need 2 for slideshow) 
	} elseif {$platform=="unix"} {
		hgbild write $TwdBMP -format BMP
		hgbild write $TwdPNG -format PNG
	}
    	
} ;#end fgbild>hgbild

proc checkRebuildBMP {} {
#Recreate fgbild if end of row pixels are bg-colour
#instead of font colour (=unfinished pic)
set imgy [image height fgbild]

#get end row pixel
set errrgb [fgbild get 0 [expr $imgy-1] ]
lassign $errrgb r g b
set errhex [format #%02x%02x%02x $r $g $b]

#Rebuild bmp file once if wrong colour
	if {$errhex == $hghex} {
            puts "Rebuilding bmp..."
		regsub ".bmp" $bmpname ".twd" twdfile
		source $Textbild
		text>bmp $bmpfile $twdfile
		fgbild blank
		fgbild read $bmpfile
		set imgx [image width fgbild]
		set imgy [image height fgbild]
        }
} ;#end checkRebuildBMP

proc checkImgSize {} {
#called by image.tcl
#rezises background JPEGs
	global hgfile screenx screeny jpegdir Imgtools
	
	set imgx [image width hgbild]
	set imgy [image height hgbild]
	#diffs -/+
	set diffx [expr $screenx-$imgx]
	set diffy [expr $screeny-$imgy]
	
	variable factor 0
	
	## 1. P R E  Z O O M
	#Double or halve img if different from screen
	
	#beg MAIN
	if {$diffx || $diffy} {
		# Bild zu breit
		if {$diffx<0} {
			#abrunden, damit nicht zu klein
			set factor [expr $imgx/$screenx]
			set zoom -subsample
		# Bild zu schmal
		} elseif {$diffx>200} {
			#aufrunden, damit nicht zu klein
			set zoom -zoom
			set factor [expr round($screenx./$imgx)]
		}
		
		#Zoom either way
		if {$factor>1} {
			#??	if {$zoom=="-zoom"} {set zoomvar up} else {set zoomvar down}
			image create photo tmpimg
			tmpimg copy hgbild $zoom $factor
			hgbild blank
			hgbild copy tmpimg -shrink 
		} 		
		
		#reset vars
		set imgx [image width hgbild]
		set imgy [image height hgbild]
		#diffs - oder +
		set diffx [expr $screenx-$imgx]
		set diffy [expr $screeny-$imgy]
		
	## 2. F I N E - C U T  - correct uneven sides
	#Syntax: x1 y1 x2 y2
	
	#check if sides uneven
		if {$diffx==$diffy} {} else {
			source $Imgtools
			puts "Correcting uneven image edges..."
		#1. diffx und diffy - (grösser als screen)
			if {$diffx<0 && $diffy<0} {
				regsub {\-} $diffx {} diffx
				regsub {\-} $diffy {} diffy
				if {$diffx>$diffy } {
					set diff [expr $diffx-$diffy]
					cutx hgbild $diff
				} else {
					set diff [expr $diffy-$diffx]
					cuty hgbild $diff
				}
		#2. diffx & diffy + (kleiner als screen)
			} elseif {$diffx>0 && $diffy>0} {
				if {$diffx>$diffy } {
					set diff [expr $diffx-$diffy]
					cutx hgbild $diff
				} else {
					set diff [expr $diffy-$diffx]
					cuty hgbild $diff
				}
	    #3. diffs einmal + und einmal - 
			} else {
				#X im Minus
				if {$diffx < $diffy} {
					regsub {\-} $diffx {} diffx
					set diff [expr $diffy+$diffx]
					cutx hgbild $diff
				#Y im Minus
				} else {
					regsub {\-} $diffy {} diffy
					set diff [expr $diffy+$diffx]
					cuty hgbild $diff
				} 
			}
		} ;#end fine cut
		
		#set new dimensions
		set imgx [image width hgbild]
		set imgy [image height hgbild]
		puts "Image after cutting: $imgx $imgy  "
		
	## 3. R E S I Z E  even-sided hgbild if necessary
	
		if {$screenx!=$imgx} {
			source $Imgtools
			image create photo imgneu -width 0 -height 0
			resize hgbild $screenx $screeny imgneu
			hgbild blank
			hgbild copy imgneu -shrink
		}
		
	
	#Save corrected image
		hgbild write $hgfile -format JPEG
		puts "Saving resized image [image width hgbild]x[image height hgbild] to $jpegdir"
		
	} ;#end MAIN

} ;#end checkImageSize
