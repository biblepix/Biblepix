# ~/Biblepix/prog/src/share/setupReadme.tcl
# Loads README according to language setting
# Sourced by imgtools.tcl (bind flag button) &
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 9dec18

#Create text widget & scrollbar
scrollbar .manualF.scroll -orient vertical -command {.manualF.man yview}
text .manualF.man -bg $bg -fg $fg -yscrollcommand {.manualF.scroll set} -font "TkTextFont 14"
setManText $lang

#set scrollbar
pack .manualF.man -side left -fill both -expand yes
pack .manualF.scroll -side right -fill y
