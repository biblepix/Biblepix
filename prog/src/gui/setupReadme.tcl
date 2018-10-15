# ~/Biblepix/prog/src/share/setupReadme.tcl
# Loads README according to language setting
# Sourced by imgtools.tcl (bind flag button) &
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated: 3oct18


#set Manual $Manual_$lang.txt


#set chan [open $Manual]
#fconfigure $chan -encoding utf-8
#set ::manText [read $chan]
#close $chan

#Create text widget & scrollbar
scrollbar .manualF.scroll -orient vertical -command {.manualF.man yview}
text .manualF.man -bg $bg -fg $fg -yscrollcommand {.manualF.scroll set} -font "TkTextFont 14"
setManText $lang

#set text by $lang (sourcing $Texts)
#set readmeLang [setManText $lang]
#.manualF.man replace 1.1 end $readmeLang
#.manualF.man configure -state disabled

  
#set scrollbar
pack .manualF.man -side left -fill both -expand yes
pack .manualF.scroll -side right -fill y
