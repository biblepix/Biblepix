# ~/Biblepix/prog/src/gui/setupDesktop.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 19nov16

set screenx [winfo screenwidth .]
set screeny [winfo screenheight .]

#Create title
label .n.f2.baslik -textvar f2.tit -font $f3
pack .n.f2.baslik -anchor w

#Create main frames -untereinander
pack [frame .n.f2.topframe1] -fill x
pack [frame .n.f2.topframe2] -fill x
pack [frame .n.f2.mainframe] -fill x

#Create topframe1.subframes -nebeneinander
pack [frame .n.f2.topframe1.sol -pady $py] -side left -anchor n -fill x 
pack [frame .n.f2.topframe1.orta] -expand true -side left -fill x
pack [frame .n.f2.topframe1.sagh -pady $py] -side left -anchor n -fill x
 
 #checkbox frames R - untereinander
pack [frame .n.f2.topframe1.sagh.f1] -anchor n -fill x
pack [frame .n.f2.topframe1.sagh.f5 -pady 30] -fill x
 
#Create topframe2.subframes -nebeneinander
pack [frame .n.f2.topframe2.links -padx $px -pady $py] -side left -fill x -expand true
pack [frame .n.f2.topframe2.rechts -pady $py] -side right -fill x 
 #spinbox frames - untereinander
pack [frame .n.f2.topframe2.rechts.f2] -anchor w
pack [frame .n.f2.topframe2.rechts.f3] -anchor w
pack [frame .n.f2.topframe2.rechts.f4] -anchor w


#FILL TOPFRAME1

 #1. ImageYesno checkbutton 
checkbutton .n.f2.topframe1.sol.imgyes -textvar f2.box -variable imgyesState -width 20 -justify left
if {$enablepic} {set imgyesState 1} else {set imgyesState 0}
pack .n.f2.topframe1.sol.imgyes -side top -anchor w

 #2. TextPos Canvas
set textPosFactor 10
canvas .n.f2.topframe1.orta.textposcanv -bg darkgray -borderwidth 5 -width [expr $screenx/$textPosFactor] -height [expr $screeny/$textPosFactor]
label .n.f2.topframe1.orta.textpostxt -textvar textpos
pack .n.f2.topframe1.orta.textposcanv .n.f2.topframe1.orta.textpostxt
#create moving item
set textPosSubwinX [expr $screenx/20]
set textPosSubwinY [expr $screeny/30]

.n.f2.topframe1.orta.textposcanv create rectangle [expr $marginleft/$textPosFactor] [expr $margintop/$textPosFactor] [expr ($marginleft/$textPosFactor)+$textPosSubwinX] [expr ($margintop/$textPosFactor)+$textPosSubwinY] -tags mv -fill lightblue -outline lightblue -activeoutline red
.n.f2.topframe1.orta.textposcanv bind mv <1> {movestart %W %x %y}
.n.f2.topframe1.orta.textposcanv bind mv <B1-Motion> {move %W %x %y}


#3. ShowDate checkbutton
checkbutton .n.f2.topframe1.sagh.f1.introline -textvar f2.introline -variable introlineState
if {$enableintro} {set introlineState 1} else {set introlineState 0}

#4. Slideshow checkbutton
message .n.f2.topframe1.sagh.f5.txt -textvar f2.int -width 200
spinbox .n.f2.topframe1.sagh.f5.spin -from 10 -to 600 -increment 10 -width 3 
.n.f2.topframe1.sagh.f5.spin set $slideshow
message .n.f2.topframe1.sagh.f5.sec -text sec -width 100

pack .n.f2.topframe1.sagh.f1.introline -anchor nw -side top

pack .n.f2.topframe1.sagh.f5.txt -side left -anchor sw
pack .n.f2.topframe1.sagh.f5.spin -side left 
pack .n.f2.topframe1.sagh.f5.sec -side left


#FILL TOPFRAME2
 
#1. L: InternationalText Canvas
if {! [regexp displayfont [font names] ] } {
	font create displayfont -family $fontfamily -size -$fontsize -weight bold
}
canvas .n.f2.topframe2.links.canv -width 650 -height 70 -background steelblue
pack .n.f2.topframe2.links.canv -anchor n
pack [label .n.f2.topframe2.links.txt -textvar f2.fontexpl] -anchor n

#create international text
if {$platform=="unix"} {
	set ar_txt [string reverse $f2ar_txt]
	set he_txt [string reverse $f2he_txt]
	set internationaltext "$f2ltr_txt $ar_txt $he_txt"
} else {
	set internationaltext "$f2ltr_txt $f2ar_txt $f2he_txt"
}

#create shaded text, 1px versetzt
.n.f2.topframe2.links.canv create text 9 19 -fill $shade -font displayfont -tags shadedtextitem
#create main text
.n.f2.topframe2.links.canv create text 10 20 -fill $fontcolor -font displayfont -tags textitem

.n.f2.topframe2.links.canv itemconfigure textitem -text $internationaltext -anchor w
.n.f2.topframe2.links.canv itemconfigure shadedtextitem -text $internationaltext -anchor w

#1. R: Fontcolour spinbox
message .n.f2.topframe2.rechts.f2.txt -width 200 -textvar f2.farbe
spinbox .n.f2.topframe2.rechts.f2.spin -width 7 -values {blue green gold silver} -command {.n.f2.topframe2.links.canv itemconfigure textitem -fill %s}
pack .n.f2.topframe2.rechts.f2.txt .n.f2.topframe2.rechts.f2.spin -side left
.n.f2.topframe2.rechts.f2.spin set $fontcolortext

#2.R: Fontsize spinbox
if {!$fontsize} {
	#set initial font size if no $config found
	set screeny [winfo screenheight .]
	set fontsize [ expr round($screeny/40) ] 
}

message .n.f2.topframe2.rechts.f3.txt -width 200 -textvar f2.fontsizetext
spinbox .n.f2.topframe2.rechts.f3.spin -width 8 -from 20 -to 40 -command {font configure displayfont -size -%s}
.n.f2.topframe2.rechts.f3.spin set $fontsize
pack .n.f2.topframe2.rechts.f3.txt .n.f2.topframe2.rechts.f3.spin -side left

#3.R: Fontweight checkbutton
checkbutton .n.f2.topframe2.rechts.f3.fontweightbtn -width 5 -variable fontweightState -textvar f2.fontweight -command { if {$fontweightState==1} {font configure displayfont -weight bold} {font configure displayfont -weight normal} }
pack .n.f2.topframe2.rechts.f3.fontweightbtn -side right
if {$fontweight=="bold"} {
	set fontweightState 1
        font configure displayfont -weight bold
} else {
	set fontweightState 0
	font configure displayfont -weight normal
}


#4.R: Fontfamily spinbox
message .n.f2.topframe2.rechts.f4.txt -width 200 -textvar f2.fontfamilytext

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

spinbox .n.f2.topframe2.rechts.f4.spin -values $MyFonts -width 15 -command {font configure displayfont -family %s}
pack .n.f2.topframe2.rechts.f4.txt .n.f2.topframe2.rechts.f4.spin -side left
.n.f2.topframe2.rechts.f4.spin set $fontfamily


# FILL MAIN FRAME

#Create text window in mainframe
message .n.f2.mainframe.intro -textvar f2.txt -font $f1 -width $tw -padx $px -pady $py -justify left
pack .n.f2.mainframe.intro -anchor w
