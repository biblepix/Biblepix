# ~/Biblepix/prog/src/setup/setupDesktop.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 9aug21 pv

#Create left & right main frames
pack [frame .desktopF.leftF] -fill y -side left
pack [frame .desktopF.rightF] -fill both -side right -expand 1
##right top frames
pack [frame .topMainF1] -in .desktopF.rightF -fill x
pack [frame .topMainF2 -relief ridge -bd 3 -padx $px -pady $py] -in .desktopF.rightF -fill x
##right middle frames
pack [frame .midMainF -padx $px -pady $py] -in .desktopF.rightF -fill x
pack [frame .leftF] -in .midMainF -side left
pack [frame .midF] -in .midMainF -expand 1 -side left
pack [frame .rightF] -in .midMainF -side right
##right bottom frame
pack [frame .botMainF -relief ridge -borderwidth 3] -in .desktopF.rightF -pady $py -padx $px -fill x

##Create generic Serif or Sans font
font create intCanvFont -family $fontfamily -size $fontsize -weight $fontweight

# F I L L   L E F T 

#Create title + main text
label .title -textvar msg::f2Tit -font bpfont3
message .mainTxt -textvar msg::f2Txt -font bpfont1 -width [expr int(0.3 * $wWidth)] -padx $px -pady $py -justify left
.mainTxt conf -padx 30
#Create ImageYesno checkbutton 
checkbutton .imgyesnoCB -textvar msg::f2Box -variable imgyesState -width 20 -justify left -command {setSpinState $imgyesState}
if $enablepic {set imgyesState 1} else {set imgyesState 0}

#P A C K   L E F T 
pack .title -in .desktopF.leftF -anchor w
pack .imgyesnoCB -in .desktopF.leftF -side top -anchor w
pack .mainTxt -in .desktopF.leftF -anchor nw

# F I L L   R I G H T
##create canvases
set textposC [canvas .textposCanv -bg lightgrey -borderwidth 1]
set inttextC [canvas .inttextCanv]

#3. ShowDate checkbutton
checkbutton .showdateBtn -textvar msg::f2Introline -variable enabletitle
.showdateBtn configure -command {
  if {$setupTwdFileName != ""} {
    $textposC itemconf mv -text [getTodaysTwdText $setupTwdFileName]
  }
}

#4. SlideshowYesNo checkbutton
checkbutton .slideBtn -textvar msg::f2Slideshow -variable slideshowState -command {setSlideSpin $slideshowState} -padx 20

#5. Slideshow spinbox
message .slideTxt -textvar msg::f2Interval -width 200
message .slideSecTxt -textvar msg::sec -width 100
spinbox .slideSpin -from 10 -to 600 -increment 10 -width 3
.slideSpin set $slideshow

if !$slideshow {
  .slideBtn deselect 
  set slideshowState 0
  .slideSpin configure -state disabled
} else {
  .slideBtn select
  set slideshowState 1
  .slideSpin configure -state normal
}

#1. Create InternationalText Canvas - Fonts based on System fonts, not Bdf!!!!
## Tk picks any available Sans or Serif font from the system
##create background image

#Create international text canvas
#set relW [expr int(0.7 * $wWidth)]
$inttextC conf -height 100 -width 1000 
##sky + hill contour
$inttextC conf -bg green
$inttextC create polygon 0 0 0 100 100 95 200 90 300 85 400 80 500 70 650 20 700 10 750 30 800 50 900 70 1000 0 -tags {poly} -fill skyblue
##sun
$inttextC create oval 850 60 900 10 -fill orange -outline gold -width 2 -tags poly
##scale width if window too narrow
if {$screenX <= 1400} {
  set scalefactor 0.6
} elseif {$screenX <= 1600} {
  set scalefactor 0.8
} else {
  set scalefactor 1.0
}
$inttextC scale poly 0 0 $scalefactor $scalefactor

#Set up international texts
set ar_txt [mc f2ar_txt]
set he_txt [mc f2he_txt]
if {$platform=="unix"} {
  set ar_txt [string reverse $ar_txt]
  set he_txt [string reverse $he_txt]
}
set internationalText "[mc f2ltr1_txt]   $ar_txt   $he_txt \n [mc f2ltr2_txt]"

##get fontcolour arrayname & compute shade+sun hex (fontcolorHex already exists)
puts "Computing fontcolor..."
source $ImgTools
lassign [setFontShades $fontcolortext] regHex sunHex shaHex
$inttextC create text 11 11 -anchor nw -text $internationalText -font intCanvFont -fill $shaHex -tags {shade txt mv}
$inttextC create text 9 9 -anchor nw -text $internationalText -font intCanvFont -fill $sunHex -tags {sun txt mv}
$inttextC create text 10 10 -anchor nw -text $internationalText -font intCanvFont -fill $regHex -tags {main txt mv}
setCanvasFontColour $textposC $fontcolortext
setCanvasFontColour $inttextC $fontcolortext

