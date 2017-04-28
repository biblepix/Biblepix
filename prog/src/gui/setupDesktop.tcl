# ~/Biblepix/prog/src/gui/setupDesktop.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 23apr17

set screenx [winfo screenwidth .]
set screeny [winfo screenheight .]

#Create left & right main frames
pack [frame .n.f2.fleft] -expand 0 -fill y -side left
pack [frame .n.f2.fright] -expand 0 -fill y -side right -pady 5 -padx 5

#Create left & right subframes
#pack [frame .n.f2.fleft.f1] [frame .n.f2.fleft.f2] -fill none -expand 0 -fill x -side left
pack [frame .n.f2.fright.ftop -relief ridge -borderwidth 3] -fill x -expand 0 -pady 2
pack [frame .n.f2.fright.fbot] -pady $py -padx $px -fill x -expand 0
pack [frame .n.f2.fright.fbot1] -pady $py -fill x 
pack [frame .n.f2.fright.fbot2] -fill x

#F I L L   L E F T 

#Create title
label .n.f2.fleft.baslik -textvar f2.tit -font bpfont3

#1. ImageYesno checkbutton 
checkbutton .n.f2.fleft.imgyes -textvar f2.box -variable imgyesState -width 20 -justify left -command {setSpinState $imgyesState}
if {$enablepic} {set imgyesState 1} else {set imgyesState 0}
set imgyesnoBtn .n.f2.fleft.imgyes

#2. Main text
message .n.f2.fleft.intro -textvar f2.txt -font bpfont1 -width 500 -padx $px -pady $py -justify left

#P A C K   L E F T 
pack .n.f2.fleft.baslik -anchor w
pack $imgyesnoBtn -side top -anchor w
pack .n.f2.fleft.intro -anchor nw


# F I L L   R I G H T

#3. ShowDate checkbutton
checkbutton .n.f2.fright.ftop.introBtn -textvar f2.introline -variable enableintro
#if {$enableintro} {set introlineState 1} else {set introlineState 0}
set showdateBtn .n.f2.fright.ftop.introBtn
$showdateBtn configure -command {
	set textfile [getRandomTWDFile]
        if {$textfile != ""} {
        	$textposCanv itemconfigure mv -text [formatImgText [getRandomTWDFile] ]
        }
}

#4. SlideshowYesNo checkbutton
checkbutton .n.f2.fright.ftop.slideBtn -textvar f2.slideshow -variable slideshowState -command {setSlideSpin $slideshowState}
set slideBtn .n.f2.fright.ftop.slideBtn

#5. Slideshow spinbox
message .n.f2.fright.ftop.slidetxt -textvar f2.int -width 200
set slideTxt .n.f2.fright.ftop.slidetxt
message .n.f2.fright.ftop.sectxt -text sec -width 100
set slideSec .n.f2.fright.ftop.sectxt
spinbox .n.f2.fright.ftop.slideSpin -from 10 -to 600 -increment 10 -width 3
set slideSpin .n.f2.fright.ftop.slideSpin
$slideSpin set $slideshow
if {!$slideshow} {
	$slideBtn deselect 
	set slideshowState 0
	$slideSpin configure -state disabled
} else {
	$slideBtn select
	set slideshowState 1
	$slideSpin configure -state normal
}

#1. Create TextPos Canvas
set textPosFactor 3
image create photo origbild -file [getRandomJPG]
image create photo canvasbild
canvasbild copy origbild -subsample $textPosFactor -shrink

set textposCanv [canvas .n.f2.fright.fbot.textposcanv -bg lightgrey -borderwidth 1]
$textposCanv configure -width [image width canvasbild] -height [expr $screeny/$textPosFactor]
$textposCanv create image 0 0 -image canvasbild -anchor nw

set textposTxt [label .n.f2.fright.fbot.textpostxt -textvar textpos]
createMovingTextBox $textposCanv
$textposCanv bind mv <1> {movestart %W %x %y}
$textposCanv bind mv <B1-Motion> {move %W %x %y}


#2. Create InternationalText Canvas
if {! [regexp displayfont [font names] ] } {
	font create displayfont -family $fontfamily -size -$fontsize -weight bold
}

canvas .n.f2.fright.fbot2.inttextcanv -width 700 -height 300 -borderwidth 2 -relief raised
set inttextCanv .n.f2.fright.fbot2.inttextcanv

