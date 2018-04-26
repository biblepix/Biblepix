# ~/Biblepix/prog/src/gui/setupDesktop.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15apr18

#Create left & right main frames
pack [frame .desktopF.fleft] -expand 0 -fill y -side left
pack [frame .desktopF.fright] -expand 0 -fill y -side right -pady 5 -padx 5

#Create left & right subframes
#pack [frame .desktopF.fleft.f1] [frame .desktopF.fleft.f2] -fill none -expand 0 -fill x -side left
pack [frame .desktopF.fright.ftop -relief ridge -borderwidth 3] -fill x -expand 0 -pady 2
pack [frame .desktopF.fright.fbot -relief ridge -borderwidth 3] -pady $py -padx $px -fill x -expand 0
pack [frame .desktopF.fright.fbot1] -pady $py -fill x
pack [frame .desktopF.fright.fbot2] -fill x

#F I L L   L E F T 

#Create title
label .desktopF.fleft.baslik -textvar f2.tit -font bpfont3

#1. ImageYesno checkbutton 
checkbutton .desktopF.fleft.imgyes -textvar f2.box -variable imgyesState -width 20 -justify left -command {setSpinState $imgyesState}
if {$enablepic} {set imgyesState 1} else {set imgyesState 0}
set imgyesnoBtn .desktopF.fleft.imgyes

#2. Main text
message .desktopF.fleft.intro -textvar f2.txt -font bpfont1 -width 500 -padx $px -pady $py -justify left

#P A C K   L E F T 
pack .desktopF.fleft.baslik -anchor w
pack $imgyesnoBtn -side top -anchor w
pack .desktopF.fleft.intro -anchor nw


# F I L L   R I G H T

#3. ShowDate checkbutton
checkbutton .desktopF.fright.ftop.introBtn -textvar f2.introline -variable enabletitle
set showdateBtn .desktopF.fright.ftop.introBtn
$showdateBtn configure -command {
  if {$setupTwdFileName != ""} {
    .textposCanv itemconfigure mv -text [getTodaysTwdText $setupTwdFileName]
  }
}

#4. SlideshowYesNo checkbutton
checkbutton .desktopF.fright.ftop.slideBtn -textvar f2.slideshow -variable slideshowState -command {setSlideSpin $slideshowState}
set slideBtn .desktopF.fright.ftop.slideBtn

#5. Slideshow spinbox
message .desktopF.fright.ftop.slidetxt -textvar f2.int -width 200
set slideTxt .desktopF.fright.ftop.slidetxt
message .desktopF.fright.ftop.sectxt -text sec -width 100
set slideSec .desktopF.fright.ftop.sectxt
spinbox .desktopF.fright.ftop.slideSpin -from 10 -to 600 -increment 10 -width 3
set slideSpin .desktopF.fright.ftop.slideSpin
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
image create photo origbild -file [getRandomPhoto]
image create photo canvasbild
canvasbild copy origbild -subsample $textPosFactor -shrink
set screeny [winfo screenheight .]

canvas .textposCanv -bg lightgrey -borderwidth 1
.textposCanv conf -width [image width canvasbild] -height [expr $screeny/$textPosFactor]
.textposCanv create image 0 0 -image canvasbild -anchor nw

set textposTxt [label .desktopF.fright.fbot.textpostxt -textvar textpos]
createMovingTextBox .textposCanv

.textposCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
.textposCanv bind mv <B1-Motion> [list dragCanvasItem %W mv %X %Y]



# TODO for BDF: leave all below as it is, only adjust font sizes a bit, 
# and add a Serif font for "Times" !

#2. Create InternationalText Canvas
if {! [regexp displayfont [font names] ] } {
  font create displayfont -family $fontfamily -size -$fontsize -weight bold
}

canvas .desktopF.fright.fbot2.inttextcanv -width 700 -height 150 -borderwidth 2 -relief raised
set inttextCanv .desktopF.fright.fbot2.inttextcanv

#create background image
image create photo intTextBG -file $guidir/testbild.png
$inttextCanv create image 0 0 -image intTextBG -anchor nw 

# set international text
set inttextHeader [label .desktopF.fright.fbot2.inttexttxt -textvar f2.fontexpl]
if {$platform=="unix"} {
  source $Bidi
  set ar_txt [fixArabUnix $f2ar_txt]
  set he_txt [fixHebUnix $f2he_txt]  
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
message .desktopF.fright.fbot1.fontcolorTxt -width 200 -textvar f2.farbe
spinbox .desktopF.fright.fbot1.fontcolorSpin -width 10 -values {blue green gold silver} 
set fontcolorTxt .desktopF.fright.fbot1.fontcolorTxt
set fontcolorSpin .desktopF.fright.fbot1.fontcolorSpin
$fontcolorSpin configure -command {
  setCanvasText [set %s]
     #   .textposCanv itemconfigure mv -fill %s
        }

$fontcolorSpin set $fontcolortext

#2. Fontsize spinbox - TODO: this needs reworking to be in line with FontNames
if {!$fontsize} {
  #set initial font size if no $config found
  set screeny [winfo screenheight .]
  set fontsize [ expr round($screeny/40) ] 
}

message .desktopF.fright.fbot1.fontsizeTxt -width 200 -textvar f2.fontsizetext
spinbox .desktopF.fright.fbot1.fontsizeSpin -width 2 -values {20 24 30} -command {font configure displayfont -size %s}
set fontsizeTxt .desktopF.fright.fbot1.fontsizeTxt
set fontsizeSpin .desktopF.fright.fbot1.fontsizeSpin
$fontsizeSpin set $fontsize

#3. Fontweight checkbutton - TODO: needs reworking to be in line with FontNames
checkbutton .desktopF.fright.fbot1.fontweightBtn -width 5 -variable fontweightState -textvar f2.fontweight 
set fontweightBtn .desktopF.fright.fbot1.fontweightBtn
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




#4. Fontfamily dropdown Menu - TODO: needs reworking to display only plain names like "Arial" and "Times"
message .desktopF.fright.fbot1.fontfamilyTxt -width 250 -textvar f2.fontfamilytext
ttk::combobox .desktopF.fright.fbot1.fontfamilyDrop -width 20 -height 30
set fontfamilyTxt .desktopF.fright.fbot1.fontfamilyTxt
set fontfamilySpin .desktopF.fright.fbot1.fontfamilyDrop

##get BDF font list
#foreach i [glob -directory $fontdir -tails *.tcl] {
#  lappend Fontlist [file root $i]
#}

lappend Fontlist Arial Times

#set Fontlist [lsort [font families]]
#lappend Fontlist TkTextFont

$fontfamilySpin configure -values [lsort $Fontlist] -validate focusin -validatecommand {
  font configure displayfont -family [$fontfamilySpin get]
  return 0
}
##set current fontfamily
$fontfamilySpin set $fontfamily

#P A C K   R I G H T

#pack [frame .desktopF.fright.f1]
pack $showdateBtn -anchor w

pack $slideBtn -anchor w -side left
pack $slideSec $slideSpin $slideTxt -anchor nw -side right

pack $textposTxt -pady 5
pack .textposCanv -in .desktopF.fright.fbot

pack $fontcolorTxt $fontcolorSpin $fontfamilyTxt $fontfamilySpin -side left -fill x

pack $fontweightBtn $fontsizeSpin $fontsizeTxt -side right -fill x

#TODO: delete functions por completo! - NO!
#$fontweightBtn configure -state disabled
#$fontsizeSpin configure -state disabled

pack $inttextCanv -fill x
pack $inttextHeader -pady 7
