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
scrollbar .nb.manual.scroll -orient vertical -command {.nb.manual.man yview}
text .nb.manual.man -bg $bg -fg $fg -yscrollcommand {.nb.manual.scroll set}
pack configure .nb.manual.man -side left -fill both -expand yes
pack .nb.manual.scroll -side right -fill y

#set text by $lang (sourcing $Texts)
set readmeLang [setReadmeText $lang]
.nb.manual.man replace 1.1 end $readmeLang
.nb.manual.man configure -state disabled


