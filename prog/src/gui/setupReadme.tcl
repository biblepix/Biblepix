# ~/Biblepix/prog/src/share/setupReadme.tcl
# Loads README according to language setting
# Sourced by imgtools.tcl (bind flag button) &
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 21nov16

set chan [open $Readme]
fconfigure $chan -encoding utf-8
set readmetext [read $chan]
close $chan

set ::readmetext $readmetext

#set scrollbar
scrollbar .n.f5.scroll -orient vertical -command ".n.f5.man yview"
text .n.f5.man -bg $bg -fg $fg -yscrollcommand {.n.f5.scroll set}
pack configure .n.f5.man -side left -fill both -expand yes
pack .n.f5.scroll -side right -fill y

#set text by $lang (sourcing $Texts)
set readmeLang [setReadmeText $lang]
.n.f5.man replace 1.1 end $readmeLang
.n.f5.man configure -state disabled


