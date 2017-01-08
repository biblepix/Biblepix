# ~/Biblepix/prog/src/gui/setupPhotos.tcl
# Sourced by setupGUI
# Authors: Peter Vollmar & Joel Hochreutener, biblepix.vollmar.ch
# Updated 15dec16

set fileJList ""
source $JList
set HOME "$env(HOME)"

if {$platform == "unix"} {
	#Bildordner names change with language!
	set bildordner $HOME
        
        if { [file exists $HOME/Pictures] } {
		set bildordner $HOME/Pictures
        } elseif { [file exists $HOME/Bilder] } {
        	set bildordner $HOME/Bilder
        }
        # ADD MORE LANGUAGES !!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        set types {
		{ {Image Files} {.jpg .jpeg .JPG .JPEG} }
	}
        
} elseif {$platform == "windows"} {
	#Bildordner is always "Pictures"
	set bildordner $env(USERPROFILE)/Pictures
	set types {
		{ {Image Files} {.jpg .jpeg} }
	}
}

#Create Titel
label .n.f6.l1 -textvar f6.tit -font bpfont3 -justify left
pack .n.f6.l1 -anchor w

#Content
pack [frame .n.f6.content] -anchor w -fill both

#Create Text
message .n.f6.content.right -textvar f6.txt -font bpfont1 -width 250 -padx $px -pady $py
pack .n.f6.content.right -anchor nw -side left -padx {10 40} -pady 40

pack [frame .n.f6.content.left] -side left

#Create Photo bar
pack [frame .n.f6.content.left.bar] -anchor w

#Build Photo bar
button .n.f6.content.left.bar.open -textvar f6.find -bg lightblue -command {set fileJList [doOpen $bildordner .n.f6.content.left.bild.c]}
button .n.f6.content.left.bar.< -text < -command {set fileJList [step $fileJList 0 .n.f6.content.left.bild.c]} -bg lightblue
button .n.f6.content.left.bar.> -text > -command {set fileJList [step $fileJList 1 .n.f6.content.left.bild.c]} -bg lightblue

label .imgName -textvar imgName

button .n.f6.content.left.bar.collect -textvar f6.show -bg gold -command {set fileJList [doCollect .n.f6.content.left.bild.c]}

foreach button [winfo children .n.f6.content.left.bar] {
	$button configure -height 1
	pack $button -side left -fill x
}

#Create bottom frame
frame .n.f6.content.left.unten -pady 7
pack .n.f6.content.left.unten -side bottom -anchor nw -fill both

#create canvas
pack [frame .n.f6.content.left.bild -relief sunken -bd 3] -anchor w -pady 5
set imgCanvas [canvas .n.f6.content.left.bild.c -width 650 -height 400]
pack $imgCanvas -in .n.f6.content.left.bild -side left
image create photo imgPhoto
$imgCanvas create image 10 10 -image imgPhoto

button .add
button .del

.add conf -textvar f6.add -bg green -command {addPic $imgName}
.del conf -textvar f6.del -bg red -command {delPic $imgName}

set fileJList [doCollect .n.f6.content.left.bild.c]

