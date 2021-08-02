# ~/Biblepix/prog/src/gui/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 2aug21 pv

#Pack flags defined elsewhere
pack .en .de -in .ftop -side right

#Set frames MainLeft + MainRight
pack [frame .welcomeLeftMainF]  -in .welcomeF -fill y -anchor nw -side left -padx 30
pack [frame .welcomeRightMainF] -in .welcomeF -fill both -anchor nw -side right -expand 1 -pady 30 -padx 20
pack [frame .leftTopF] -in .welcomeLeftMainF -anchor nw
pack [frame .leftBotF] -in .welcomeLeftMainF -anchor nw -fill y -expand 1

#Set headings & messages
label .welcomeTit -font bpfont3 -textvar msg::welcTit
pack .welcomeTit -in .leftTopF -anchor nw

label .welcomeSubtit1 -font bpfont2 -textvar msg::welcSubtit1 -padx $px -pady $py

message .welcomeWhatisTxt -textvar msg::welcTxt1 -font bpfont1 -width [expr $wWidth/2] -justify left -padx $px
pack .welcomeSubtit1 -in .leftTopF -anchor nw
pack .welcomeWhatisTxt -in .leftTopF -anchor nw

#Set TheWord Button right
button .twdClickBtn -textvar msg::next -font bpfont2
set twdL [glob -nocomplain $twddir/*.twd]
if {[llength $twdL] <2 } {
  .twdClickBtn conf -state disabled
}

#set up twd text widget
text .twdWidgetT -width 80 -background beige -foreground maroon -pady 30 -padx 30 -border 5 -tabs 7c
pack .twdClickBtn .twdWidgetT -in .welcomeRightMainF -anchor n -pady 15
.twdClickBtn conf -command {insertTodaysTwd .twdWidgetT}

.twdWidgetT tag conf text -justify left -font "TkTextFont 12"
.twdWidgetT tag conf head -font "TkHeadingFont 16 bold" -justify left
.twdWidgetT tag conf ref -font "TkTextFont 11 italic" -justify right
insertTodaysTwd .twdWidgetT
 
#Set text2 bottom left
label .welcomeSubtit2 -font bpfont2 -textvar msg::welcSubtit2 -padx $px -pady $py
pack .welcomeSubtit2 -in .leftTopF -anchor nw

#Create text widget
text .welcomeT -width 80 -padx $px -pady $py -borderwidth 0 -bg #d9d9d9 -font bpfont1 -tabs {5c left}	
pack .welcomeT -in .leftTopF -anchor nw
fillWelcomeTWidget .welcomeT

#Uninstall button
button .uninstallBtn -textvar msg::uninst -command {source $Uninstall}
pack .uninstallBtn -in .leftBotF -anchor sw -side bottom
