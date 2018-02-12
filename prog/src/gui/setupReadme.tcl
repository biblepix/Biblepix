# ~/Biblepix/prog/src/share/setupReadme.tcl
# Loads README according to language setting
# Sourced by imgtools.tcl (bind flag button) &
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 29jan18

set chan [open $Readme]
fconfigure $chan -encoding utf-8
set readmetext [read $chan]
close $chan

set ::readmetext $readmetext

#set scrollbar
scrollbar .manualF.scroll -orient vertical -command {.manualF.man yview}
text .manualF.man -bg $bg -fg $fg -yscrollcommand {.manualF.scroll set}
pack configure .manualF.man -side left -fill both -expand yes
pack .manualF.scroll -side right -fill y

#set text by $lang (sourcing $Texts)
set readmeLang [setReadmeText $lang]
.manualF.man replace 1.1 end $readmeLang
.manualF.man configure -state disabled


