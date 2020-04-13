# ~/Biblepix/prog/src/gui/setupDesktop.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 13apr20

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

# setCanvasFont
##called by SetupDesktop ... ... ... spinboxes & ... fontweight Button
proc setCanvasFont {} {
  global slideshowState 

#Fonts to adapt
displayfont ...
movingTextFont? ...
}

#1. Create TextPos Canvas

#TODO this makes no sense, link to Textsize window! 
set textPosFactor 3

image create photo origbild -file [getRandomPhoto]
image create photo canvasbild
canvasbild copy origbild -subsample $textPosFactor -shrink
set screeny [winfo screenheight .]

set c [canvas .textposCanv -bg lightgrey -borderwidth 1]
$c conf -width [image width canvasbild] -height [expr $screeny/$textPosFactor]
$c create image 0 0 -image canvasbild -anchor nw -tags img

set textposTxt [label .desktopF.fright.fbot.textpostxt -textvar textpos]
createMovingTextBox $c

.textposCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
.textposCanv bind mv <Button1-Motion> [list dragCanvasItem %W mv %X %Y]


#2. Create InternationalText Canvas - Fonts based on System fonts, not Bdf!!!!
## Tcl picks any available Sans or Serif font from the system

##Create generic Serif or Sans font - TODO change name to sth more usable!
font create displayfont -family $fontfamily -size $fontsize -weight $fontweight
canvas .desktopF.fright.fbot2.inttextcanv -width 700 -height 150 -borderwidth 2 -relief raised
set inttextCanv .desktopF.fright.fbot2.inttextcanv

##create background image
image create photo intTextBG -file $SetupDesktopPng
$inttextCanv create image 0 0 -image intTextBG -anchor nw 

# Set international text
set inttextHeader [label .desktopF.fright.fbot2.inttexttxt -textvar f2.fontexpl]

if {$os=="Linux"} {
  #Unix needs a lot of formatting for Arabic & Hebrew
  puts "Computing Arabic"
  source $BdfBidi
  
  #TODO pv: ARABISCH BLOCKIERT ALLES!!!! - vorläufig lassen
  #set f2ar_txt [bidi $f2ar_txt ar revert]
  set f2ar_txt [string reverse $f2ar_txt]
  set f2he_txt [bidi $f2he_txt he revert]
} 

set internationalText "$f2ltr_txt $f2ar_txt $f2he_txt $f2thai_txt"



#1. Fontcolour spinbox
message .desktopF.fright.fbot1.fontcolorTxt -width 200 -textvar f2.farbe
spinbox .desktopF.fright.fbot1.fontcolorSpin -width 10 -values {blue green gold silver} 
set fontcolorTxt .desktopF.fright.fbot1.fontcolorTxt
set fontcolorSpin .desktopF.fright.fbot1.fontcolorSpin

#TODO include setCanvasFont 
$fontcolorSpin configure -command {
  setIntCanvText [set %s]
  .textposCanv itemconfigure mv -fill %s
  }

$fontcolorSpin set $fontcolortext

#2. Fontsize spinbox - TODO: IS THIS NEEDED????
if {!$fontsize} {
  #set initial font size if no $config found
  set screeny [winfo screenheight .]
  set fontsize [ expr round($screeny/40) ] 
}

message .desktopF.fright.fbot1.fontsizeTxt -width 200 -textvar f2.fontsizetext

#TODO include in setFont proc!
spinbox .desktopF.fright.fbot1.fontsizeSpin -width 2 -values $fontSizeList -command {setCanvasFont $c}
#  font configure displayfont -size %s
#  font configure movingTextFont -size %s

  
set fontsizeTxt .desktopF.fright.fbot1.fontsizeTxt
set fontsizeSpin .desktopF.fright.fbot1.fontsizeSpin
$fontsizeSpin set $fontsize

#3. Fontweight checkbutton - TODO: needs reworking to be in line with FontNames
checkbutton .desktopF.fright.fbot1.fontweightBtn -width 5 -variable fontweightState -textvar f2.fontweight -command {setCanvasFont}
set fontweightBtn .desktopF.fright.fbot1.fontweightBtn


#create sun / shade /main text
if {$fontweight=="bold"} {
  set fontweightState 1
  font configure displayfont -weight bold
} else {
  set fontweightState 0
  font configure displayfont -weight normal
}

#4. Fontfamily dropdown Menu
message .desktopF.fright.fbot1.fontfamilyTxt -width 250 -textvar f2.fontfamilytext
ttk::combobox .desktopF.fright.fbot1.fontfamilyDrop -width 20 -height 30 
#TODO how to do this? -command {setCanvasFont}

set fontfamilyTxt .desktopF.fright.fbot1.fontfamilyTxt
set fontfamilySpin .desktopF.fright.fbot1.fontfamilyDrop
lappend Fontlist Serif Sans

source $ImgTools
setIntCanvText $fontcolor

$fontfamilySpin configure -values $Fontlist -validate focusin -validatecommand {
  font configure displayfont -family [$fontfamilySpin get]
  return 0
}
##set current fontfamily
$fontfamilySpin set $fontfamily


#P A C K   R I G H T
pack $showdateBtn -anchor w
pack $slideBtn -anchor w -side left
pack $slideSec $slideSpin $slideTxt -anchor nw -side right
pack $textposTxt -pady 5
pack .textposCanv -in .desktopF.fright.fbot
pack $fontcolorTxt $fontcolorSpin $fontfamilyTxt $fontfamilySpin -side left -fill x
pack $fontweightBtn $fontsizeSpin $fontsizeTxt -side right -fill x
pack $inttextCanv -fill x
pack $inttextHeader -pady 7