#1. Fontcolour spinbox
message .fontcolorTxt -width 150 -textvar msg::f2Farbe ;#-font widgetFont
foreach colname $fontcolourL {
  set $colname [set colour::${colname}]
}
proc setFontcolSpinState {} {
  global enableRandomFontcolor
  if $enableRandomFontcolor {
    .fontcolorSpin conf -state disabled
  } else {
    .fontcolorSpin conf -state normal
  }
}
spinbox .fontcolorSpin -width 7 -values $fontcolourL
.fontcolorSpin conf -bg $regHex -fg white
.fontcolorSpin set $fontcolortext

.fontcolorSpin conf -command {
  lassign [setFontShades %s] regHex sunHex shaHex
  %W conf -bg $regHex
  setCanvasFontColour $textposC %s
  setCanvasFontColour $inttextC %s
  set ::fontcolortext %s
}
setFontcolSpinState

#set Fontsize spinbox
message .fontsizeTxt -width 200 -textvar msg::f2Fontsize
spinbox .fontsizeSpin -width 2 -values $fontSizeL -bg lightgrey
.fontsizeSpin conf -command {setCanvasFontSize %s}
.fontsizeSpin set $fontsize

#set Fontweight checkbutton
checkbutton .fontweightBtn -variable fontweightState -textvar msg::f2Fontweight
.fontweightBtn conf -command {
  if {$fontweightState} {
    setCanvasFontSize bold
  } else {
    setCanvasFontSize normal
  }
  return 0
}

#Random fontcolour change checkbutton
checkbutton .randomfontcolorCB -anchor w -variable enableRandomFontcolor -textvar msg::random
.randomfontcolorCB conf -command setFontcolSpinState

#set Fontfamily spinbox
message .fontfamilyTxt -width 200 -textvar msg::f2Fontfamily
lappend Fontlist Serif Sans
spinbox .fontfamilySpin -width 7 -bg lightgrey
.fontfamilySpin conf -values $Fontlist -command {setCanvasFontSize %s}
.fontfamilySpin set $fontfamily

label .textposL -textvar msg::textposlabel -font TkCaptionFont
label .fontAdaptL -textvar msg::f2Fontexpl -font TkCaptionFont

#2. Create TextPos Canvas
set textPosFactor 3 ;#Verkleinerungsfaktor gegenüber real font size
set picPath [getRandomPhotoPath]
image create photo photosOrigPic -file $picPath
image create photo textposCanvPic
textposCanvPic copy photosOrigPic -subsample $textPosFactor -shrink
set screeny [winfo screenheight .]
$textposC conf -width [image width textposCanvPic] -height [expr $screeny/$textPosFactor]
$textposC create image 0 0 -image textposCanvPic -anchor nw

#Copy margins to ::colour, to be changed later
namespace eval colour {
  variable marginleft $::marginleft
  variable margintop $::margintop
}
createMovingTextBox $textposC
$textposC bind mv <1> {
  set ::x %X
  set ::y %Y
}

#set up dragging item
lassign [$textposC bbox canvTxt] x1 y1 x2 y2
set itemW [expr $y2 - $y1]
set margin 15

#set font in pixels
$textposC bind mv <Button1-Motion> [list dragCanvasItem %W txt %X %Y $margin]
setCanvasFontSize $fontsize
setCanvasFontSize $fontweight
setCanvasFontColour $textposC $fontcolortext
#setCanvasFontColour $textposC $fontcolortext $lum

#Footnote for Arabic+Hebrew text shift (only if found)
##create RtL info on text positioning
set RtlInfo ""
##Hebrew
if ![catch "glob $twddir/he_*"] {
  set msgHe "[mc RtlInfoHe]"
  if {$os=="Linux"} {
    set msgHe [string reverse $msgHe]
  }
  lappend RtlInfo $msgHe
}
##Arabic
if ![catch "glob $twddir/ar_*"] {
  set msgAr [mc RtlInfoAr]
  if {$os=="Linux"} {
    source $Bidi
    set msgAr [bidi::fixBidi $msgAr] 
  }
  lappend RtlInfo $msgAr
}
label .textposFN -width 50 -font "Serif 10" -textvar RtlInfo
# P A C K   R I G H T
##top
pack .showdateBtn -in .topMainF1 -anchor w -side left
pack .slideSecTxt .slideSpin .slideTxt .slideBtn -in .topMainF1 -anchor nw -side right
pack .fontAdaptL -in .topMainF2 -anchor n
pack $inttextC -in .topMainF2 -fill x -anchor n
##middle
pack .fontcolorTxt .fontcolorSpin .randomfontcolorCB -in .leftF -side left
pack .fontsizeSpin .fontsizeTxt -in .midF -side right
pack .fontfamilyTxt .fontfamilySpin .fontweightBtn -in .rightF -side left
##bottom
pack .textposL -in .botMainF -pady 7
pack $textposC -in .botMainF -fill y
pack .textposFN -in .botMainF -fill x
