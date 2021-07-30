# ~/Biblepix/prog/src/gui/setupWelcome.tcl
# Sourced by SetupGUI
# Authors: Peter Vollmar, Joel Hochreutener, biblepix.vollmar.ch
# Updated: 30jul21 pv

#Pack flags defined elsewhere
pack .en .de -in .ftop -side right

#Set frames MainLeft + MainRight
pack [frame .welcomeLeftMainF] -in .welcomeF -fill y -anchor nw -side left
pack [frame .welcomeRightMainF] -in .welcomeF -fill both -anchor nw -side right -expand 1 -pady 30 -padx 20
pack [frame .leftTopF] -in .welcomeLeftMainF -anchor nw
pack [frame .leftBotF] -in .welcomeLeftMainF -anchor nw -fill y -expand 1

#Set headings & messages
label .welcomeTit -font bpfont3 -text "[mc welcTit]"
pack .welcomeTit -in .leftTopF -anchor nw

label .welcomeSubtit1 -font bpfont2 -text "[mc welcSubtit1]" -padx $px -pady $py
message .welcomeWhatisTxt -text "[mc welcTxt1]" -font bpfont1 -width [expr $wWidth/2] -justify left -padx $px
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
text .twdWidgetT -width 70 -font twdwidgetfont -background beige -foreground maroon -pady 20 -padx 20 -border 5 -tabs 7c
pack .twdClickBtn .twdWidgetT -in .welcomeRightMainF -anchor n -pady 15
.twdClickBtn conf -command {insertTodaysTwd .twdWidgetT}

insertTodaysTwd .twdWidgetT
.twdWidgetT tag add intro 1.0 1.end 
.twdWidgetT tag conf intro -font "TkCaptionFont 20"
 
#Set text2 bottom left
label .welcomeSubtit2 -font bpfont2 -text "[mc welcSubtit2]" -padx $px -pady $py
pack .welcomeSubtit2 -in .leftTopF -anchor nw

#Create text widget
text .welcomeTxt -width 80 -padx $px -pady $py -border 0 -bg $bg -font bpfont1 -tabs {5c left}	
pack .welcomeTxt -in .leftTopF -anchor nw
.welcomeTxt insert 1.0 "[mc welcTxt2]"
.welcomeTxt tag conf bold -font TkCaptionFont

#Set keyword: to bold
set lines [.welcomeTxt count -lines 1.0 end]
puts $lines
for {set line 1} {$line <= $lines} {incr line} {
puts $line
  set colon [.welcomeTxt search : $line.0 $line.end]
  puts $colon
  .welcomeTxt tag add bold $line.0 $colon 
}

#Uninstall button
button .uninstallBtn -text "[mc uninst]" -command {source $Uninstall}
pack .uninstallBtn -in .leftBotF -anchor sw -side bottom
