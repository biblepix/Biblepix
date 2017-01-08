# ~/Biblepix/prog/src/gui/setupTerminal.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15dec16

pack [label .n.f4.t1 -textvar f4.tit -font bpfont3] -anchor w
message .n.f4.t2 -textvar f4.txt -font bpfont1 -width $tw -padx $px -pady $py
text .n.f4.t3 -height 1 -bg $bg

#Kopiertext
.n.f4.t3 insert end "echo \"sh $unixdir\/term.sh\" \>\> \~\/\.bashrc"
.n.f4.t3 configure -state disabled
pack .n.f4.t2 -anchor w -fill none
pack .n.f4.t3 -anchor w -fill x
pack [label .n.f4.t4 -font bpfont2 -textvar expl -anchor w]

#Beispielframe
pack [frame .n.f4.f1 -bg black]
pack [label .n.f4.f1.lb -width [expr $tw - 100] -bg black]
set padLeft 5
message .n.f4.bp1 -width $tw -bg blue -fg yellow -justify left -padx [expr 0 + $padLeft] -text "La Parole pour Lundi, 12 janvier 2017"
message .n.f4.bp2 -bg black -fg orange -justify left -width $tw -padx [expr 7 + $padLeft] -text "J\u00E9sus-Christ s\u2019est d\u00E9pouill\u00e9 lui-m\u00EAme
en prenant une condition de serviteur,
en devenant semblable aux autres humains."
message .n.f4.bp3 -bg black -fg $bg -justify left -padx [expr 0 + $padLeft] -width $tw -text "\t\t ~Philippiens 2,7"
message .n.f4.bp4 -bg black -fg orange -justify left -padx [expr 7 + $padLeft] -width $tw -text "Le Fils de l\u2019homme est venu, non pour \u00EAtre servi,
mais pour servir et donner sa vie en ran\u00e7on pour beaucoup."
message .n.f4.bp5 -bg black -fg $bg -width $tw  -padx [expr 0 + $padLeft] -text "\t\t ~Matthieu 8,28"
message .n.f4.localhost -bg black -fg green -width $tw -padx [expr 0 + $padLeft] -text "bibelpix@localhost"
message .n.f4.localhost2 -bg black -fg blue -padx 0 -width $tw -text "~$"

pack .n.f4.bp1 -in .n.f4.f1 -anchor w -fill none
pack .n.f4.bp2 .n.f4.bp3 .n.f4.bp4 .n.f4.bp5 -in .n.f4.f1 -anchor w -fill none
pack .n.f4.localhost .n.f4.localhost2 -in .n.f4.f1 -side left -fill x

