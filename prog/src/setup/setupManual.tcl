# ~/Biblepix/prog/src/setup/setupManual.tcl
# Loads README according to language setting
# Sourced by imgtools.tcl (bind flag button) &
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 15nov21

#Create language buttons
pack [frame .manualFlagF] -in .manualF -fill x
flag::show .manualFlagEn -flag {hori blue; x white red; cross white red}
flag::show .manualFlagDe -flag {hori black red yellow} 
pack .manualFlagEn .manualFlagDe -in .manualFlagF -anchor nw -side left

#Create text widget & scrollbar
scrollbar .manSB -orient vertical -command {.manT yview}
text .manT -bg $bg -fg $fg -yscrollcommand {.manSB set} -font "TkTextFont 14"

#Pack text & scrollbar
pack .manT -in .manualF -side left -fill both -expand 1
pack .manSB -in .manualF -side right -fill y

#Bind lang buttons & fill Manpage
bind .manualFlagEn <1> {setManText en}
bind .manualFlagDe <1> {setManText de}

setManText $lang
