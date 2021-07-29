# ~/Biblepix/prog/src/gui/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 24apr21 pv

#Pack flags defined elsewhere
pack .en .de -in .ftop -side right

#Set frames MainLeft + MainRight
pack [frame .welcomeLeftMainF] -in .welcomeF -fill y -anchor nw -side left
pack [frame .welcomeRightMainF] -in .welcomeF -fill both -anchor nw -side right -expand 1 -pady 30 -padx 20
pack [frame .leftTopF] -in .welcomeLeftMainF -anchor nw
pack [frame .leftBotF] -in .welcomeLeftMainF -anchor nw -fill y -expand 1

#Set headings & messages
label .welcomeTit -font bpfont3 -text "[mc welc.tit]"
pack .welcomeTit -in .leftTopF -anchor nw

label .welcomeSubtit1 -font bpfont2 -textvar welc.subtit1 -padx $px -pady $py
message .welcomeWhatisTxt -textvar welc.txt1 -font bpfont1 -width [expr $wWidth/2] -justify left -padx $px
pack .welcomeSubtit1 -in .leftTopF -anchor nw
pack .welcomeWhatisTxt -in .leftTopF -anchor nw

#Set TheWord Button right
button .twdClickBtn -text "[mc welcClickTwd]" -font bpfont2
set twdL [glob -nocomplain $twddir/*.twd]
if {[llength $twdL] <2 } {
  .twdClickBtn conf -state disabled
}


#TODO Linux:Arabic + Hebrew vowels are never placed correctly, needs at least Serif, but perhaps there are better fonts...
#set twdWidget [button .welcomeTwdBtn -font twdwidgetfont -bg $bg -activebackground lightblue -fg blue -pady 20 -padx 20 -bd 7] 
text .twdWidgetT -font twdwidgetfont -background $bg -foreground lightblue -pady 20 -padx 20 -border 7
pack .twdClickBtn .twdWidgetT -in .welcomeRightMainF -anchor n -pady 15
.twdClickBtn conf -command {insertTodaysTwd .twdWidgetT}

insertTodaysTwd .twdWidgetT
.twdWidgetT tag add intro 1.0 1.end 
.twdWidgetT tag conf intro -background lightgreen -font bold
 
#Set text2 bottom left
text .welcomeTxt 
.welcomeTxt insert 1.0 "[mc welc.subtit2]"
.welcomeTxt insert 1.end "[mc welc.txt2]"
.welcomeTxt insert 1.end "[mc welc.txt3]" 

#label .welcomeSubtit2 -font bpfont2 -textvar welc.subtit2 -padx $px -pady $py
#message .possibilities1Txt -textvar welc.txt2 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
#message .possibilities2Txt -textvar welc.txt3 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
#message .possibilities3Txt -textvar welc.txt4 -font bpfont1 -width $tw -justify left -pady 0 -padx $px
#pack as needed by OS
#pack .welcomeSubtit2 .possibilities1Txt -anchor nw -in .leftBotF

#if {$platform=="unix"} {pack .possibilities2Txt -anchor nw -in .leftBotF}
#pack .possibilities3Txt -anchor nw -in .leftBotF

#Uninstall button
button .uninstallBtn -textvar uninst -command {source $Uninstall}
pack .uninstallBtn -in .leftBotF -anchor sw -side bottom