#create background image - TESTING!
image create photo intTextBG -file $guidir/testbild.png -height 300 -width 700
$inttextCanv create image 0 0 -image intTextBG -anchor nw 

# set international text
set inttextHeader [label .n.f2.fright.fbot2.inttexttxt -textvar f2.fontexpl]
if {$platform=="unix"} {
	set ar_txt [string reverse $f2ar_txt]
	set he_txt [string reverse $f2he_txt]
	set internationaltext "$f2ltr_txt $ar_txt $he_txt $f2thai_txt"
} else {
	set internationaltext "$f2ltr_txt $f2ar_txt $f2he_txt $f2thai_txt"
}
#create sun / shade /main text
source $Imgtools
set rgblist [hex2rgb $fontcolor]
set shade [setShade $rgblist]
set sun [setSun $rgblist]

$inttextCanv create text 09 19 -fill $sun -tags {textitem sun}
$inttextCanv create text 11 21 -fill $shade -tags {textitem shade}
$inttextCanv create text 10 20 -fill $fontcolor -tags {textitem main}
$inttextCanv itemconfigure textitem -text $internationaltext -anchor nw -width 680 -font displayfont

#1. Fontcolour spinbox
message .n.f2.fright.fbot1.fontcolorTxt -width 200 -textvar f2.farbe
spinbox .n.f2.fright.fbot1.fontcolorSpin -width 10 -values {blue green gold silver} 
set fontcolorTxt .n.f2.fright.fbot1.fontcolorTxt
set fontcolorSpin .n.f2.fright.fbot1.fontcolorSpin
$fontcolorSpin configure -command {
	setCanvasText [set %s]
     #   $textposCanv itemconfigure mv -fill %s
        }

$fontcolorSpin set $fontcolortext

#2. Fontsize spinbox
if {!$fontsize} {
	#set initial font size if no $config found
	set screeny [winfo screenheight .]
	set fontsize [ expr round($screeny/40) ] 
}

message .n.f2.fright.fbot1.fontsizeTxt -width 200 -textvar f2.fontsizetext
spinbox .n.f2.fright.fbot1.fontsizeSpin -width 2 -from 20 -to 40 -command {font configure displayfont -size -%s}
set fontsizeTxt .n.f2.fright.fbot1.fontsizeTxt
set fontsizeSpin .n.f2.fright.fbot1.fontsizeSpin
$fontsizeSpin set $fontsize


#3. Fontweight checkbutton
checkbutton .n.f2.fright.fbot1.fontweightBtn -width 5 -variable fontweightState -textvar f2.fontweight 
set fontweightBtn .n.f2.fright.fbot1.fontweightBtn
$fontweightBtn configure -command {
	if {$fontweightState==1} {
		font configure displayfont -weight bold
	} else {
		font configure displayfont -weight normal
   	}
}

if {$fontweight=="bold"} {
	set fontweightState 1
        font configure displayfont -weight bold
} else {
	set fontweightState 0
	font configure displayfont -weight normal
}


#4. Fontfamily spinbox
message .n.f2.fright.fbot1.fontfamilyTxt -width 250 -textvar f2.fontfamilytext

set Fontlist [font families]
set MyFonts ""

foreach i $Fontlist {
	#compare exact name
	set Fontname [array names BpFonts $i]
	if { $Fontname != "" } {
        	lappend MyFonts $Fontname
	}	
}
#prevent empty list
lappend MyFonts TkTextFont
lsort $MyFonts

spinbox .n.f2.fright.fbot1.fontfamilySpin -values $MyFonts -width 15 -command {font configure displayfont -family %s}
set fontfamilyTxt .n.f2.fright.fbot1.fontfamilyTxt
set fontfamilySpin .n.f2.fright.fbot1.fontfamilySpin

$fontfamilySpin set $fontfamily

#P A C K   R I G H T

#pack [frame .n.f2.fright.f1]
pack $showdateBtn -anchor w

pack $slideBtn -anchor w -side left
pack $slideSec $slideSpin $slideTxt -anchor nw -side right

pack $textposTxt -pady 5
pack $textposCanv -anchor n -fill none

pack $fontcolorTxt $fontcolorSpin $fontfamilyTxt $fontfamilySpin -side left -fill x
pack $fontweightBtn $fontsizeSpin $fontsizeTxt -side right -fill x

pack $inttextCanv -fill x
pack $inttextHeader -pady 7
