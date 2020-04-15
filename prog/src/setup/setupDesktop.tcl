# ~/Biblepix/prog/src/setup/setupDesktop.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated Easter 15apr20 pv

#Create left & right main frames
pack [frame .desktopF.leftF] -fill y -side left
pack [frame .desktopF.rightF] -fill y -side right -pady 5 -padx 5

#Create right subframes
pack [frame .rtopF -relief ridge -borderwidth 0]  -in .desktopF.rightF -fill x

pack [frame .rbot1F -relief ridge -borderwidth 3] -in .desktopF.rightF -pady $py -padx $px -fill x
pack [frame .rbot1F.1F] -fill x
pack [frame .rbot1F.2F] -fill x

#pack [frame .rbot2F] -in .rbot1F -fill x
pack [frame .rbot2F -relief ridge -borderwidth 3] -in .desktopF.rightF -pady $py -padx $px -fill both

#F I L L   L E F T 

#Create title
label .desktopF.leftF.baslik -textvar f2.tit -font bpfont3

#1. ImageYesno checkbutton 
checkbutton .desktopF.leftF.imgyes -textvar f2.box -variable imgyesState -width 20 -justify left -command {setSpinState $imgyesState}
if {$enablepic} {set imgyesState 1} else {set imgyesState 0}
set imgyesnoBtn .desktopF.leftF.imgyes

#2. Main text
message .desktopF.leftF.intro -textvar f2.txt -font bpfont1 -width 500 -padx $px -pady $py -justify left

#P A C K   L E F T 
pack .desktopF.leftF.baslik -anchor w
pack $imgyesnoBtn -side top -anchor w
pack .desktopF.leftF.intro -anchor nw


# F I L L   R I G H T

#3. ShowDate checkbutton
checkbutton .showdateBtn -textvar f2.introline -variable enabletitle
.showdateBtn configure -command {
  if {$setupTwdFileName != ""} {
    .textposCanv itemconf mv -text [getTodaysTwdText $setupTwdFileName]
  }
}

#4. SlideshowYesNo checkbutton
checkbutton .slideBtn -textvar f2.slideshow -variable slideshowState -command {setSlideSpin $slideshowState}

#5. Slideshow spinbox
message .slideTxt -textvar f2.int -width 200
message .secTxt -text sec -width 100
spinbox .slideSpin -from 10 -to 600 -increment 10 -width 3
.slideSpin set $slideshow

if {!$slideshow} {
  .slideBtn deselect 
  set slideshowState 0
  .slideSpin configure -state disabled
} else {
  .slideBtn select
  set slideshowState 1
  .slideSpin configure -state normal
}

# setCanvasFont
##called by SetupDesktop ... ... ... spinboxes & ... fontweight Button
proc setCanvasFont {colour size} {
  global slideshowState 

#TODO set factor somewhere else
set factor 0.5
  
  #Fonts to adapt
  font conf intCanvFont -size $size -colour $colour
  font conf movingTextFont -size [expr $size * $factor] -colour $colour
  return 0
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

label .textposTxt -textvar textpos -font TkCaptionFont

createMovingTextBox $c

.textposCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
.textposCanv bind mv <Button1-Motion> [list dragCanvasItem %W mv %X %Y]


#2. Create InternationalText Canvas - Fonts based on System fonts, not Bdf!!!!
## Tcl picks any available Sans or Serif font from the system

##Create generic Serif or Sans font
font create intCanvFont -family $fontfamily -size $fontsize -weight $fontweight
font create widgetFont -family Serif -size 11 -weight normal -slant italic

canvas .inttextCanv -width 700 -height 150 -borderwidth 2 -relief raised

##create background image
image create photo intTextBG -file $SetupDesktopPng
.inttextCanv create image 0 0 -image intTextBG -anchor nw 

# Set international text
label .inttextTit -font TkCaptionFont -textvar f2.fontexpl

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
message .fontcolorTxt -width 50 -textvar f2.farbe -font widgetFont
spinbox .fontcolorSpin -width 20 -values {blue green gold silver} 
.fontcolorSpin conf -bg $fontcolor -fg white -font TkCaptionFont
.fontcolorSpin set $fontcolortext

#TODO include setCanvasFont 
.fontcolorSpin configure -command {
  %W conf -bg [set %s]
  setIntCanvText [set %s]
  .textposCanv itemconf mv -fill [set %s]
  #setCanvasFont
}

#2. Fontsize spinbox - TODO: IS THIS NEEDED????
if {!$fontsize} {
  #set initial font size if no $config found
  set screeny [winfo screenheight .]
  set fontsize [ expr round($screeny/40) ] 
}

message .fontsizeTxt -width 200 -textvar f2.fontsizetext -font widgetFont

#TODO include in setFont proc!
spinbox .fontsizeSpin -width 2 -values $fontSizeList -font TkCaptionFont -command {setCanvasFont $c}
#  font configure intCanvFont -size %s
#  font configure movingTextFont -size %s

.fontsizeSpin set $fontsize

#3. Fontweight checkbutton - TODO: needs reworking to be in line with FontNames
checkbutton .fontweightBtn -width 5 -variable fontweightState -textvar f2.fontweight -command {setCanvasFont}


#create sun / shade /main text
if {$fontweight=="bold"} {
  set fontweightState 1
  font configure intCanvFont -weight bold
} else {
  set fontweightState 0
  font configure intCanvFont -weight normal
}

#4. Fontfamily dropdown Menu
message .fontfamilyTxt -width 250 -textvar f2.fontfamilytext -font widgetFont
#ttk::combobox .fontfamilyDrop -width 20 -height 30 
#TODO how to do this? -command {setCanvasFont}

lappend Fontlist Serif Sans

source $ImgTools
setIntCanvText $fontcolor

##set fontfamily spinbox
spinbox .fontfamilySpin -width 20 -bg lightblue -font TkCaptionFont
.fontfamilySpin conf -values $Fontlist -validate focusin -validatecommand {
  font configure intCanvFont -family [.fontfamilySpin get]
  return 0
}
.fontfamilySpin set $fontfamily

#P A C K   R I G H T
#Top right
pack .showdateBtn -in .rtopF -anchor w
pack .slideBtn -in .rtopF -anchor w -side left
pack .secTxt .slideSpin .slideTxt -in .rtopF -anchor nw -side right

#Bottom 1.1
pack .inttextTit -in .rbot1F.1F -pady 7
#Bottom 1.2
pack .inttextCanv -in .rbot1F.2F -fill x
pack .fontcolorTxt .fontcolorSpin .fontfamilyTxt .fontfamilySpin -in .rbot1F.2F -side left -anchor n
pack .fontweightBtn .fontsizeSpin .fontsizeTxt -in .rbot1F.2F -side right -anchor n

#Bottom 2
pack .textposTxt -in .rbot2F -pady 7
pack .textposCanv -in .rbot2F -fill y

