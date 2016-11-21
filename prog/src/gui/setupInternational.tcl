#Statusbar
frame .n.f1.f0 -padx $px
pack .n.f1.f0 -side bottom -fill x
label .n.f1.status -textvar status -font $f1 -height 1 -bg $bg -relief sunken
pack .n.f1.status -in .n.f1.f0 -fill x

#Refresh button
button .n.f1.refbtn -textvariable refresh -bg lightblue -command {set status [getRemoteTWDFileList]}
pack .n.f1.refbtn -side bottom -fill x -padx $px

#Title
label .n.f1.titel -textvar f1.tit -font $f3
message .n.f1.txt -textvar f1.txt -width $tw -font $f1 -padx $px -pady $py
pack .n.f1.titel .n.f1.txt -anchor w

#Locallist
frame .n.f1.f1 -padx $px
pack .n.f1.f1 -anchor w -fill x

label .n.f1.f1.twdlocaltit -textvar f1.twdlocaltit -bg $bg -font $f2
pack .n.f1.f1.twdlocaltit -anchor w -fill x
#set listbox
listbox .n.f1.f1.twdlocal -bg lightgreen -width $tw -height 0 -selectmode single -activestyle none
set twdlist [getTWDlist]
foreach i [lsort $twdlist] { .n.f1.f1.twdlocal insert end $i }
#set deletebutton
button .n.f1.f1.delbtn -bg $bg -textvar delete -command {file delete $twddir/[.n.f1.f1.twdlocal get active] ; .n.f1.f1.twdlocal delete [.n.f1.f1.twdlocal curselection]}
pack .n.f1.f1.delbtn -side right -fill none
pack .n.f1.f1.twdlocal -anchor w

#Remotelist
frame .n.f1.f2 -padx $px
pack .n.f1.f2 -anchor w -fill x

label .n.f1.f2.twdremotetit -textvar f1.twdremotetit -bg $bg -justify left -font $f2 -padx $px
pack .n.f1.f2.twdremotetit -fill x

pack [frame .n.f1.f3] -anchor w -fill x
label .n.f1.f3.twdremotetit2 -textvar f1.twdremotetit2 -width 0 -padx 20
pack .n.f1.f3.twdremotetit2 -side left

#remotelist inserted later by http.tcl
frame .n.f1.twdremoteframe -width $wWidth -padx $px
listbox .n.f1.twdremoteframe.lb -yscrollcommand {.n.f1.twdremoteframe.sb set} -selectmode multiple -activestyle none -font TkFixedFont -width [expr $wWidth - 50] -height [expr $wHeight - 300] -bg lightblue
scrollbar .n.f1.twdremoteframe.sb -command {.n.f1.twdremoteframe.lb yview}

pack .n.f1.twdremoteframe -anchor w
pack .n.f1.twdremoteframe.sb -side right -fill y
pack .n.f1.twdremoteframe.lb -side left -fill x

# ??? source $Http
