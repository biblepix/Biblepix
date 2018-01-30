# ~/Biblepix/prog/src/gui/setupDesktop.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 29jan18

#Create left & right main frames
pack [frame .nb.desktop.fleft] -expand 0 -fill y -side left
pack [frame .nb.desktop.fright] -expand 0 -fill y -side right -pady 5 -padx 5

#Create left & right subframes
#pack [frame .nb.desktop.fleft.f1] [frame .nb.desktop.fleft.f2] -fill none -expand 0 -fill x -side left
pack [frame .nb.desktop.fright.ftop -relief ridge -borderwidth 3] -fill x -expand 0 -pady 2
pack [frame .nb.desktop.fright.fbot -relief ridge -borderwidth 3] -pady $py -padx $px -fill x -expand 0
pack [frame .nb.desktop.fright.fbot1] -pady $py -fill x
pack [frame .nb.desktop.fright.fbot2] -fill x

#F I L L   L E F T 

#Create title
label .nb.desktop.fleft.baslik -textvar f2.tit -font bpfont3

#1. ImageYesno checkbutton 
checkbutton .nb.desktop.fleft.imgyes -textvar f2.box -variable imgyesState -width 20 -justify left -command {setSpinState $imgyesState}
if {$enablepic} {set imgyesState 1} else {set imgyesState 0}
set imgyesnoBtn .nb.desktop.fleft.imgyes

#2. Main text
message .nb.desktop.fleft.intro -textvar f2.txt -font bpfont1 -width 500 -padx $px -pady $py -justify left

#P A C K   L E F T 
pack .nb.desktop.fleft.baslik -anchor w
pack $imgyesnoBtn -side top -anchor w
pack .nb.desktop.fleft.intro -anchor nw


# F I L L   R I G H T

#3. ShowDate checkbutton
checkbutton .nb.desktop.fright.ftop.introBtn -textvar f2.introline -variable enabletitle
set showdateBtn .nb.desktop.fright.ftop.introBtn
$showdateBtn configure -command {
  if {$setupTwdFileName != ""} {
    $textposCanv itemconfigure mv -text [getTodaysTwdText $setupTwdFileName]
  }
}

#4. SlideshowYesNo checkbutton
checkbutton .nb.desktop.fright.ftop.slideBtn -textvar f2.slideshow -variable slideshowState -command {setSlideSpin $slideshowState}
set slideBtn .nb.desktop.fright.ftop.slideBtn

#5. Slideshow spinbox
message .nb.desktop.fright.ftop.slidetxt -textvar f2.int -width 200
set slideTxt .nb.desktop.fright.ftop.slidetxt
message .nb.desktop.fright.ftop.sectxt -text sec -width 100
set slideSec .nb.desktop.fright.ftop.sectxt
spinbox .nb.desktop.fright.ftop.slideSpin -from 10 -to 600 -increment 10 -width 3
set slideSpin .nb.desktop.fright.ftop.slideSpin
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

set screenX [winfo screenwidth .]
set screenY [winfo screenheight .]

set textposCanv [canvas .nb.desktop.fright.fbot.textposcanv -bg lightgrey -borderwidth 1]
$textposCanv configure -width [image width canvasbild] -height [expr $screenY/$textPosFactor]
$textposCanv create image 0 0 -image canvasbild -anchor nw

set textposTxt [label .nb.desktop.fright.fbot.textpostxt -textvar textpos]
createMovingTextBox $textposCanv
$textposCanv bind mv <1> {movestart %W %x %y}
$textposCanv bind mv <B1-Motion> {move %W %x %y [expr $screenX/$textPosFactor] [expr $screenY/$textPosFactor]}


#2. Create InternationalText Canvas
if {! [regexp displayfont [font names] ] } {
  font create displayfont -family $fontfamily -size -$fontsize -weight bold
}

canvas .nb.desktop.fright.fbot2.inttextcanv -width 700 -height 150 -borderwidth 2 -relief raised
set inttextCanv .nb.desktop.fright.fbot2.inttextcanv

#create background image
image create photo intTextBG -file $guidir/testbild.png
$inttextCanv create image 0 0 -image intTextBG -anchor nw 

# set international text
set inttextHeader [label .nb.desktop.fright.fbot2.inttexttxt -textvar f2.fontexpl]
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
message .nb.desktop.fright.fbot1.fontcolorTxt -width 200 -textvar f2.farbe
spinbox .nb.desktop.fright.fbot1.fontcolorSpin -width 10 -values {blue green gold silver} 
set fontcolorTxt .nb.desktop.fright.fbot1.fontcolorTxt
set fontcolorSpin .nb.desktop.fright.fbot1.fontcolorSpin
$fontcolorSpin configure -command {
  setCanvasText [set %s]
     #   $textposCanv itemconfigure mv -fill %s
        }

$fontcolorSpin set $fontcolortext

#2. Fontsize spinbox
if {!$fontsize} {
  #set initial font size if no $config found
  set screenY [winfo screenheight .]
  set fontsize [ expr round($screenY/40) ] 
}

message .nb.desktop.fright.fbot1.fontsizeTxt -width 200 -textvar f2.fontsizetext
spinbox .nb.desktop.fright.fbot1.fontsizeSpin -width 2 -from 20 -to 40 -command {font configure displayfont -size -%s}
set fontsizeTxt .nb.desktop.fright.fbot1.fontsizeTxt
set fontsizeSpin .nb.desktop.fright.fbot1.fontsizeSpin
$fontsizeSpin set $fontsize

#3. Fontweight checkbutton
checkbutton .nb.desktop.fright.fbot1.fontweightBtn -width 5 -variable fontweightState -textvar f2.fontweight 
set fontweightBtn .nb.desktop.fright.fbot1.fontweightBtn
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

#4. Fontfamily dropdown Menu
message .nb.desktop.fright.fbot1.fontfamilyTxt -width 250 -textvar f2.fontfamilytext
ttk::combobox .nb.desktop.fright.fbot1.fontfamilyDrop -width 20 -height 30
set fontfamilyTxt .nb.desktop.fright.fbot1.fontfamilyTxt
set fontfamilySpin .nb.desktop.fright.fbot1.fontfamilyDrop

##get System font list + add TkTextFont
set Fontlist [lsort [font families]]
lappend Fontlist TkTextFont
$fontfamilySpin configure -values $Fontlist -validate focusin -validatecommand {
  font configure displayfont -family [$fontfamilySpin get]
  return 0
}
##set current fontfamily
$fontfamilySpin set $fontfamily

#P A C K   R I G H T

#pack [frame .nb.desktop.fright.f1]
pack $showdateBtn -anchor w

pack $slideBtn -anchor w -side left
pack $slideSec $slideSpin $slideTxt -anchor nw -side right

pack $textposTxt -pady 5
pack $textposCanv -anchor n -fill none

pack $fontcolorTxt $fontcolorSpin $fontfamilyTxt $fontfamilySpin -side left -fill x
pack $fontweightBtn $fontsizeSpin $fontsizeTxt -side right -fill x

pack $inttextCanv -fill x
pack $inttextHeader -pady 7
