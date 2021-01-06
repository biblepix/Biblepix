# ~/Biblepix/prog/src/setup/setupDesktop.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 6jan21 pv

#Create left & right main frames
pack [frame .desktopF.leftF] -fill y -side left
pack [frame .desktopF.rightF] -fill y -side right -pady 5 -padx 5
#Create right subframes
pack [frame .rtopF -relief ridge -borderwidth 0]  -in .desktopF.rightF -fill x
pack [frame .rbot1F -relief ridge -borderwidth 3] -in .desktopF.rightF -pady $py -padx $px -fill x
pack [frame .rbot1F.1F] -fill x
pack [frame .rbot1F.2F] -fill x
pack [frame .rbot2F -relief ridge -borderwidth 3] -in .desktopF.rightF -pady $py -padx $px -fill both

##Create generic Serif or Sans font
font create intCanvFont -family $fontfamily -size $fontsize -weight $fontweight
font create widgetFont -family Serif -size 11 -weight normal -slant italic

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
canvas .textposCanv -bg lightgrey -borderwidth 1

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
message .slideSecTxt -text sec -width 100
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


#1. Create InternationalText Canvas - Fonts based on System fonts, not Bdf!!!!
    ## Tcl picks any available Sans or Serif font from the system
canvas .inttextCanv -width 700 -height 150 -borderwidth 0

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

set internationalText "$f2ltr_txt $f2ar_txt $f2he_txt\n$f2thai_txt\nAn Briathar"

source $ImgTools


#Get fontcolour arrayname & compute shade+sun hex (fontcolorHex already exists)
set shaHex [setShade ${fontcolortext}Arr ashex]
set sunHex [setSun ${fontcolortext}Arr ashex]

.inttextCanv create text 11 11 -anchor nw -text $internationalText -font intCanvFont -fill $shaHex -tags {shade txt mv}
.inttextCanv create text 9 9 -anchor nw -text $internationalText -font intCanvFont -fill $sunHex -tags {sun txt mv}
.inttextCanv create text 10 10 -anchor nw -text $internationalText -font intCanvFont -fill $fontcolorHex -tags {main txt mv}

#1. Fontcolour spinbox
message .fontcolorTxt -width 150 -textvar f2.farbe -font widgetFont
spinbox .fontcolorSpin -width 12 -values {Blue Green Gold Silver Black}
##make hex vars from colour names (to be reset in spinbox command)
set Blue   [rgb2hex BlueArr]
set Green  [rgb2hex GreenArr]
set Gold   [rgb2hex GoldArr] 
set Silver [rgb2hex SilverArr] 
set Black  [rgb2hex BlackArr] 

.fontcolorSpin conf -bg $fontcolorHex -fg white -font TkCaptionFont
.fontcolorSpin set $fontcolortext
.fontcolorSpin conf -command {
  %W conf -bg [set %s]
  setCanvasFontColour .textposCanv [set %s]
  setCanvasFontColour .inttextCanv [set %s]
}

#set Fontsize spinbox
message .fontsizeTxt -width 200 -textvar f2.fontsizetext -font widgetFont
spinbox .fontsizeSpin -width 2 -values $fontSizeList -bg lightgrey -font TkCaptionFont 
.fontsizeSpin conf -command {setCanvasFontSize %s}
.fontsizeSpin set $fontsize

#set Fontweight checkbutton
checkbutton .fontweightBtn -width 5 -variable fontweightState -font widgetFont -textvar f2.fontweight 
.fontweightBtn conf -command {
  if {$fontweightState} {
    setCanvasFontSize bold
  } else {
    setCanvasFontSize normal
  }
  return 0
}

#set Fontfamily spinbox
message .fontfamilyTxt -width 200 -textvar f2.fontfamilytext -font widgetFont
lappend Fontlist Serif Sans
spinbox .fontfamilySpin -width 12 -font TkCaptionFont -bg lightgrey
.fontfamilySpin conf -values $Fontlist -command {setCanvasFontSize %s}
.fontfamilySpin set $fontfamily

label .textposTxt -textvar textpos -font TkCaptionFont

#2. Create TextPos Canvas
set textPosFactor 3 ;#Verkleinerungsfaktor gegenüber real font size

#TODO WHERE is photosOrigPic? - clarify names!!!
image create photo photosOrigPic -file [getRandomPhotoPath]
image create photo textposCanvPic
textposCanvPic copy photosOrigPic -subsample $textPosFactor -shrink
set screeny [winfo screenheight .]
.textposCanv conf -width [image width textposCanvPic] -height [expr $screeny/$textPosFactor]
.textposCanv create image 0 0 -image textposCanvPic -anchor nw

createMovingTextBox .textposCanv

.textposCanv bind mv <1> {
     set ::x %X
     set ::y %Y
 }
 
#set up dragging item
lassign [.textposCanv bbox canvTxt] x1 y1 x2 y2
set itemW [expr $y2 - $y1]
puts "itemW $itemW"
set margin 15
#set font in pixels
.textposCanv bind mv <Button1-Motion> [list dragCanvasItem %W txt %X %Y $margin]
setCanvasFontSize $fontsize


setCanvasFontColour .textposCanv $fontcolorHex
#Footnote
label .textposFN -width 50 -font "Serif 10" -textvar ::textposFN

#P A C K   R I G H T
#Top right
pack .showdateBtn -in .rtopF -anchor w
pack .slideBtn -in .rtopF -anchor w -side left
pack .slideSecTxt .slideSpin .slideTxt -in .rtopF -anchor nw -side right

#Bottom 1.1
pack .inttextTit -in .rbot1F.1F -pady 7
#Bottom 1.2
pack .inttextCanv -in .rbot1F.2F -fill x

pack .fontcolorTxt .fontcolorSpin .fontfamilyTxt .fontfamilySpin -in .rbot1F.2F -side left -anchor n
pack .fontweightBtn .fontsizeSpin .fontsizeTxt -in .rbot1F.2F -side right -anchor n

#Bottom 2
pack .textposTxt -in .rbot2F -pady 7
pack .textposCanv -in .rbot2F -fill y
pack .textposFN -in .rbot2F -fill x
