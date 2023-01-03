# ~/Biblepix/prog/src/setup/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 3jan23 pv

#Set frames MainLeft + MainRight
pack [frame .welcomeLeftMainF]  -in .welcomeF -fill y -anchor nw -side left -padx $px
pack [frame .welcomeRightMainF] -in .welcomeF -fill both -anchor nw -side right -expand 1 -pady $py -padx $px
pack [frame .welcomeTopLeftF] -in .welcomeLeftMainF -anchor nw
pack [frame .welcomeBotLeftF] -in .welcomeLeftMainF -anchor nw -fill y -expand 1

#Set headings & messages
label .welcomeTitL -font bpfont3 -textvar msg::welcTit 
pack .welcomeTitL -in .welcomeTopLeftF -anchor nw
label .welcomeSubtit1L -font bpfont2 -textvar msg::welcSubtit1 -padx $px -pady $py 
message .welcomeWhatisTxtM -textvar msg::welcTxt1 -font bpfont1 -width [expr $wWidth/2] -padx $px 
pack .welcomeSubtit1L -in .welcomeTopLeftF -anchor nw
pack .welcomeWhatisTxtM -in .welcomeTopLeftF -anchor nw

#Set up label left
label .welcomeSubtit2L -font bpfont2 -textvar msg::welcSubtit2 -padx $px -pady $py 
pack .welcomeSubtit2L -in .welcomeTopLeftF -anchor nw
#Set up text widget left 
text .welcomeT -padx $px -pady $py -borderwidth 0 -bg [. cget -bg] -font bpfont1 -tabs {5c left} -wrap word
pack .welcomeT -in .welcomeTopLeftF -anchor nw
catch {fillWelcomeTextWidget .welcomeT}

#Set Next button right
button .twdClickBtn -textvar msg::next -font bpfont2
set twdL [glob -nocomplain $twddir/*.twd]
if {[llength $twdL] <2 } {
  .twdClickBtn conf -state disabled
}

#Set up Twd widget right (variable width & height, defined in frame)
text .twdWidgetT -foreground maroon -pady 30 -padx 30 -border 7 -tabs 7c -font twdwidgetfont -background #bab86c 
pack .twdClickBtn .twdWidgetT -in .welcomeRightMainF -anchor n -pady 15 -expand 1
.twdClickBtn conf -command {insertTodaysTwd .twdWidgetT}
.twdWidgetT tag conf text -font twdwidgetfont -justify left
if $enabletitle {
  .twdWidgetT tag conf head -font "TkHeadingFont 16 bold" -justify left
}

.twdWidgetT tag conf ref -font TkCaptionFont -justify right
insertTodaysTwd .twdWidgetT

#Set Uninstall button
button .uninstallBtn -textvar msg::uninst -command {source $Uninstall}
pack .uninstallBtn -in .welcomeBotLeftF -anchor sw -side bottom
